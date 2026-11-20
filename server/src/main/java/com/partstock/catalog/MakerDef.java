package com.partstock.catalog;

import java.util.List;

/**
 * 제조사와 그 제조사의 모델(시리즈). 제목에 별칭 중 하나가 있으면 그 제조사로 본다.
 * AORUS → GIGABYTE, FURY → Kingston처럼 시리즈 이름만 쓰는 판매자가 있어 별칭에 넣는다.
 */
public record MakerDef(String key, String displayName, List<String> aliases, List<SeriesDef> series) {

	public boolean matches(Title title) {
		return aliases.stream().anyMatch(title::contains);
	}

	public static MakerDef of(String key, String displayName, List<String> aliases, SeriesDef... series) {
		return new MakerDef(key, displayName, aliases, List.of(series));
	}

	/** 모델(시리즈). OC·용량 같은 꼬리는 무시하고 시리즈 단위로 묶는다: "Gaming Trio OC" = "Gaming Trio" */
	public record SeriesDef(String key, String displayName, List<String> aliases) {

		public static SeriesDef of(String key, String displayName, String... aliases) {
			return new SeriesDef(key, displayName, List.of(aliases));
		}

		/** 제목에서 찾은 가장 긴 별칭의 토큰 수. 없으면 0. "AORUS MASTER"가 "AORUS"보다 우선하게 */
		int matchLength(Title title) {
			return aliases.stream()
					.map(a -> Title.of(a).tokens())
					.filter(title::contains)
					.mapToInt(List::size)
					.max()
					.orElse(0);
		}
	}
}
