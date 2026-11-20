package com.partstock.catalog;

import java.util.List;
import java.util.Set;
import java.util.function.Predicate;

/**
 * 칩셋 종목 하나(시세판의 "업종 지수"). eBay 검색은 칩셋마다 한 번 하고,
 * 받은 글의 제목이 정말 이 칩셋인지 matcher로 다시 확인한다(검색 결과에는 비슷한 칩셋이 섞여 온다).
 */
public record ChipsetDef(
		String key,
		Category category,
		String displayName,
		String ebayQuery,
		Predicate<Title> matcher) {

	public boolean matches(Title title) {
		return matcher.test(title);
	}

	/**
	 * 그래픽카드 칩셋. 예: gpu("rtx-5070-ti", "RTX 5070 Ti", NVIDIA, List.of("5070", "TI"), Set.of("SUPER"), null, null)
	 *
	 * @param model      칩셋 번호 토큰. ["5070", "TI"]
	 * @param notNext    번호 바로 뒤에 오면 다른 칩셋인 토큰. 5070 뒤의 TI·SUPER
	 * @param memoryGb   메모리 용량으로 나뉘는 칩셋이면 필수 용량(5060 Ti 16GB), 아니면 null
	 * @param otherGb    같은 칩셋의 다른 용량. 제목에 같이 있으면 어느 쪽인지 몰라 뺀다
	 */
	public static ChipsetDef gpu(String key, String displayName, GpuVendor vendor,
			List<String> model, Set<String> notNext, Integer memoryGb, Integer otherGb) {
		Predicate<Title> matcher = t -> {
			if (vendor.familyTokens.stream().noneMatch(f -> t.tokens().contains(f))) {
				return false;
			}
			int at = t.indexOf(model);
			if (at < 0 || notNext.contains(t.tokenAt(at + model.size()))) {
				return false;
			}
			if (memoryGb != null && !t.contains(List.of(memoryGb.toString(), "GB"))) {
				return false;
			}
			return otherGb == null || !t.contains(List.of(otherGb.toString(), "GB"));
		};
		return new ChipsetDef(key, Category.GPU, displayName, displayName, matcher);
	}

	/**
	 * 데스크톱 램 2개 묶음. 예: ram("ddr5-32gb", 5, 16) → DDR5 32GB (2×16GB)
	 * 1개짜리·4개짜리는 가격 단위가 달라 섞지 않는다. 제목에 "2x16GB"나 "16GBx2"가 있어야 한다.
	 */
	public static ChipsetDef ram(String key, int ddr, int moduleGb) {
		String gen = String.valueOf(ddr);
		String otherGen = ddr == 5 ? "4" : "5";
		String size = String.valueOf(moduleGb);
		Predicate<Title> matcher = t -> t.contains(List.of("DDR", gen))
				&& !t.contains(List.of("DDR", otherGen))
				&& (t.contains(List.of("2", "X", size, "GB")) || t.contains(List.of(size, "GB", "X", "2")));
		String display = "DDR%d %dGB (2×%dGB)".formatted(ddr, moduleGb * 2, moduleGb);
		String query = "DDR%d %dGB 2x%dGB desktop".formatted(ddr, moduleGb * 2, moduleGb);
		return new ChipsetDef(key, Category.RAM, display, query, matcher);
	}

	public enum GpuVendor {
		NVIDIA(List.of("RTX", "GEFORCE")),
		AMD(List.of("RX", "RADEON"));

		/** 제목에 이 중 하나는 있어야 그래픽카드로 본다. 숫자 "5070"만으로는 다른 물건일 수 있어서 */
		final List<String> familyTokens;

		GpuVendor(List<String> familyTokens) {
			this.familyTokens = familyTokens;
		}
	}
}
