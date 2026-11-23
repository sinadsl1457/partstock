package com.partstock.price;

import java.time.LocalDate;
import java.util.Optional;
import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.stereotype.Repository;

/** daily_price 표. 같은 날 다시 수집하면 덮어쓴다. */
@Repository
public class DailyPriceStore {

	private final JdbcClient jdbc;

	public DailyPriceStore(JdbcClient jdbc) {
		this.jdbc = jdbc;
	}

	public void upsert(String tickerKey, LocalDate day, PriceStats s) {
		jdbc.sql("""
				insert into daily_price (ticker_key, day, price_cents, median_cents, p25_cents, p75_cents, min_cents, max_cents,
				                         listing_count, raw_count)
				values (:ticker, :day, :price, :median, :p25, :p75, :min, :max, :count, :raw)
				on conflict (ticker_key, day) do update set
				    price_cents = excluded.price_cents, median_cents = excluded.median_cents, p25_cents = excluded.p25_cents,
				    p75_cents = excluded.p75_cents, min_cents = excluded.min_cents, max_cents = excluded.max_cents,
				    listing_count = excluded.listing_count, raw_count = excluded.raw_count
				""")
				.param("ticker", tickerKey)
				.param("day", day)
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

	/** 다시 수집했더니 판매 글이 기준보다 적어진 경우, 앞서 저장한 그날 값을 지운다. */
	public void delete(String tickerKey, LocalDate day) {
		jdbc.sql("delete from daily_price where ticker_key = :ticker and day = :day")
				.param("ticker", tickerKey)
				.param("day", day)
				.update();
	}

	public Optional<PriceStats> find(String tickerKey, LocalDate day) {
		return jdbc.sql("""
				select price_cents, median_cents, p25_cents, p75_cents, min_cents, max_cents, listing_count, raw_count
				from daily_price where ticker_key = :ticker and day = :day
				""")
				.param("ticker", tickerKey)
				.param("day", day)
				.query(PriceStats.class)
				.optional();
	}
}
