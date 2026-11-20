package com.partstock.price;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.List;
import org.junit.jupiter.api.Test;

class PriceStatsTest {

	@Test
	void 홀수개면_가운데_값이_중앙값() {
		var stats = PriceStats.of(List.of(300L, 100L, 200L), 3).orElseThrow();

		assertThat(stats.medianCents()).isEqualTo(200);
		assertThat(stats.minCents()).isEqualTo(100);
		assertThat(stats.maxCents()).isEqualTo(300);
		assertThat(stats.listingCount()).isEqualTo(3);
	}

	@Test
	void 짝수개면_가운데_두_값의_평균() {
		var stats = PriceStats.of(List.of(100L, 200L, 300L, 400L), 3).orElseThrow();

		assertThat(stats.medianCents()).isEqualTo(250);
	}

	@Test
	void 분위수는_칸_사이를_직선으로_잇는다() {
		// percentile_cont(0.25) of {100,200,300,400,500} = 200, 0.75 = 400
		var stats = PriceStats.of(List.of(100L, 200L, 300L, 400L, 500L), 3).orElseThrow();

		assertThat(stats.p25Cents()).isEqualTo(200);
		assertThat(stats.p75Cents()).isEqualTo(400);
	}

	@Test
	void 상자만_파는_글과_PC_통째_글은_이상값으로_빠진다() {
		// RTX 5070 Ti 새 상품이 $750~$900에 몰려 있고, 상자 $15, 완본체 $2,400이 섞임
		var prices = List.of(1_500L, 75_000L, 78_000L, 79_900L, 80_000L, 82_000L, 85_000L, 89_900L, 240_000L);

		var stats = PriceStats.of(prices, 3).orElseThrow();

		assertThat(stats.minCents()).isEqualTo(75_000);
		assertThat(stats.maxCents()).isEqualTo(89_900);
		assertThat(stats.listingCount()).isEqualTo(7);
		assertThat(stats.rawCount()).isEqualTo(9);
		assertThat(stats.medianCents()).isEqualTo(80_000);
	}

	@Test
	void 판매_글이_기준보다_적으면_시세를_비운다() {
		assertThat(PriceStats.of(List.of(100L, 200L), 3)).isEmpty();
		assertThat(PriceStats.of(List.of(), 1)).isEmpty();
	}

	@Test
	void 이상값을_빼고_나서_기준보다_적어지면_시세를_비운다() {
		// 3개 중 하나가 튀어서 빠지면 2개만 남음
		var prices = List.of(80_000L, 80_100L, 80_200L, 80_300L, 900_000L);

		assertThat(PriceStats.of(prices, 5)).isEmpty();
		assertThat(PriceStats.of(prices, 4)).isPresent();
	}

	@Test
	void 값이_모두_같으면_그대로_시세() {
		var stats = PriceStats.of(List.of(50_000L, 50_000L, 50_000L), 3).orElseThrow();

		assertThat(stats.medianCents()).isEqualTo(50_000);
		assertThat(stats.listingCount()).isEqualTo(3);
	}
}
