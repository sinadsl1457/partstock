package com.partstock.collect;

import com.partstock.catalog.Catalog;
import com.partstock.catalog.Category;
import com.partstock.catalog.ChipsetDef;
import com.partstock.catalog.ListingClassifier;
import com.partstock.collect.ListingSource.Listing;
import com.partstock.price.PriceStats;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

/**
 * 데이터 품질 점검(저장 안 함). 종목별 판매 글 수·중앙값·흩어짐과 버려진 제목을 콘솔에 찍는다.
 * ./gradlew bootRun --args='--spring.profiles.active=local,probe --partstock.probe.chipsets=rtx-5070-ti'
 */
@Component
@Profile("probe")
public class ProbeRunner implements ApplicationRunner {

	private final ListingSource source;
	private final String chipsetKeys;

	public ProbeRunner(ListingSource source, @Value("${partstock.probe.chipsets:}") String chipsetKeys) {
		this.source = source;
		this.chipsetKeys = chipsetKeys;
	}

	@Override
	public void run(ApplicationArguments args) {
		List<String> wanted = chipsetKeys.isBlank() ? List.of() : Arrays.asList(chipsetKeys.split(","));
		for (Category category : Category.values()) {
			for (ChipsetDef chipset : Catalog.chipsets(category)) {
				if (wanted.isEmpty() || wanted.contains(chipset.key())) {
					probe(chipset);
				}
			}
		}
	}

	private void probe(ChipsetDef chipset) {
		List<Listing> listings = source.search(chipset);
		Map<String, List<Long>> byTicker = new TreeMap<>();
		List<String> dropped = new ArrayList<>();
		for (Listing l : listings) {
			var c = ListingClassifier.classify(chipset, l.title());
			if (c.isEmpty() || !"USD".equals(l.currency())) {
				dropped.add("$%.2f  %s".formatted(l.priceCents() / 100.0, l.title()));
				continue;
			}
			for (String key : c.get().tickerKeys()) {
				byTicker.computeIfAbsent(key, k -> new ArrayList<>()).add(l.priceCents());
			}
		}

		System.out.printf("%n== %s (검색어 \"%s\") 받은 글 %d, 버림 %d%n",
				chipset.displayName(), chipset.ebayQuery(), listings.size(), dropped.size());
		System.out.printf("%-45s %5s %5s %10s %10s %10s %7s%n", "종목", "글", "남음", "중앙값", "p25", "p75", "폭%");
		byTicker.forEach((key, prices) -> PriceStats.of(prices, 1).ifPresent(s -> System.out.printf(
				"%-45s %5d %5d %10.2f %10.2f %10.2f %6.1f%%%n",
				key, s.rawCount(), s.listingCount(), s.medianCents() / 100.0, s.p25Cents() / 100.0,
				s.p75Cents() / 100.0, 100.0 * (s.p75Cents() - s.p25Cents()) / s.medianCents())));
		System.out.println("-- 버린 제목(최대 20개):");
		dropped.stream().limit(20).forEach(t -> System.out.println("   " + t));
	}
}
