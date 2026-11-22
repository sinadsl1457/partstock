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
import com.partstock.ticker.TickerStore;
import java.time.LocalDate;
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

	// 2026-11-16이 월요일: 16~18일은 같은 주, 23일은 다음 주
	static final LocalDate MON = LocalDate.of(2026, 11, 16);

	@Autowired MockMvc mvc;
	@Autowired JdbcClient jdbc;
	@Autowired TickerStore tickers;
	@Autowired DailyPriceStore prices;

	@BeforeEach
	void setUp() {
		jdbc.sql("delete from daily_price").update();
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
		jdbc.sql("insert into fx_rate (day, usd_krw) values ('2026-11-20', 1328.45)").update();
	}

	void put(String key, LocalDate day, long p25) {
		prices.upsert(key, day, new PriceStats(p25 + 1000, p25, p25 + 2000, p25 - 500, p25 + 5000, 10, 12));
	}

	@Test
	void 시세판은_목록_순서대로_대표가_전일대비_추이_링크를_준다() throws Exception {
		put("rtx-5070-ti", MON, 140_000);
		put("rtx-5070-ti", MON.plusDays(2), 147_000); // 하루 빠진 날이 있어도 직전 시세와 비교
		put("rtx-5090", MON.plusDays(2), 700_000);

		mvc.perform(get("/api/board").param("category", "GPU"))
				.andExpect(status().isOk())
				.andExpect(jsonPath("$.day").value("2026-11-18"))
				// 18일 환율이 없으면 그 전 가장 가까운 날(이 데이터에서는 20일이 미래라 없음 → null)
				.andExpect(jsonPath("$.fx").value(nullValue()))
				.andExpect(jsonPath("$.items[0].key").value("rtx-5090"))
				.andExpect(jsonPath("$.items[2].key").value("rtx-5070-ti"))
				.andExpect(jsonPath("$.items[2].vendor").value("NVIDIA"))
				.andExpect(jsonPath("$.items[2].price.p25Cents").value(147_000))
				.andExpect(jsonPath("$.items[2].price.medianCents").value(148_000))
				.andExpect(jsonPath("$.items[2].change.prevDay").value("2026-11-16"))
				.andExpect(jsonPath("$.items[2].change.pct").value(5.0))
				.andExpect(jsonPath("$.items[2].spark", hasSize(2)))
				.andExpect(jsonPath("$.items[2].links.ebay", startsWith("https://www.ebay.com/sch/i.html?_nkw=RTX%205070%20Ti&_sacat=27386")))
				.andExpect(jsonPath("$.items[2].links.danawa").value("https://search.danawa.com/dsearch.php?query=RTX%205070%20Ti"))
				// 시세가 없는 칩셋도 목록에는 나온다
				.andExpect(jsonPath("$.items[1].key").value("rtx-5080"))
				.andExpect(jsonPath("$.items[1].price").value(nullValue()))
				.andExpect(jsonPath("$.items[1].change").value(nullValue()));
	}

	@Test
	void 환율은_그날_또는_그_전_가장_가까운_고시값() throws Exception {
		put("rtx-5090", LocalDate.of(2026, 11, 22), 700_000); // 일요일: 고시 없음

		mvc.perform(get("/api/board"))
				.andExpect(jsonPath("$.fx.day").value("2026-11-20"))
				.andExpect(jsonPath("$.fx.usdKrw").value(1328.45));
	}

	@Test
	void 주봉은_그_주_대표가의_처음_최고_최저_마지막() throws Exception {
		put("rtx-5070-ti", MON, 140_000);
		put("rtx-5070-ti", MON.plusDays(1), 150_000);
		put("rtx-5070-ti", MON.plusDays(2), 135_000);
		put("rtx-5070-ti", MON.plusDays(7), 145_000);

		mvc.perform(get("/api/ticker").param("key", "rtx-5070-ti").param("period", "week"))
				.andExpect(status().isOk())
				.andExpect(jsonPath("$.candles", hasSize(2)))
				.andExpect(jsonPath("$.candles[0].start").value("2026-11-16"))
				.andExpect(jsonPath("$.candles[0].openCents").value(140_000))
				.andExpect(jsonPath("$.candles[0].highCents").value(150_000))
				.andExpect(jsonPath("$.candles[0].lowCents").value(135_000))
				.andExpect(jsonPath("$.candles[0].closeCents").value(135_000))
				.andExpect(jsonPath("$.candles[0].days").value(3))
				.andExpect(jsonPath("$.candles[1].start").value("2026-11-23"))
				.andExpect(jsonPath("$.points", hasSize(0)));
	}

	@Test
	void 일봉_대신_최근_30일_점을_준다() throws Exception {
		put("rtx-5070-ti", MON, 140_000);
		put("rtx-5070-ti", MON.plusDays(1), 150_000);

		mvc.perform(get("/api/ticker").param("key", "rtx-5070-ti").param("period", "day"))
				.andExpect(jsonPath("$.points", hasSize(2)))
				.andExpect(jsonPath("$.points[1].p25Cents").value(150_000))
				.andExpect(jsonPath("$.points[1].p75Cents").value(152_000))
				.andExpect(jsonPath("$.candles", hasSize(0)));
	}

	@Test
	void 칩셋_상세는_제조사와_모델을_시세_있는_것부터() throws Exception {
		LocalDate day = MON;
		put("rtx-5070-ti", day, 140_000);
		put("rtx-5070-ti/msi", day, 145_000);
		put("rtx-5070-ti/msi/gaming-trio", day, 150_000);
		// ventus·asus는 그날 시세 없음(글 부족)

		mvc.perform(get("/api/ticker").param("key", "rtx-5070-ti"))
				.andExpect(jsonPath("$.ticker.name").value("RTX 5070 Ti"))
				.andExpect(jsonPath("$.period").value("week"))
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
		put("rtx-5070-ti/msi/gaming-trio", MON, 150_000);

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
		put("ddr5-32gb", MON, 58_000);

		mvc.perform(get("/api/board").param("category", "ram"))
				.andExpect(jsonPath("$.items[0].key").value("ddr5-32gb"))
				.andExpect(jsonPath("$.items[0].vendor").value("데스크톱"))
				.andExpect(jsonPath("$.items[0].links.danawa").value(
						"https://search.danawa.com/dsearch.php?query=DDR5%2032GB%2016Gx2"));
	}

	@Test
	void 수집_전이면_날짜와_시세가_비어_있다() throws Exception {
		mvc.perform(get("/api/board"))
				.andExpect(status().isOk())
				.andExpect(jsonPath("$.day").value(nullValue()))
				.andExpect(jsonPath("$.items[0].price").value(nullValue()));
		mvc.perform(get("/api/ticker").param("key", "rtx-5070-ti"))
				.andExpect(status().isOk())
				.andExpect(jsonPath("$.candles", hasSize(0)));
	}

	@Test
	void 잘못된_요청() throws Exception {
		mvc.perform(get("/api/ticker").param("key", "nope")).andExpect(status().isNotFound());
		put("rtx-5090", MON, 700_000);
		mvc.perform(get("/api/ticker").param("key", "rtx-5090").param("period", "hour"))
				.andExpect(status().isBadRequest());
		mvc.perform(get("/api/board").param("category", "CPU")).andExpect(status().isBadRequest());
	}
}
