package com.partstock.collect;

import java.time.LocalDate;
import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.stereotype.Repository;

/** market_check 표: 칩셋별 하루 새 상품 글 수·중고 글 수. 수집(CollectService)이 하루 한 번 쓴다. */
@Repository
public class MarketCheckStore {

	private final JdbcClient jdbc;

	public MarketCheckStore(JdbcClient jdbc) {
		this.jdbc = jdbc;
	}

	public boolean checkedOn(LocalDate day) {
		return jdbc.sql("select exists(select 1 from market_check where day = :day)")
				.param("day", day)
				.query(Boolean.class)
				.single();
	}

	public void upsert(String tickerKey, LocalDate day, int newCount, int usedCount) {
		jdbc.sql("""
				insert into market_check (ticker_key, day, new_count, used_count) values (:key, :day, :new, :used)
				on conflict (ticker_key, day) do update set new_count = excluded.new_count, used_count = excluded.used_count
				""")
				.param("key", tickerKey)
				.param("day", day)
				.param("new", newCount)
				.param("used", usedCount)
				.update();
	}
}
