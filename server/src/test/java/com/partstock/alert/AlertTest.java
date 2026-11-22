package com.partstock.alert;

import static org.assertj.core.api.Assertions.assertThat;
import static org.hamcrest.Matchers.hasSize;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.partstock.TestcontainersConfiguration;
import com.partstock.price.DailyPriceStore;
import com.partstock.price.PriceStats;
import com.partstock.price.SnapshotStore;
import com.partstock.ticker.TickerStore;
import java.time.Instant;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Import;
import org.springframework.context.annotation.Primary;
import org.springframework.http.MediaType;
import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.test.web.servlet.MockMvc;

/** 목표가 알림: API로 걸고, 시세가 닿으면 한 번 보내고 끈다. 실제 PostgreSQL + 가짜 푸시. */
@SpringBootTest(properties = {"partstock.collect.cron=-", "partstock.alert.max-per-device=2"})
@AutoConfigureMockMvc
@Import({TestcontainersConfiguration.class, AlertTest.FakePushConfig.class})
class AlertTest {

	static final Instant NOW = Instant.parse("2026-11-20T03:00:00Z");
	static final LocalDate DAY = LocalDate.of(2026, 11, 20);

	@Autowired MockMvc mvc;
	@Autowired JdbcClient jdbc;
	@Autowired TickerStore tickers;
	@Autowired DailyPriceStore prices;
	@Autowired SnapshotStore snapshots;
	@Autowired AlertService alerts;
	@Autowired FakePush push;

	@BeforeEach
	void setUp() throws Exception {
		jdbc.sql("delete from price_alert").update();
		jdbc.sql("delete from device").update();
		jdbc.sql("delete from daily_price").update();
		jdbc.sql("delete from price_snapshot").update();
		jdbc.sql("delete from fx_rate").update();
		tickers.syncChipsets();
		jdbc.sql("""
				insert into ticker (key, level, category, chipset_key, maker_key, series_key, display_name) values
				('rtx-5070-ti/msi/gaming-trio', 'MODEL', 'GPU', 'rtx-5070-ti', 'msi', 'gaming-trio', 'Gaming Trio')
				on conflict do nothing
				""").update();
		jdbc.sql("insert into fx_rate (day, usd_krw) values ('2026-11-20', 1300.00)").update();
		push.results.clear();
		push.sent.clear();
		register("phone-a", "ko-KR");
		register("phone-b", "en-US");
	}

	void register(String token, String locale) throws Exception {
		mvc.perform(post("/api/devices").contentType(MediaType.APPLICATION_JSON)
				.content("{\"token\":\"" + token + "\",\"platform\":\"ANDROID\",\"locale\":\"" + locale + "\"}"))
				.andExpect(status().isNoContent());
	}

	long create(String token, String key, String dir, long cents) throws Exception {
		String body = mvc.perform(post("/api/alerts").header("X-Device-Token", token)
						.contentType(MediaType.APPLICATION_JSON)
						.content("{\"tickerKey\":\"" + key + "\",\"direction\":\"" + dir + "\",\"targetCents\":" + cents + "}"))
				.andExpect(status().isCreated())
				.andReturn().getResponse().getContentAsString();
		return Long.parseLong(body.replaceAll(".*\"id\":(\\d+).*", "$1"));
	}

	void price(String key, long p25) {
		PriceStats s = new PriceStats(p25 + 1000, p25, p25 + 2000, p25 - 500, p25 + 5000, 10, 12);
		snapshots.upsert(key, NOW, s);
		prices.upsert(key, DAY, s);
	}

	@Test
	void 알림을_걸고_보고_지운다_다른_기기_것은_못_지운다() throws Exception {
		long id = create("phone-a", "rtx-5070-ti/msi/gaming-trio", "BELOW", 140_000);

		mvc.perform(get("/api/alerts").header("X-Device-Token", "phone-a"))
				.andExpect(jsonPath("$", hasSize(1)))
				.andExpect(jsonPath("$[0].tickerName").value("RTX 5070 Ti · MSI Gaming Trio"))
				.andExpect(jsonPath("$[0].direction").value("BELOW"))
				.andExpect(jsonPath("$[0].firedAt").doesNotExist());
		mvc.perform(get("/api/alerts").header("X-Device-Token", "phone-b")).andExpect(jsonPath("$", hasSize(0)));

		mvc.perform(delete("/api/alerts/" + id).header("X-Device-Token", "phone-b")).andExpect(status().isNotFound());
		mvc.perform(delete("/api/alerts/" + id).header("X-Device-Token", "phone-a")).andExpect(status().isNoContent());
	}

