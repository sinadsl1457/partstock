package com.partstock.alert;

import java.time.Instant;
import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.List;
import java.util.Optional;
import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.stereotype.Repository;

/** device·price_alert 표. */
@Repository
public class AlertStore {

	private final JdbcClient jdbc;

	public AlertStore(JdbcClient jdbc) {
		this.jdbc = jdbc;
	}

	/** 앱이 켜질 때마다 부른다. 언어가 바뀌었으면 고친다. */
	public void upsertDevice(String token, String platform, String locale, Instant now) {
		jdbc.sql("""
				insert into device (token, platform, locale, created_at, seen_at) values (:t, :p, :l, :now, :now)
				on conflict (token) do update set platform = excluded.platform, locale = excluded.locale,
				                                  seen_at = excluded.seen_at
				""")
				.param("t", token)
				.param("p", platform)
				.param("l", locale)
				.param("now", now.atOffset(ZoneOffset.UTC))
				.update();
	}

	public boolean deviceExists(String token) {
		return jdbc.sql("select exists(select 1 from device where token = :t)").param("t", token)
				.query(Boolean.class).single();
	}

	public void deleteDevice(String token) {
		jdbc.sql("delete from device where token = :t").param("t", token).update();
	}

	public int countWaiting(String token) {
		return jdbc.sql("select count(*) from price_alert where token = :t and fired_at is null").param("t", token)
				.query(Integer.class).single();
	}

	public long insert(String token, String tickerKey, String direction, long targetCents, Instant now) {
		return jdbc.sql("""
				insert into price_alert (token, ticker_key, direction, target_cents, created_at)
				values (:t, :k, :d, :c, :now) returning id
				""")
				.param("t", token)
				.param("k", tickerKey)
				.param("d", direction)
				.param("c", targetCents)
				.param("now", now.atOffset(ZoneOffset.UTC))
				.query(Long.class)
				.single();
	}

	/** 이 기기의 알림만 지운다. 지웠으면 true. */
	public boolean delete(long id, String token) {
		return jdbc.sql("delete from price_alert where id = :id and token = :t").param("id", id).param("t", token)
				.update() > 0;
	}

	/** 이 기기의 알림(대기 중 먼저, 최근 것 먼저). 종목 이름을 붙여서. */
	public List<AlertRow> list(String token) {
		return jdbc.sql("""
				select a.id, a.ticker_key, t.display_name, t.level, t.chipset_key, t.maker_key,
				       a.direction, a.target_cents, a.created_at, a.fired_at, a.fired_cents
				from price_alert a join ticker t on t.key = a.ticker_key
				where a.token = :t
				order by (a.fired_at is not null), a.created_at desc
				""")
				.param("t", token)
				.query(AlertRow.class)
				.list();
	}

	public Optional<AlertRow> find(long id) {
		return jdbc.sql("""
				select a.id, a.ticker_key, t.display_name, t.level, t.chipset_key, t.maker_key,
				       a.direction, a.target_cents, a.created_at, a.fired_at, a.fired_cents
				from price_alert a join ticker t on t.key = a.ticker_key where a.id = :id
				""")
				.param("id", id)
				.query(AlertRow.class)
				.optional();
	}

	/** 그날 대표가가 조건에 닿은 대기 중 알림. */
	public List<DueRow> due(LocalDate day) {
		return jdbc.sql("""
				select a.id, a.token, a.ticker_key, a.direction, a.target_cents, d.locale, p.p25_cents as now_cents
				from price_alert a
				join device d on d.token = a.token
				join daily_price p on p.ticker_key = a.ticker_key and p.day = :day
				where a.fired_at is null
				  and ((a.direction = 'BELOW' and p.p25_cents <= a.target_cents)
				    or (a.direction = 'ABOVE' and p.p25_cents >= a.target_cents))
				order by a.id
				""")
				.param("day", day)
				.query(DueRow.class)
				.list();
	}

	public void markFired(long id, long cents, Instant at) {
		jdbc.sql("update price_alert set fired_at = :at, fired_cents = :c where id = :id")
				.param("at", at.atOffset(ZoneOffset.UTC))
				.param("c", cents)
				.param("id", id)
				.update();
	}

	public record AlertRow(long id, String tickerKey, String displayName, String level, String chipsetKey,
			String makerKey, String direction, long targetCents, OffsetDateTime createdAt, OffsetDateTime firedAt,
			Long firedCents) {}

	public record DueRow(long id, String token, String tickerKey, String direction, long targetCents, String locale,
			long nowCents) {}
}
