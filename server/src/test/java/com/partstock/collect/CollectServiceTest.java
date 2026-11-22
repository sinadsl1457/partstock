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
		jdbc.sql("delete from price_snapshot").update();
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
	void 같은_제목_같은_가격_글은_한_번만_센다() {
		// 한 판매자가 시세보다 비싸게 같은 글을 여러 개 올려 두면 중앙값이 끌려 올라간다(실제 eBay 램 검색에서 확인)
		source.byChipset.put("rtx-5080", List.of(
				usd("RTX 5080 a", 100_000), usd("RTX 5080 b", 101_000), usd("RTX 5080 c", 102_000),
				usd("RTX 5080 gouge", 300_000), usd("RTX 5080 gouge", 300_000), usd("RTX 5080 gouge", 300_000),
				usd("RTX 5080 gouge", 300_000)));

		collect.collect(DAY);

		assertThat(prices.find("rtx-5080", DAY)).hasValueSatisfying(s -> {
			assertThat(s.rawCount()).isEqualTo(4); // 중복 4개가 1개로
			assertThat(s.medianCents()).isEqualTo(101_000); // 남은 비싼 글 1개는 이상값으로 빠짐
		});
	}

	@Autowired CollectionRunStore runs;

	@Test
	void 끝까지_돈_수집만_친다() {
		java.time.Instant since = java.time.Instant.EPOCH;
		assertThat(runs.hasCompletedRunSince(since)).isFalse();

		for (var category : com.partstock.catalog.Category.values()) {
			source.failing.addAll(com.partstock.catalog.Catalog.chipsets(category).stream().map(c -> c.key()).toList());
		}
		collect.collect(DAY); // 전부 실패 → FAILED
		assertThat(runs.hasCompletedRunSince(since)).isFalse();

		source.failing.clear();
		collect.collect(DAY);
		assertThat(runs.hasCompletedRunSince(since)).isTrue();
		// 수집 기록의 시작 시각은 테스트 시계가 아니라 실제 지금이라, 먼 미래 기준이면 없음
		assertThat(runs.hasCompletedRunSince(java.time.Instant.parse("2999-01-01T00:00:00Z"))).isFalse();
	}

	@Test
	void 매시간_스냅샷을_쌓고_그날_시세는_가장_최근_값() {
		source.byChipset.put("rtx-5080", List.of(
				usd("RTX 5080 a", 100_000), usd("RTX 5080 b", 110_000), usd("RTX 5080 c", 120_000)));
		collect.collect(java.time.Instant.parse("2026-11-20T03:12:00Z"));
		source.byChipset.put("rtx-5080", List.of(
				usd("RTX 5080 a", 200_000), usd("RTX 5080 b", 210_000), usd("RTX 5080 c", 220_000)));
		collect.collect(java.time.Instant.parse("2026-11-20T04:05:00Z"));

		// 글자로 비교하면 DB 접속의 시간대(테스트 기계는 한국)에 따라 달라져서 시각 자체로 비교
		var hours = jdbc.sql("select ts from price_snapshot where ticker_key = 'rtx-5080' order by ts")
				.query(java.time.OffsetDateTime.class).list().stream().map(java.time.OffsetDateTime::toInstant).toList();
		assertThat(hours).containsExactly(
				java.time.Instant.parse("2026-11-20T03:00:00Z"), java.time.Instant.parse("2026-11-20T04:00:00Z"));
		assertThat(prices.find("rtx-5080", DAY)).hasValueSatisfying(s -> assertThat(s.medianCents()).isEqualTo(210_000));
	}

	@Test
	void 한_판매자가_제목만_바꿔_같은_가격에_많이_올린_글은_한_번만_센다() {
		// 11/22 실제: DDR4 32GB에서 한 판매자가 $344.95 글 197개 → p25·중앙값·p75가 모두 그 값이 됨
		var listings = new ArrayList<Listing>();
		for (int i = 0; i < 12; i++) {
			listings.add(new Listing("RTX 5080 variant " + i, 300_000, "USD", "massseller"));
		}
		listings.add(new Listing("RTX 5080 a", 100_000, "USD", "s1"));
		listings.add(new Listing("RTX 5080 b", 101_000, "USD", "s2"));
		listings.add(new Listing("RTX 5080 c", 102_000, "USD", "s3"));
		listings.add(new Listing("RTX 5080 d", 104_000, "USD", "s3")); // 같은 판매자라도 다른 가격은 따로
		source.byChipset.put("rtx-5080", listings);

		collect.collect(DAY);

		assertThat(prices.find("rtx-5080", DAY)).hasValueSatisfying(s -> {
			assertThat(s.rawCount()).isEqualTo(5); // 12개 → 1개 + 나머지 4개
			assertThat(s.p25Cents()).isLessThan(110_000);
		});
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
