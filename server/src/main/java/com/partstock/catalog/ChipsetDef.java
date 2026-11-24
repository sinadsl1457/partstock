package com.partstock.catalog;

import java.util.List;
import java.util.Map;
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
		Predicate<Title> matcher,
		/** 화면 필터용 분류(GPU: series=RTX50…, RAM: ddr=DDR5, pack=1|2). 필터를 늘리면 여기 키만 늘린다 */
		Map<String, String> facets,
		/**
		 * eBay 바로가기 검색어에서 뺄 단어(notNext에서 만든다). eBay는 "Ryzen 5 7600"에 7600X도 찾아 주고,
		 * 싼 순으로 열면 더 싼 7600X가 앞을 다 채웠다(11/25). 수집 검색어에는 안 붙인다(제목 검사로 이미 거름).
		 */
		List<String> ebayExclude) {

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
		return new ChipsetDef(key, Category.GPU, displayName, displayName, matcher, Map.of("series", series(vendor, model.get(0))),
				excludeWords(model, notNext));
	}

	/**
	 * 데스크톱 램 2개 묶음. 예: ram("ddr5-2x16gb", 5, 16) → DDR5 32GB (2×16GB)
	 * 1개짜리·4개짜리는 가격 단위가 달라 섞지 않는다. 제목에 "2x16(GB)"나 "16GBx2"처럼 구성이 있어야 한다.
	 */
	public static ChipsetDef ram(String key, int ddr, int moduleGb) {
		String gen = String.valueOf(ddr);
		String otherGen = ddr == 5 ? "4" : "5";
		String size = String.valueOf(moduleGb);
		Predicate<Title> matcher = t -> t.contains(List.of("DDR", gen))
				&& !t.contains(List.of("DDR", otherGen))
				// 2x16GB, 2x16, (2x16G), 16GBx2, 16Gx2 — GB를 빼고 쓰는 판매자가 많다
				&& (t.contains(List.of("2", "X", size))
						|| t.contains(List.of(size, "GB", "X", "2"))
						|| t.contains(List.of(size, "G", "X", "2")));
		String display = "DDR%d %dGB (2×%dGB)".formatted(ddr, moduleGb * 2, moduleGb);
		String query = "DDR%d %dGB 2x%dGB desktop".formatted(ddr, moduleGb * 2, moduleGb);
		return new ChipsetDef(key, Category.RAM, display, query, matcher, Map.of("ddr", "DDR" + ddr, "pack", "2"), List.of());
	}

	/** 램 용량 중 흔한 값. 1개짜리 제목에 다른 용량이 같이 있으면(묶음 합계 등) 어느 쪽인지 몰라 뺀다 */
	private static final List<Integer> RAM_SIZES = List.of(4, 8, 16, 24, 32, 48, 64, 96, 128);

	/**
	 * 데스크톱 램 1개짜리. 예: ramSingle("ddr5-16gb", 5, 16) → DDR5 16GB
	 * 한국은 1개 단위 판매가 기본이라 이쪽이 기본 종목(11/22 사용자 결정). 묶음 표시(2x, x2, KIT, 2PCS…)가 있으면 뺀다.
	 */
	public static ChipsetDef ramSingle(String key, int ddr, int gb) {
		String gen = String.valueOf(ddr);
		String otherGen = ddr == 5 ? "4" : "5";
		String size = String.valueOf(gb);
		Predicate<Title> matcher = t -> t.contains(List.of("DDR", gen))
				&& !t.contains(List.of("DDR", otherGen))
				&& (t.contains(List.of(size, "GB")) || t.contains(List.of(size, "G")))
				&& !isKit(t)
				&& RAM_SIZES.stream().filter(o -> o != gb).map(String::valueOf)
						.noneMatch(o -> t.contains(List.of(o, "GB")) || t.contains(List.of(o, "G")));
		String display = "DDR%d %dGB".formatted(ddr, gb);
		String query = "DDR%d %dGB desktop memory".formatted(ddr, gb);
		return new ChipsetDef(key, Category.RAM, display, query, matcher, Map.of("ddr", "DDR" + ddr, "pack", "1"), List.of());
	}

	/** 묶음 표시: "2x16GB"·"(2 x 8GB)"처럼 개수 × , "16GBx2"처럼 용량 × 개수, "2PCS"·"KIT". "1 x 8GB"(1개)는 묶음이 아니다 */
	private static boolean isKit(Title t) {
		for (String n : List.of("2", "3", "4", "8")) {
			if (t.contains(List.of(n, "X")) || t.contains(List.of("GB", "X", n)) || t.contains(List.of("G", "X", n))
					|| t.contains(List.of(n, "PCS")) || t.contains(List.of(n, "PACK")) || t.contains(List.of(n, "STICKS"))) {
				return true;
			}
		}
		return t.tokens().contains("KIT") || t.tokens().contains("KITS");
	}

	/**
	 * notNext → eBay에서 뺄 단어. eBay는 단어 단위로 빼서 제목에 실제로 쓰이는 모양으로 만든다(11/25 실측).
	 * 글자 여러 개(TI, SUPER, XT, GRE): 띄어 쓴 "5070 Ti"용 "TI"와 붙여 쓴 "5070TI".
	 *   번호가 두 토큰 이상이면 띄어 쓴 쪽만("TI" 하나로 "4070 Ti Super"도 빠진다).
	 * 한 글자(X, D, 3): 붙여 쓴 "7600X", "5090D", "9950X3"만. 따로 쓰인 "X"·"D"를 빼면 엉뚱한 글이 빠진다.
	 *   "-9950X3"으로도 9950X3D가 빠진다.
	 */
	static List<String> excludeWords(List<String> model, Set<String> notNext) {
		String joined = String.join("", model);
		return notNext.stream().sorted().<String>mapMulti((n, out) -> {
			if (n.length() == 1) {
				out.accept(joined + n);
				return;
			}
			out.accept(n);
			if (model.size() == 1) {
				out.accept(joined + n);
			}
		}).toList();
	}

	/** 칩셋 번호로 세대: 5070 → RTX50, 4070 → RTX40, 9070 → RX9000, 7900 → RX7000 */
	static String series(GpuVendor vendor, String number) {
		return vendor == GpuVendor.NVIDIA ? "RTX" + number.substring(0, 2) : "RX" + number.charAt(0) + "000";
	}

	/**
	 * CPU. 예: cpu("ryzen-7-9800x3d", "Ryzen 7 9800X3D", AMD, "RYZEN9000", List.of("9800", "X", "3", "D"), Set.of())
	 * 제목은 숫자·글자 사이가 나뉘어 9800X3D → 9800 X 3 D, 14700KF → 14700 KF가 된다.
	 *
	 * @param notNext 번호 바로 뒤에 오면 다른 CPU인 토큰. 9950X 뒤의 "3"(9950X3D), 7600 뒤의 X(7600X)
	 */
	public static ChipsetDef cpu(String key, String displayName, CpuBrand brand, String series,
			List<String> model, Set<String> notNext) {
		Predicate<Title> matcher = t -> {
			if (brand.familyTokens.stream().noneMatch(f -> t.tokens().contains(f))) {
				return false;
			}
			int at = t.indexOf(model);
			return at >= 0 && !notNext.contains(t.tokenAt(at + model.size()));
		};
		return new ChipsetDef(key, Category.CPU, displayName, displayName, matcher,
				Map.of("brand", brand.name(), "series", series), excludeWords(model, notNext));
	}

	/** SSD 용량(TB). 제목에 다른 용량이 같이 있으면(여러 용량을 한 글에 파는 경우) 뺀다 */
	private static final List<Integer> SSD_TB = List.of(1, 2, 4, 8);

	/**
	 * SSD = 모델 + 용량(용량마다 값이 달라 한 종목으로 묶지 않는다). 예: ssd("990-pro-2tb", "Samsung 990 PRO", SAMSUNG,
	 * "NVME4", List.of("990", "PRO"), Set.of(), 2). 제목의 "2TB"·"2000GB"를 같은 용량으로 본다.
	 */
	public static ChipsetDef ssd(String key, String model, SsdBrand brand, String iface,
			List<String> modelTokens, Set<String> notNext, int tb) {
		Predicate<Title> matcher = t -> {
			if (brand.tokens.stream().noneMatch(f -> t.tokens().contains(f))) {
				return false;
			}
			int at = t.indexOf(modelTokens);
			if (at < 0 || notNext.contains(t.tokenAt(at + modelTokens.size()))) {
				return false;
			}
			return hasTb(t, tb) && SSD_TB.stream().filter(o -> o != tb).noneMatch(o -> hasTb(t, o));
		};
		String display = "%s %dTB".formatted(model, tb);
		return new ChipsetDef(key, Category.SSD, display, display, matcher,
				Map.of("brand", brand.name(), "capacity", tb + "TB", "iface", iface), excludeWords(modelTokens, notNext));
	}

	private static boolean hasTb(Title t, int tb) {
		return t.contains(List.of(String.valueOf(tb), "TB")) || t.contains(List.of(tb * 1000 + "", "GB"));
	}

	public enum SsdBrand {
		SAMSUNG(List.of("SAMSUNG")),
		WD(List.of("WD", "WESTERN")),
		CRUCIAL(List.of("CRUCIAL")),
		KINGSTON(List.of("KINGSTON")),
		SKHYNIX(List.of("HYNIX"));

		final List<String> tokens;

		SsdBrand(List<String> tokens) {
			this.tokens = tokens;
		}
	}

	public enum CpuBrand {
		AMD(List.of("RYZEN")),
		INTEL(List.of("CORE", "INTEL"));

		final List<String> familyTokens;

		CpuBrand(List<String> familyTokens) {
			this.familyTokens = familyTokens;
		}
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
