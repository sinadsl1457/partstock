package com.partstock.price;

import java.time.Instant;
import java.time.ZoneOffset;
import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.stereotype.Repository;

/** price_snapshot 표: 매시간 시세. 같은 시각에 다시 수집하면 덮어쓴다. */
@Repository
public class SnapshotStore {

	private final JdbcClient jdbc;

	public SnapshotStore(JdbcClient jdbc) {
		this.jdbc = jdbc;
	}

	public void upsert(String tickerKey, Instant ts, PriceStats s) {
		jdbc.sql("""
				insert into price_snapshot (ticker_key, ts, price_cents, median_cents, p25_cents, p75_cents, min_cents, max_cents,
				                            listing_count, raw_count)
				values (:ticker, :ts, :price, :median, :p25, :p75, :min, :max, :count, :raw)
				on conflict (ticker_key, ts) do update set
				    price_cents = excluded.price_cents, median_cents = excluded.median_cents, p25_cents = excluded.p25_cents,
				    p75_cents = excluded.p75_cents, min_cents = excluded.min_cents, max_cents = excluded.max_cents,
				    listing_count = excluded.listing_count, raw_count = excluded.raw_count
				""")
				.param("ticker", tickerKey)
				.param("ts", ts.atOffset(ZoneOffset.UTC))
				.param("price", s.priceCents())
				.param("median", s.medianCents())
				.param("p25", s.p25Cents())
				.param("p75", s.p75Cents())
				.param("min", s.minCents())
				.param("max", s.maxCents())
				.param("count", s.listingCount())
				.param("raw", s.rawCount())
				.update();
	}

	public void delete(String tickerKey, Instant ts) {
		jdbc.sql("delete from price_snapshot where ticker_key = :ticker and ts = :ts")
				.param("ticker", tickerKey)
				.param("ts", ts.atOffset(ZoneOffset.UTC))
				.update();
	}
}
