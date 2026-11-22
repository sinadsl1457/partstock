package com.partstock.api;

import static org.hamcrest.Matchers.contains;
import static org.hamcrest.Matchers.hasSize;
import static org.hamcrest.Matchers.nullValue;
import static org.hamcrest.Matchers.startsWith;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.partstock.TestcontainersConfiguration;
import com.partstock.price.DailyPriceStore;
import com.partstock.price.PriceStats;
import com.partstock.price.SnapshotStore;
import com.partstock.ticker.TickerStore;
import java.time.Duration;
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneOffset;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.context.annotation.Import;
import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.test.web.servlet.MockMvc;

/** 실제 PostgreSQL에 시세를 넣고 API 응답 모양을 확인한다. */
@SpringBootTest(properties = "partstock.collect.cron=-")
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class PriceApiTest {

	/** 2026-11-18(수) 12:00 UTC = 가장 최근 수집 */
	static final Instant NOW = Instant.parse("2026-11-18T12:00:00Z");

	@Autowired MockMvc mvc;
	@Autowired JdbcClient jdbc;
	@Autowired TickerStore tickers;
	@Autowired DailyPriceStore prices;
	@Autowired SnapshotStore snapshots;

	@BeforeEach
	void setUp() {
		jdbc.sql("delete from daily_price").update();
		jdbc.sql("delete from price_snapshot").update();
		jdbc.sql("delete from fx_rate").update();
		jdbc.sql("delete from ticker").update();
		tickers.syncChipsets();
		jdbc.sql("""
				insert into ticker (key, level, category, chipset_key, maker_key, series_key, display_name, danawa_pcode) values
				('rtx-5070-ti/msi', 'MAKER', 'GPU', 'rtx-5070-ti', 'msi', null, 'MSI', null),
				('rtx-5070-ti/msi/gaming-trio', 'MODEL', 'GPU', 'rtx-5070-ti', 'msi', 'gaming-trio', 'Gaming Trio', '12345'),
				('rtx-5070-ti/msi/ventus', 'MODEL', 'GPU', 'rtx-5070-ti', 'msi', 'ventus', 'Ventus', null),
				('rtx-5070-ti/asus', 'MAKER', 'GPU', 'rtx-5070-ti', 'asus', null, 'ASUS', null)
				""").update();
		jdbc.sql("insert into fx_rate (day, usd_krw) values ('2026-11-17', 1328.45)").update();
	}

	/** 수집 한 번과 같게: 그 시각 스냅샷 + 그날 시세(가장 최근 값) */
	void put(String key, Instant ts, long p25) {
		PriceStats s = new PriceStats(p25 + 1000, p25, p25 + 2000, p25 - 500, p25 + 5000, 10, 12);
		snapshots.upsert(key, ts, s);
		prices.upsert(key, LocalDate.ofInstant(ts, ZoneOffset.UTC), s);
	}

	Instant ago(int hours) {
		return NOW.minus(Duration.ofHours(hours));
	}

	@Test
	void 시세판은_목록_순서대로_대표가_24시간_변동_7일_추이_링크를_준다() throws Exception {
		put("rtx-5070-ti", ago(25), 140_000);
		put("rtx-5070-ti", ago(1), 145_000);
		put("rtx-5070-ti", NOW, 147_000);
		put("rtx-5090", NOW, 700_000);

		mvc.perform(get("/api/board").param("category", "GPU"))
				.andExpect(status().isOk())
				.andExpect(jsonPath("$.day").value("2026-11-18"))
				.andExpect(jsonPath("$.updatedAt").value("2026-11-18T12:00:00Z"))
				.andExpect(jsonPath("$.fx.day").value("2026-11-17"))
				.andExpect(jsonPath("$.items[0].key").value("rtx-5090"))
				.andExpect(jsonPath("$.items[2].key").value("rtx-5070-ti"))
				.andExpect(jsonPath("$.items[2].vendor").value("NVIDIA"))
				.andExpect(jsonPath("$.items[2].price.p25Cents").value(147_000))
				.andExpect(jsonPath("$.items[2].price.medianCents").value(148_000))
				// 24시간 전(11/17 12:00) 이전 가장 가까운 시세 = 25시간 전 140,000 → +5%
				.andExpect(jsonPath("$.items[2].change.prevAt").value("2026-11-17T11:00:00Z"))
				.andExpect(jsonPath("$.items[2].change.pct").value(5.0))
				.andExpect(jsonPath("$.items[2].spark", hasSize(3)))
				.andExpect(jsonPath("$.items[2].links.ebay", startsWith("https://www.ebay.com/sch/i.html?_nkw=RTX%205070%20Ti&_sacat=27386")))
				.andExpect(jsonPath("$.items[2].links.danawa").value("https://search.danawa.com/dsearch.php?query=RTX%205070%20Ti"))
				// 시세가 없는 칩셋도 목록에는 나온다
				.andExpect(jsonPath("$.items[1].key").value("rtx-5080"))
				.andExpect(jsonPath("$.items[1].price").value(nullValue()))
				// 24시간 전 시세가 없으면 변동은 비운다(수집 첫날)
				.andExpect(jsonPath("$.items[0].change").value(nullValue()));
	}

	@Test
	void 환율은_그날_또는_그_전_가장_가까운_고시값() throws Exception {
		put("rtx-5090", Instant.parse("2026-11-22T03:00:00Z"), 700_000); // 일요일: 고시 없음

		mvc.perform(get("/api/board"))
				.andExpect(jsonPath("$.fx.day").value("2026-11-17"))
				.andExpect(jsonPath("$.fx.usdKrw").value(1328.45));
	}

	@Test
	void 하루_차트는_매시간_봉_하나씩_기간_등락률까지() throws Exception {
		put("rtx-5070-ti", ago(30), 100_000); // 24시간 밖: 빠짐
		put("rtx-5070-ti", ago(2), 140_000);
		put("rtx-5070-ti", ago(1), 150_000);
		put("rtx-5070-ti", NOW, 147_000);

		mvc.perform(get("/api/chart").param("key", "rtx-5070-ti").param("range", "1d"))
				.andExpect(status().isOk())
				.andExpect(jsonPath("$.bucket").value("1 hour"))
				.andExpect(jsonPath("$.bars", hasSize(3)))
				.andExpect(jsonPath("$.bars[0].t").value("2026-11-18T10:00:00Z"))
				.andExpect(jsonPath("$.bars[2].closeCents").value(147_000))
				.andExpect(jsonPath("$.bars[2].medianCents").value(148_000))
				.andExpect(jsonPath("$.rangePct").value(5.0));
	}

	@Test
	void 일주일_차트는_4시간_봉의_처음_최고_최저_마지막() throws Exception {
		// 08:00~11:00은 한 봉(08~12시), 12:00은 다음 봉
		put("rtx-5070-ti", ago(4), 140_000);
		put("rtx-5070-ti", ago(3), 150_000);
		put("rtx-5070-ti", ago(2), 135_000);
		put("rtx-5070-ti", ago(1), 138_000);
		put("rtx-5070-ti", NOW, 145_000);

		mvc.perform(get("/api/chart").param("key", "rtx-5070-ti").param("range", "1w"))
				.andExpect(jsonPath("$.bars", hasSize(2)))
				.andExpect(jsonPath("$.bars[0].t").value("2026-11-18T08:00:00Z"))
				.andExpect(jsonPath("$.bars[0].openCents").value(140_000))
				.andExpect(jsonPath("$.bars[0].highCents").value(150_000))
				.andExpect(jsonPath("$.bars[0].lowCents").value(135_000))
				.andExpect(jsonPath("$.bars[0].closeCents").value(138_000))
				.andExpect(jsonPath("$.bars[0].samples").value(4))
				.andExpect(jsonPath("$.bars[1].t").value("2026-11-18T12:00:00Z"));
	}

	@Test
	void 한달_차트는_하루_봉() throws Exception {
		put("rtx-5070-ti", Instant.parse("2026-11-16T05:00:00Z"), 140_000);
		put("rtx-5070-ti", Instant.parse("2026-11-16T20:00:00Z"), 141_000);
		put("rtx-5070-ti", Instant.parse("2026-11-17T05:00:00Z"), 142_000);
		put("rtx-5070-ti", NOW, 143_000);

		mvc.perform(get("/api/chart").param("key", "rtx-5070-ti").param("range", "1m"))
				.andExpect(jsonPath("$.bucket").value("1 day"))
				.andExpect(jsonPath("$.bars[*].t", contains(
						"2026-11-16T00:00:00Z", "2026-11-17T00:00:00Z", "2026-11-18T00:00:00Z")))
				.andExpect(jsonPath("$.bars[0].closeCents").value(141_000));
	}

	@Test
	void 칩셋_상세는_제조사와_모델을_시세_있는_것부터() throws Exception {
		put("rtx-5070-ti", NOW, 140_000);
		put("rtx-5070-ti/msi", NOW, 145_000);
		put("rtx-5070-ti/msi/gaming-trio", NOW, 150_000);
		// ventus·asus는 시세 없음(글 부족)

		mvc.perform(get("/api/ticker").param("key", "rtx-5070-ti"))
				.andExpect(jsonPath("$.ticker.name").value("RTX 5070 Ti"))
				.andExpect(jsonPath("$.updatedAt").value("2026-11-18T12:00:00Z"))
				.andExpect(jsonPath("$.makers[*].name", contains("MSI", "ASUS")))
				.andExpect(jsonPath("$.makers[1].price").value(nullValue()))
				.andExpect(jsonPath("$.models[*].name", contains("MSI Gaming Trio", "MSI Ventus")))
				// 사람이 넣은 다나와 상품 번호가 있으면 상품 페이지로
				.andExpect(jsonPath("$.models[0].links.danawa").value("https://prod.danawa.com/info/?pcode=12345"))
				.andExpect(jsonPath("$.models[1].links.danawa").value(
						"https://search.danawa.com/dsearch.php?query=MSI%20RTX%205070%20Ti%20Ventus"));
	}

	@Test
	void 모델_상세는_전체_이름과_자기_링크() throws Exception {
		put("rtx-5070-ti/msi/gaming-trio", NOW, 150_000);

		mvc.perform(get("/api/ticker").param("key", "rtx-5070-ti/msi/gaming-trio"))
				.andExpect(jsonPath("$.ticker.name").value("RTX 5070 Ti · MSI Gaming Trio"))
				.andExpect(jsonPath("$.ticker.level").value("MODEL"))
				.andExpect(jsonPath("$.price.p25Cents").value(150_000))
				.andExpect(jsonPath("$.makers", hasSize(0)))
				.andExpect(jsonPath("$.links.danawa").value("https://prod.danawa.com/info/?pcode=12345"))
				.andExpect(jsonPath("$.links.ebay", startsWith(
						"https://www.ebay.com/sch/i.html?_nkw=MSI%20RTX%205070%20Ti%20Gaming%20Trio")));
	}

	@Test
	void 램_다나와_검색어는_다나와_표기에_가깝게() throws Exception {
		put("ddr5-32gb", NOW, 58_000);

		mvc.perform(get("/api/board").param("category", "ram"))
				.andExpect(jsonPath("$.items[0].key").value("ddr5-32gb"))
				.andExpect(jsonPath("$.items[0].vendor").value("DESKTOP"))
				.andExpect(jsonPath("$.items[0].links.danawa").value(
						"https://search.danawa.com/dsearch.php?query=DDR5%2032GB%2016Gx2"));
	}

	@Test
	void 수집_전이면_날짜와_시세가_비어_있다() throws Exception {
		mvc.perform(get("/api/board"))
				.andExpect(status().isOk())
				.andExpect(jsonPath("$.day").value(nullValue()))
				.andExpect(jsonPath("$.items[0].price").value(nullValue()));
		mvc.perform(get("/api/ticker").param("key", "rtx-5070-ti")).andExpect(status().isOk());
		mvc.perform(get("/api/chart").param("key", "rtx-5070-ti"))
				.andExpect(status().isOk())
				.andExpect(jsonPath("$.bars", hasSize(0)))
				.andExpect(jsonPath("$.rangePct").value(nullValue()));
	}

	@Test
	void 잘못된_요청() throws Exception {
		mvc.perform(get("/api/ticker").param("key", "nope")).andExpect(status().isNotFound());
		mvc.perform(get("/api/chart").param("key", "nope")).andExpect(status().isNotFound());
		mvc.perform(get("/api/chart").param("key", "rtx-5090").param("range", "5y")).andExpect(status().isBadRequest());
		mvc.perform(get("/api/board").param("category", "CPU")).andExpect(status().isBadRequest());
	}
}
