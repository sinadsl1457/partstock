package com.partstock.catalog;

import com.partstock.catalog.MakerDef.SeriesDef;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * 판매 글 제목 → 어느 종목(칩셋 / 제조사 / 모델)에 들어가는지.
 * 칩셋 X로 검색해서 받은 글이 실제로 X 한 개만 가리킬 때만 받는다. 제조사·모델은 찾으면 붙이고 못 찾으면 칩셋에만 센다.
 */
public final class ListingClassifier {

	private ListingClassifier() {}

	public static Optional<Classification> classify(ChipsetDef queried, String rawTitle) {
		Title title = Title.of(rawTitle);
		Category category = queried.category();

		if (excluded(title, Catalog.COMMON_EXCLUDES) || excluded(title, Catalog.excludes(category))) {
			return Optional.empty();
		}
		// 검색한 칩셋이어야 하고, 같은 탭의 다른 칩셋이 같이 걸리면(5070 Ti vs 5080 비교 글 등) 어느 쪽인지 몰라 버린다
		List<ChipsetDef> hits = Catalog.chipsets(category).stream().filter(c -> c.matches(title)).toList();
		if (hits.size() != 1 || !hits.getFirst().key().equals(queried.key())) {
			return Optional.empty();
		}

		List<MakerDef> makers = Catalog.makers(category).stream().filter(m -> m.matches(title)).toList();
		if (makers.size() != 1) {
			return Optional.of(new Classification(queried, null, null));
		}
		MakerDef maker = makers.getFirst();
		return Optional.of(new Classification(queried, maker, series(maker, title)));
	}

	/** 가장 길게 맞은 시리즈. 길이가 같은 다른 시리즈가 같이 맞으면 모른다고 본다. */
	static SeriesDef series(MakerDef maker, Title title) {
		SeriesDef best = null;
		int bestLen = 0;
		boolean tie = false;
		for (SeriesDef s : maker.series()) {
			int len = s.matchLength(title);
			if (len > bestLen) {
				best = s;
				bestLen = len;
				tie = false;
			} else if (len > 0 && len == bestLen) {
				tie = true;
			}
		}
		return tie ? null : best;
	}

	private static boolean excluded(Title title, List<String> phrases) {
		return phrases.stream().anyMatch(title::contains);
	}

	/** maker·series는 못 찾으면 null. */
	public record Classification(ChipsetDef chipset, MakerDef maker, SeriesDef series) {

		/** 이 글이 들어가는 종목 키들. rtx-5070-ti, rtx-5070-ti/msi, rtx-5070-ti/msi/gaming-trio */
		public List<String> tickerKeys() {
			List<String> keys = new ArrayList<>();
			keys.add(chipset.key());
			if (maker != null) {
				keys.add(chipset.key() + "/" + maker.key());
				if (series != null) {
					keys.add(chipset.key() + "/" + maker.key() + "/" + series.key());
				}
			}
			return keys;
		}
	}
}
