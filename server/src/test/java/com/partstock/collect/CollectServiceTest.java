package com.partstock.collect;

import static org.assertj.core.api.Assertions.assertThat;

import com.partstock.TestcontainersConfiguration;
import com.partstock.catalog.ChipsetDef;
import com.partstock.collect.CollectResult.Status;
import com.partstock.collect.ListingSource.Listing;
import com.partstock.price.DailyPriceStore;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Import;
import org.springframework.context.annotation.Primary;
import org.springframework.jdbc.core.simple.JdbcClient;

/** 가짜 판매 글로 수집 → 실제 PostgreSQL 저장까지. */
@SpringBootTest(properties = {"partstock.collect.cron=-", "partstock.collect.min-listings=3"})
@Import({TestcontainersConfiguration.class, CollectServiceTest.FakeSourceConfig.class})
class CollectServiceTest {

	static final LocalDate DAY = LocalDate.of(2026, 11, 20);

	@Autowired CollectService collect;
	@Autowired DailyPriceStore prices;
	@Autowired FakeSource source;
	@Autowired JdbcClient jdbc;

	@BeforeEach
	void clean() {
		source.byChipset.clear();
		source.failing.clear();
		jdbc.sql("delete from daily_price").update();
		jdbc.sql("delete from collection_run").update();
	}

	@Test
	void 칩셋_제조사_모델별_시세를_저장한다() {
		source.byChipset.put("rtx-5070-ti", List.of(
				usd("MSI RTX 5070 Ti Gaming Trio OC", 85_000),
				usd("MSI RTX 5070 Ti Gaming Trio OC White", 86_000),
				usd("MSI GeForce RTX 5070 Ti GAMING TRIO", 87_000),
				usd("MSI RTX 5070 Ti Ventus 3X", 80_000),
				usd("ASUS TUF RTX 5070 Ti", 90_000),
				usd("EMPTY BOX MSI RTX 5070 Ti", 1_500),
				usd("MSI RTX 5070 Ti 16GB", 81_000)));

		var result = collect.collect(DAY);

		assertThat(result.status()).isEqualTo(Status.OK);
		// 칩셋: 상자 글만 빠진 6개
		assertThat(prices.find("rtx-5070-ti", DAY)).hasValueSatisfying(s -> {
			assertThat(s.listingCount()).isEqualTo(6);
			assertThat(s.medianCents()).isEqualTo(85_500);
		});
		// 제조사 MSI: 5개, 모델 Gaming Trio: 3개
		assertThat(prices.find("rtx-5070-ti/msi", DAY)).hasValueSatisfying(s -> assertThat(s.listingCount()).isEqualTo(5));
		assertThat(prices.find("rtx-5070-ti/msi/gaming-trio", DAY)).hasValueSatisfying(s ->
				assertThat(s.medianCents()).isEqualTo(86_000));
		// 3개 미만인 종목은 시세를 비운다
		assertThat(prices.find("rtx-5070-ti/msi/ventus", DAY)).isEmpty();
		assertThat(prices.find("rtx-5070-ti/asus", DAY)).isEmpty();
		// 종목 표에는 판매 글이 있었던 조합이 생긴다
		assertThat(tickerNames("rtx-5070-ti")).contains("RTX 5070 Ti", "MSI", "Gaming Trio", "Ventus", "ASUS", "TUF Gaming");
	}

	@Test
	void 같은_날_다시_수집하면_덮어쓰고_글이_줄면_지운다() {
		source.byChipset.put("rtx-5080", List.of(
				usd("RTX 5080 a", 100_000), usd("RTX 5080 b", 110_000), usd("RTX 5080 c", 120_000)));
		collect.collect(DAY);
		assertThat(prices.find("rtx-5080", DAY)).isPresent();

		source.byChipset.put("rtx-5080", List.of(usd("RTX 5080 a", 100_000)));
		collect.collect(DAY);

		assertThat(prices.find("rtx-5080", DAY)).isEmpty();
	}

	@Test
	void 칩셋_하나가_실패해도_나머지는_저장하고_PARTIAL로_남긴다() {
		source.failing.add("rtx-5090");
		source.byChipset.put("rtx-5080", List.of(
				usd("RTX 5080 a", 100_000), usd("RTX 5080 b", 110_000), usd("RTX 5080 c", 120_000)));

		var result = collect.collect(DAY);

		assertThat(result.status()).isEqualTo(Status.PARTIAL);
		assertThat(result.errors()).singleElement().asString().startsWith("rtx-5090");
		assertThat(prices.find("rtx-5080", DAY)).isPresent();
		assertThat(jdbc.sql("select status from collection_run").query(String.class).single()).isEqualTo("PARTIAL");
	}

	@Test
	void 달러가_아닌_글은_세지_않는다() {
		source.byChipset.put("rtx-5080", List.of(
				usd("RTX 5080 a", 100_000), usd("RTX 5080 b", 110_000),
				new Listing("RTX 5080 c", 120_000, "CAD")));

		collect.collect(DAY);

		assertThat(prices.find("rtx-5080", DAY)).isEmpty();
	}

	List<String> tickerNames(String chipset) {
		return jdbc.sql("select display_name from ticker where chipset_key = :c")
				.param("c", chipset).query(String.class).list();
	}

	static Listing usd(String title, long cents) {
		return new Listing(title, cents, "USD");
	}

	static class FakeSource implements ListingSource {
		final Map<String, List<Listing>> byChipset = new HashMap<>();
		final List<String> failing = new ArrayList<>();

		@Override
		public List<Listing> search(ChipsetDef chipset) {
			if (failing.contains(chipset.key())) {
				throw new IllegalStateException("eBay 503");
			}
			return byChipset.getOrDefault(chipset.key(), List.of());
		}
	}

	@TestConfiguration(proxyBeanMethods = false)
	static class FakeSourceConfig {
		@Bean
		@Primary
		FakeSource fakeSource() {
			return new FakeSource();
		}
	}
}
