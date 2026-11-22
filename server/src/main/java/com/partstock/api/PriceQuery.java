package com.partstock.api;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.stereotype.Repository;

/** 화면용 읽기 쿼리. 쓰기는 collect 쪽 저장소만 한다. */
@Repository
public class PriceQuery {

	private final JdbcClient jdbc;

	public PriceQuery(JdbcClient jdbc) {
		this.jdbc = jdbc;
	}

	/** 시세가 있는 가장 최근 날. 아직 한 번도 수집 안 했으면 비어 있음. */
	public Optional<LocalDate> latestDay() {
		return jdbc.sql("select day from daily_price order by day desc limit 1").query(LocalDate.class).optional();
	}

	/** 그날 또는 그 전 가장 가까운 환율(주말·휴일은 고시가 없어서). */
	public Optional<FxRow> fxOnOrBefore(LocalDate day) {
		return jdbc.sql("select day, usd_krw from fx_rate where day <= :day order by day desc limit 1")
				.param("day", day)
				.query(FxRow.class)
				.optional();
	}

	public Optional<TickerRow> ticker(String key) {
		return jdbc.sql("""
				select key, level, category, chipset_key, maker_key, series_key, display_name, danawa_pcode
				from ticker where key = :key
				""")
				.param("key", key)
				.query(TickerRow.class)
				.optional();
	}

	/**
	 * 종목 목록과 그날 시세, 직전 시세(전일 대비용). 그날 시세가 없으면 가격 칸이 null.
	 * level·category·chipset은 null이면 조건에서 뺀다.
	 */
	public List<QuoteRow> quotes(String level, String category, String chipsetKey, String keyPrefix, LocalDate day) {
		return jdbc.sql("""
				select t.key, t.level, t.display_name, t.maker_key, t.series_key, t.danawa_pcode,
				       p.p25_cents, p.median_cents, p.p75_cents, p.listing_count,
				       prev.p25_cents as prev_p25_cents, prev.day as prev_day
				from ticker t
				left join daily_price p on p.ticker_key = t.key and p.day = :day
				left join lateral (
				    select d.p25_cents, d.day from daily_price d
				    where d.ticker_key = t.key and d.day < :day order by d.day desc limit 1
				) prev on true
				where (cast(:level as varchar) is null or t.level = :level)
				  and (cast(:category as varchar) is null or t.category = :category)
				  and (cast(:chipset as varchar) is null or t.chipset_key = :chipset)
				  and (cast(:prefix as varchar) is null or t.key like :prefix || '/%')
				""")
				.param("level", level)
				.param("category", category)
				.param("chipset", chipsetKey)
				.param("prefix", keyPrefix)
				.param("day", day)
				.query(QuoteRow.class)
				.list();
	}

	/** 여러 종목의 일별 대표가(작은 추이 그래프용). */
	public List<DailyRow> daily(List<String> keys, LocalDate from, LocalDate to) {
		if (keys.isEmpty()) {
			return List.of();
		}
		return jdbc.sql("""
				select ticker_key, day, p25_cents, median_cents, p75_cents
				from daily_price
				where ticker_key in (:keys) and day between :from and :to
				order by ticker_key, day
				""")
				.param("keys", keys)
				.param("from", from)
				.param("to", to)
				.query(DailyRow.class)
				.list();
	}

	/**
	 * 주·월·년 봉. 봉 하나 = 그 기간 하루 대표가(p25)들의 처음·최고·최저·마지막.
	 * unit: week | month | year (PostgreSQL date_trunc 단위. 주는 월요일 시작)
	 */
	public List<CandleRow> candles(String key, String unit, LocalDate from, LocalDate to) {
		return jdbc.sql("""
				select cast(date_trunc(:unit, day) as date) as start,
				       (array_agg(p25_cents order by day))[1] as open_cents,
				       max(p25_cents) as high_cents,
				       min(p25_cents) as low_cents,
				       (array_agg(p25_cents order by day desc))[1] as close_cents,
				       count(*) as days
				from daily_price
				where ticker_key = :key and day between :from and :to
				group by 1
				order by 1
				""")
				.param("unit", unit)
				.param("key", key)
				.param("from", from)
				.param("to", to)
				.query(CandleRow.class)
				.list();
	}

	public record FxRow(LocalDate day, BigDecimal usdKrw) {}

	public record TickerRow(String key, String level, String category, String chipsetKey, String makerKey,
			String seriesKey, String displayName, String danawaPcode) {}

	public record QuoteRow(String key, String level, String displayName, String makerKey, String seriesKey,
			String danawaPcode, Long p25Cents, Long medianCents, Long p75Cents, Integer listingCount, Long prevP25Cents,
			LocalDate prevDay) {}

	public record DailyRow(String tickerKey, LocalDate day, long p25Cents, long medianCents, long p75Cents) {}

	public record CandleRow(LocalDate start, long openCents, long highCents, long lowCents, long closeCents,
			int days) {}
}
