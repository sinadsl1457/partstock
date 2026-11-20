package com.partstock.ticker;

import com.partstock.catalog.Catalog;
import com.partstock.catalog.Category;
import com.partstock.catalog.ChipsetDef;
import com.partstock.catalog.ListingClassifier.Classification;
import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.stereotype.Repository;

/** ticker 표. 이미 있으면 건드리지 않는다(사람이 넣은 다나와 번호를 덮지 않게). */
@Repository
public class TickerStore {

	private static final String INSERT = """
			insert into ticker (key, level, category, chipset_key, maker_key, series_key, display_name)
			values (:key, :level, :category, :chipset, :maker, :series, :name)
			on conflict (key) do nothing
			""";

	private final JdbcClient jdbc;

	public TickerStore(JdbcClient jdbc) {
		this.jdbc = jdbc;
	}

	/** 코드의 칩셋 목록을 표에 맞춘다. 판매 글이 아직 없어도 시세판에 칩셋은 보이게. */
	public void syncChipsets() {
		for (Category category : Category.values()) {
			for (ChipsetDef c : Catalog.chipsets(category)) {
				insert(c.key(), "CHIPSET", c, null, null, c.displayName());
			}
		}
	}

	/** 판매 글이 들어간 제조사·모델 종목을 만든다. 실제로 팔리는 조합만 생긴다. */
	public void ensure(Classification c) {
		if (c.maker() == null) {
			return;
		}
		String makerKey = c.chipset().key() + "/" + c.maker().key();
		insert(makerKey, "MAKER", c.chipset(), c.maker().key(), null, c.maker().displayName());
		if (c.series() != null) {
			insert(makerKey + "/" + c.series().key(), "MODEL", c.chipset(), c.maker().key(), c.series().key(),
					c.series().displayName());
		}
	}

	private void insert(String key, String level, ChipsetDef chipset, String maker, String series, String name) {
		jdbc.sql(INSERT)
				.param("key", key)
				.param("level", level)
				.param("category", chipset.category().name())
				.param("chipset", chipset.key())
				.param("maker", maker)
				.param("series", series)
				.param("name", name)
				.update();
	}
}
