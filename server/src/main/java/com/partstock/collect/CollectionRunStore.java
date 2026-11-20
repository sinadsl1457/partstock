package com.partstock.collect;

import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneOffset;
import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.stereotype.Repository;

/** collection_run 표: 수집이 언제 돌았고 몇 개를 봤는지. */
@Repository
public class CollectionRunStore {

	private final JdbcClient jdbc;

	public CollectionRunStore(JdbcClient jdbc) {
		this.jdbc = jdbc;
	}

	public long start(LocalDate day, Instant at) {
		return jdbc.sql("""
				insert into collection_run (day, started_at, status) values (:day, :at, 'RUNNING') returning id
				""")
				.param("day", day)
				.param("at", at.atOffset(ZoneOffset.UTC))
				.query(Long.class)
				.single();
	}

	public void finish(long id, Instant at, CollectResult r) {
		jdbc.sql("""
				update collection_run
				set finished_at = :at, status = :status, api_calls = :calls, listings_seen = :seen,
				    listings_used = :used, error = :error
				where id = :id
				""")
				.param("id", id)
				.param("at", at.atOffset(ZoneOffset.UTC))
				.param("status", r.status().name())
				.param("calls", r.apiCalls())
				.param("seen", r.listingsSeen())
				.param("used", r.listingsUsed())
				.param("error", r.errors().isEmpty() ? null : String.join("\n", r.errors()))
				.update();
	}
}