	@Test
	void 잘못된_요청() throws Exception {
		mvc.perform(get("/api/alerts")).andExpect(status().isBadRequest());
		mvc.perform(get("/api/alerts").header("X-Device-Token", "never-registered")).andExpect(status().isNotFound());
		mvc.perform(post("/api/alerts").header("X-Device-Token", "phone-a").contentType(MediaType.APPLICATION_JSON)
				.content("{\"tickerKey\":\"rtx-5090\",\"direction\":\"SIDEWAYS\",\"targetCents\":1}"))
				.andExpect(status().isBadRequest());
		mvc.perform(post("/api/alerts").header("X-Device-Token", "phone-a").contentType(MediaType.APPLICATION_JSON)
				.content("{\"tickerKey\":\"nope\",\"direction\":\"BELOW\",\"targetCents\":1}"))
				.andExpect(status().isNotFound());
		// 기기당 대기 중 2개까지(테스트 설정)
		create("phone-a", "rtx-5090", "BELOW", 1);
		create("phone-a", "rtx-5080", "BELOW", 1);
		mvc.perform(post("/api/alerts").header("X-Device-Token", "phone-a").contentType(MediaType.APPLICATION_JSON)
				.content("{\"tickerKey\":\"rtx-5070\",\"direction\":\"BELOW\",\"targetCents\":1}"))
				.andExpect(status().isConflict());
	}

	@Test
	void 대표가가_목표에_닿으면_한_번_보내고_끈다() throws Exception {
		long below = create("phone-a", "rtx-5070-ti", "BELOW", 140_000);
		long notYet = create("phone-b", "rtx-5070-ti", "BELOW", 100_000);
		price("rtx-5070-ti", 139_000);

		var r = alerts.checkAndSend();

		assertThat(r.sent()).isEqualTo(1);
		assertThat(push.sent).singleElement().satisfies(m -> {
			assertThat(m.token()).isEqualTo("phone-a");
			assertThat(m.title()).isEqualTo("RTX 5070 Ti 목표가 도달");
			// 1,390달러 × 1,300원 = 180.7만원, 목표 1,400달러 = 182.0만원
			assertThat(m.body()).isEqualTo("지금 180.7만원 · 목표 182.0만원 이하");
			assertThat(m.data()).containsEntry("tickerKey", "rtx-5070-ti");
		});
		assertThat(firedCents(below)).isEqualTo(139_000);
		assertThat(firedCents(notYet)).isNull();

		push.sent.clear();
		alerts.checkAndSend();
		assertThat(push.sent).isEmpty(); // 이미 울린 알림은 다시 안 보낸다
	}

	@Test
	void 영어_기기는_달러로_이상_조건() throws Exception {
		create("phone-b", "rtx-5070-ti", "ABOVE", 150_000);
		price("rtx-5070-ti", 151_000);

		alerts.checkAndSend();

		assertThat(push.sent).singleElement().satisfies(m -> {
			assertThat(m.title()).isEqualTo("RTX 5070 Ti hit your target");
			assertThat(m.body()).isEqualTo("Now $1,510 · target ≥ $1,500");
		});
	}

	@Test
	void 앱을_지운_기기는_기기와_알림을_지운다() throws Exception {
		create("phone-a", "rtx-5070-ti", "BELOW", 140_000);
		price("rtx-5070-ti", 139_000);
		push.results.add(PushSender.Result.UNREGISTERED);

		alerts.checkAndSend();

		assertThat(jdbc.sql("select count(*) from device where token = 'phone-a'").query(Integer.class).single()).isZero();
		assertThat(jdbc.sql("select count(*) from price_alert").query(Integer.class).single()).isZero();
	}

	@Test
	void 잠깐_실패하면_다음_시각에_다시() throws Exception {
		long id = create("phone-a", "rtx-5070-ti", "BELOW", 140_000);
		price("rtx-5070-ti", 139_000);
		push.results.add(PushSender.Result.FAILED);

		alerts.checkAndSend();
		assertThat(firedCents(id)).isNull();

		alerts.checkAndSend();
		assertThat(firedCents(id)).isEqualTo(139_000);
	}

	Long firedCents(long id) {
		return jdbc.sql("select fired_cents from price_alert where id = :id").param("id", id)
				.query(Long.class).optional().orElse(null);
	}

	record Sent(String token, String title, String body, Map<String, String> data) {}

	static class FakePush implements PushSender {
		final List<Result> results = new ArrayList<>();
		final List<Sent> sent = new ArrayList<>();

		@Override
		public Result send(String token, String title, String body, Map<String, String> data) {
			Result r = results.isEmpty() ? Result.SENT : results.removeFirst();
			if (r == Result.SENT) {
				sent.add(new Sent(token, title, body, data));
			}
			return r;
		}
	}

	@TestConfiguration(proxyBeanMethods = false)
	static class FakePushConfig {
		@Bean
		@Primary
		FakePush fakePush() {
			return new FakePush();
		}
	}
}
