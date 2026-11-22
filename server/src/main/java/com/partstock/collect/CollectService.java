package com.partstock.collect;

import com.partstock.catalog.Catalog;
import com.partstock.catalog.Category;
import com.partstock.catalog.ChipsetDef;
import com.partstock.catalog.ListingClassifier;
import com.partstock.catalog.ListingClassifier.Classification;
import com.partstock.collect.CollectResult.Status;
import com.partstock.collect.ListingSource.Listing;
import com.partstock.price.DailyPriceStore;
import com.partstock.price.PriceStats;
import com.partstock.price.SnapshotStore;
import com.partstock.ticker.TickerStore;
import java.time.Clock;
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneOffset;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

/**
 * 시세 수집(매시간): 칩셋마다 판매 글을 받아 → 제목으로 종목을 가르고 → 종목별 시세를 계산해 저장.
 * 판매 글 원본은 이 메서드 안에서만 쓰고 버린다.
 */
@Service
public class CollectService {

	private static final Logger log = LoggerFactory.getLogger(CollectService.class);

	private final ListingSource source;
	private final TickerStore tickers;
	private final DailyPriceStore prices;
	private final SnapshotStore snapshots;
	private final CollectionRunStore runs;
	private final Clock clock;
	private final int minListings;

	public CollectService(ListingSource source, TickerStore tickers, DailyPriceStore prices, SnapshotStore snapshots,
			CollectionRunStore runs,
			Clock clock, @Value("${partstock.collect.min-listings}") int minListings) {
		this.source = source;
		this.tickers = tickers;
		this.prices = prices;
		this.snapshots = snapshots;
		this.runs = runs;
		this.clock = clock;
		this.minListings = minListings;
	}

	public CollectResult collectNow() {
		return collect(clock.instant());
	}

	/** 그날 0시(UTC) 수집으로 친다. 테스트용. */
	public CollectResult collect(LocalDate day) {
		return collect(day.atStartOfDay(ZoneOffset.UTC).toInstant());
	}

	/**
	 * at이 속한 시각(정시)의 스냅샷과 그날 시세(daily_price = 그날 가장 최근 값)를 저장한다.
	 * 같은 시각에 다시 돌면 덮어쓴다.
	 */
	public CollectResult collect(Instant at) {
		LocalDate day = LocalDate.ofInstant(at, ZoneOffset.UTC);
		Instant hour = at.truncatedTo(ChronoUnit.HOURS);
		tickers.syncChipsets();
		long runId = runs.start(day, clock.instant());
		int calls = 0, seen = 0, used = 0, saved = 0;
		long requestsBefore = source.requestCount();
		List<String> errors = new ArrayList<>();
		int chipsetCount = 0;
		// 같은 제조사·모델 종목을 글마다 다시 넣지 않게
		Set<String> ensured = new HashSet<>();

		for (Category category : Category.values()) {
			for (ChipsetDef chipset : Catalog.chipsets(category)) {
				chipsetCount++;
				List<Listing> listings;
				try {
					listings = source.search(chipset);
					calls++;
				} catch (RuntimeException e) {
					// 칩셋 하나가 실패해도 나머지는 계속한다. 이 칩셋의 그날 값은 건드리지 않는다
					log.warn("수집 실패 {}: {}", chipset.key(), e.toString());
					errors.add(chipset.key() + ": " + e);
					continue;
				}
				// 같은 판매자가 같은 가격 글을 여러 개 올린 경우 한 번만 센다
				listings = ListingSource.dedupe(listings);
				seen += listings.size();

				Map<String, List<Long>> byTicker = new LinkedHashMap<>();
				byTicker.put(chipset.key(), new ArrayList<>());
				for (Listing listing : listings) {
					if (!"USD".equals(listing.currency())) {
						continue;
					}
					Optional<Classification> c = ListingClassifier.classify(chipset, listing.title());
					if (c.isEmpty()) {
						continue;
					}
					used++;
					if (ensured.add(c.get().tickerKeys().getLast())) {
						tickers.ensure(c.get());
					}
					for (String key : c.get().tickerKeys()) {
						byTicker.computeIfAbsent(key, k -> new ArrayList<>()).add(listing.priceCents());
					}
				}

				for (var entry : byTicker.entrySet()) {
					Optional<PriceStats> stats = PriceStats.of(entry.getValue(), minListings);
					if (stats.isPresent()) {
						prices.upsert(entry.getKey(), day, stats.get());
						snapshots.upsert(entry.getKey(), hour, stats.get());
						saved++;
					} else {
						prices.delete(entry.getKey(), day);
						snapshots.delete(entry.getKey(), hour);
					}
				}
			}
		}

		Status status = errors.isEmpty() ? Status.OK : errors.size() == chipsetCount ? Status.FAILED : Status.PARTIAL;
		CollectResult result = new CollectResult(status, calls, seen, used, saved, errors);
		runs.finish(runId, clock.instant(), result);
		// 칩셋 = 검색한 칩셋 수, eBay 요청 = 실제로 보낸 쪽 요청 수(하루 한도 5,000을 세는 단위)
		log.info("수집 {} {}: 칩셋 {} / eBay 요청 {} / 글 {} / 사용 {} / 시세 {}", day, status, calls,
				source.requestCount() - requestsBefore, seen, used, saved);
		return result;
	}
}
