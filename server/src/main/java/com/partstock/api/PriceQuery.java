package com.partstock.api;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
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

	/** 가장 최근 수집 시각과 그날. 아직 한 번도 수집 안 했으면 비어 있음. */
	public Optional<Latest> latest() {
		return jdbc.sql("""
				select ts, cast(ts at time zone 'UTC' as date) as day
				from price_snapshot order by ts desc limit 1
				""")
				.query(Latest.class)
				.optional();
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
	 * 종목 목록과 그날 시세(daily_price = 그날 가장 최근 값), 24시간 전 시세(변동용).
	 * 24시간 전 = prevAt 이전의 가장 가까운 스냅샷. level·category·chipset·prefix는 null이면 조건에서 뺀다.
	 */
	public List<QuoteRow> quotes(String level, String category, String chipsetKey, String keyPrefix, LocalDate day,
			Instant prevAt) {
		return jdbc.sql("""
				select t.key, t.level, t.display_name, t.maker_key, t.series_key, t.danawa_pcode,
				       p.p25_cents, p.median_cents, p.p75_cents, p.listing_count,
				       prev.p25_cents as prev_p25_cents, prev.ts as prev_at
				from ticker t
				left join daily_price p on p.ticker_key = t.key and p.day = :day
				left join lateral (
				    select s.p25_cents, s.ts from price_snapshot s
				    where s.ticker_key = t.key and s.ts <= :prevAt order by s.ts desc limit 1
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
				.param("prevAt", prevAt.atOffset(ZoneOffset.UTC))
				.query(QuoteRow.class)
				.list();
	}

	/** 여러 종목의 매시간 대표가(시세판 작은 추이 그래프). */
	public List<SnapRow> snapshots(List<String> keys, Instant from, Instant to) {
		if (keys.isEmpty()) {
			return List.of();
		}
		return jdbc.sql("""
				select ticker_key, ts, p25_cents from price_snapshot
				where ticker_key in (:keys) and ts > :from and ts <= :to
				order by ticker_key, ts
				""")
				.param("keys", keys)
				.param("from", from.atOffset(ZoneOffset.UTC))
				.param("to", to.atOffset(ZoneOffset.UTC))
				.query(SnapRow.class)
				.list();
	}

	/**
	 * 차트 봉. 봉 하나 = bucket 동안 매시간 대표가(p25)의 처음·최고·최저·마지막, 마지막 중앙값.
	 * bucket은 PostgreSQL interval 글자('1 hour', '4 hours', '1 day', '7 days'). 주 봉은 월요일 0시(UTC) 시작.
	 */
	public List<BarRow> bars(String key, String bucket, Instant from, Instant to) {
		return jdbc.sql("""
				select date_bin(cast(:bucket as interval), ts, timestamptz '2000-01-03 00:00:00+00') as t,
				       (array_agg(p25_cents order by ts))[1] as open_cents,
				       max(p25_cents) as high_cents,
				       min(p25_cents) as low_cents,
				       (array_agg(p25_cents order by ts desc))[1] as close_cents,
				       (array_agg(median_cents order by ts desc))[1] as median_cents,
				       count(*) as samples
				from price_snapshot
				where ticker_key = :key and ts > :from and ts <= :to
				group by 1
				order by 1
				""")
				.param("bucket", bucket)
				.param("key", key)
				.param("from", from.atOffset(ZoneOffset.UTC))
				.param("to", to.atOffset(ZoneOffset.UTC))
				.query(BarRow.class)
				.list();
	}

	public record Latest(OffsetDateTime ts, LocalDate day) {}

	public record FxRow(LocalDate day, BigDecimal usdKrw) {}

	public record TickerRow(String key, String level, String category, String chipsetKey, String makerKey,
			String seriesKey, String displayName, String danawaPcode) {}

	public record QuoteRow(String key, String level, String displayName, String makerKey, String seriesKey,
			String danawaPcode, Long p25Cents, Long medianCents, Long p75Cents, Integer listingCount,
			Long prevP25Cents, OffsetDateTime prevAt) {}

	public record SnapRow(String tickerKey, OffsetDateTime ts, long p25Cents) {}

	public record BarRow(OffsetDateTime t, long openCents, long highCents, long lowCents, long closeCents,
			long medianCents, int samples) {}
}
