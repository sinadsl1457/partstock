package com.partstock.collect;

import static org.assertj.core.api.Assertions.assertThat;

import com.partstock.collect.ListingSource.Listing;
import java.util.List;
import org.junit.jupiter.api.Test;

/** 같은 판매자 + 같은 가격은 한 번만. 판매자를 모르면 같은 제목 + 같은 가격만 합친다. */
class ListingDedupeTest {

	@Test
	void 같은_판매자_같은_가격은_제목이_달라도_한_번() {
		var out = ListingSource.dedupe(List.of(
				new Listing("DDR4 32GB a", 34_495, "USD", "k1"),
				new Listing("DDR4 32GB b", 34_495, "USD", "k1"),
				new Listing("DDR4 32GB c", 39_595, "USD", "k1"), // 같은 판매자 다른 가격
				new Listing("DDR4 32GB a", 34_495, "USD", "k2"))); // 다른 판매자 같은 가격
		assertThat(out).extracting(Listing::title).containsExactly("DDR4 32GB a", "DDR4 32GB c", "DDR4 32GB a");
	}

	@Test
	void 판매자를_모르면_같은_제목_같은_가격만() {
		var out = ListingSource.dedupe(List.of(
				new Listing("RTX 5080 a", 100_000, "USD"),
				new Listing("RTX 5080 a", 100_000, "USD"),
				new Listing("RTX 5080 b", 100_000, "USD")));
		assertThat(out).hasSize(2);
	}
}
