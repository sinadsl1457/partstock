package com.partstock.catalog;

import static com.partstock.catalog.ChipsetDef.GpuVendor.AMD;
import static com.partstock.catalog.ChipsetDef.GpuVendor.NVIDIA;
import static com.partstock.catalog.ChipsetDef.gpu;
import static com.partstock.catalog.ChipsetDef.ram;
import static com.partstock.catalog.MakerDef.SeriesDef;

import java.util.List;
import java.util.Set;

/**
 * 시세판에 올리는 종목 목록. 제목을 가르는 규칙이라 코드로 두고(git에 기록이 남게),
 * DB의 ticker 표는 이 목록에서 만든다. 다나와 상품 번호처럼 사람이 고치는 값만 DB에서 바꾼다.
 */
public final class Catalog {

	private Catalog() {}

	public static final List<ChipsetDef> GPU_CHIPSETS = List.of(
			gpu("rtx-5090", "RTX 5090", NVIDIA, List.of("5090"), Set.of("D"), null, null),
			gpu("rtx-5080", "RTX 5080", NVIDIA, List.of("5080"), Set.of("SUPER"), null, null),
			gpu("rtx-5070-ti", "RTX 5070 Ti", NVIDIA, List.of("5070", "TI"), Set.of("SUPER"), null, null),
			gpu("rtx-5070", "RTX 5070", NVIDIA, List.of("5070"), Set.of("TI", "SUPER"), null, null),
			gpu("rtx-5060-ti-16gb", "RTX 5060 Ti 16GB", NVIDIA, List.of("5060", "TI"), Set.of(), 16, 8),
			gpu("rtx-5060-ti-8gb", "RTX 5060 Ti 8GB", NVIDIA, List.of("5060", "TI"), Set.of(), 8, 16),
			gpu("rtx-5060", "RTX 5060", NVIDIA, List.of("5060"), Set.of("TI"), null, null),
			gpu("rtx-5050", "RTX 5050", NVIDIA, List.of("5050"), Set.of(), null, null),
			gpu("rx-9070-xt", "RX 9070 XT", AMD, List.of("9070", "XT"), Set.of(), null, null),
			gpu("rx-9070", "RX 9070", AMD, List.of("9070"), Set.of("XT", "GRE"), null, null),
			gpu("rx-9060-xt-16gb", "RX 9060 XT 16GB", AMD, List.of("9060", "XT"), Set.of(), 16, 8),
			gpu("rx-9060-xt-8gb", "RX 9060 XT 8GB", AMD, List.of("9060", "XT"), Set.of(), 8, 16));

	public static final List<ChipsetDef> RAM_CHIPSETS = List.of(
			ram("ddr5-32gb", 5, 16),
			ram("ddr5-64gb", 5, 32),
			ram("ddr5-96gb", 5, 48),
			ram("ddr5-16gb", 5, 8),
			ram("ddr4-32gb", 4, 16),
			ram("ddr4-16gb", 4, 8),
			ram("ddr4-64gb", 4, 32));

	public static final List<MakerDef> GPU_MAKERS = List.of(
			MakerDef.of("asus", "ASUS", List.of("ASUS"),
					SeriesDef.of("rog-astral", "ROG Astral", "ROG ASTRAL", "ASTRAL"),
					SeriesDef.of("rog-strix", "ROG Strix", "ROG STRIX", "STRIX"),
					SeriesDef.of("tuf", "TUF Gaming", "TUF"),
					SeriesDef.of("prime", "Prime", "PRIME"),
					SeriesDef.of("dual", "Dual", "DUAL")),
			MakerDef.of("msi", "MSI", List.of("MSI"),
					SeriesDef.of("suprim", "Suprim", "SUPRIM"),
					SeriesDef.of("vanguard", "Vanguard", "VANGUARD"),
					SeriesDef.of("gaming-trio", "Gaming Trio", "GAMING TRIO", "GAMING X TRIO"),
					SeriesDef.of("ventus", "Ventus", "VENTUS"),
					SeriesDef.of("inspire", "Inspire", "INSPIRE"),
					SeriesDef.of("shadow", "Shadow", "SHADOW")),
			MakerDef.of("gigabyte", "GIGABYTE", List.of("GIGABYTE", "AORUS"),
					// 실제 이름은 "AORUS GeForce RTX 5080 MASTER"처럼 칩셋이 사이에 끼어 MASTER·ELITE만으로도 찾는다
					SeriesDef.of("aorus-master", "AORUS Master", "AORUS MASTER", "MASTER"),
					SeriesDef.of("aorus-elite", "AORUS Elite", "AORUS ELITE", "ELITE"),
					SeriesDef.of("gaming-oc", "Gaming OC", "GAMING OC"),
					SeriesDef.of("aero", "Aero", "AERO"),
					SeriesDef.of("eagle", "Eagle", "EAGLE"),
					SeriesDef.of("windforce", "Windforce", "WINDFORCE")),
			MakerDef.of("zotac", "ZOTAC", List.of("ZOTAC"),
					SeriesDef.of("amp-extreme", "AMP Extreme", "AMP EXTREME"),
					SeriesDef.of("amp", "AMP", "AMP"),
					SeriesDef.of("solid", "Solid", "SOLID"),
					SeriesDef.of("twin-edge", "Twin Edge", "TWIN EDGE")),
			MakerDef.of("pny", "PNY", List.of("PNY")),
			MakerDef.of("nvidia", "NVIDIA Founders Edition", List.of("FOUNDERS EDITION"),
					SeriesDef.of("founders-edition", "Founders Edition", "FOUNDERS EDITION")),
			MakerDef.of("inno3d", "INNO3D", List.of("INNO3D", "INNO 3D")),
			MakerDef.of("palit", "Palit", List.of("PALIT")),
			MakerDef.of("gainward", "Gainward", List.of("GAINWARD")),
			MakerDef.of("galax", "GALAX", List.of("GALAX")),
			MakerDef.of("colorful", "Colorful", List.of("COLORFUL")),
			MakerDef.of("sapphire", "Sapphire", List.of("SAPPHIRE"),
					SeriesDef.of("nitro", "Nitro+", "NITRO"),
					SeriesDef.of("pulse", "Pulse", "PULSE"),
					SeriesDef.of("pure", "Pure", "PURE")),
			MakerDef.of("powercolor", "PowerColor", List.of("POWERCOLOR", "POWER COLOR"),
					SeriesDef.of("red-devil", "Red Devil", "RED DEVIL"),
					SeriesDef.of("hellhound", "Hellhound", "HELLHOUND"),
					SeriesDef.of("reaper", "Reaper", "REAPER")),
			MakerDef.of("xfx", "XFX", List.of("XFX"),
					SeriesDef.of("mercury", "Mercury", "MERCURY"),
					SeriesDef.of("swift", "Swift", "SWIFT"),
					SeriesDef.of("quicksilver", "Quicksilver", "QUICKSILVER")),
			MakerDef.of("asrock", "ASRock", List.of("ASROCK"),
					SeriesDef.of("taichi", "Taichi", "TAICHI"),
					SeriesDef.of("steel-legend", "Steel Legend", "STEEL LEGEND"),
					SeriesDef.of("challenger", "Challenger", "CHALLENGER")));

	public static final List<MakerDef> RAM_MAKERS = List.of(
			MakerDef.of("corsair", "Corsair", List.of("CORSAIR"),
					SeriesDef.of("dominator", "Dominator", "DOMINATOR"),
					SeriesDef.of("vengeance-rgb", "Vengeance RGB", "VENGEANCE RGB"),
					SeriesDef.of("vengeance", "Vengeance", "VENGEANCE")),
			MakerDef.of("gskill", "G.SKILL", List.of("GSKILL", "G SKILL"),
					SeriesDef.of("trident-z5", "Trident Z5", "TRIDENT Z5", "TRIDENT Z 5"),
					SeriesDef.of("flare-x5", "Flare X5", "FLARE X5", "FLARE X 5"),
					SeriesDef.of("ripjaws", "Ripjaws", "RIPJAWS")),
			MakerDef.of("kingston", "Kingston", List.of("KINGSTON", "FURY"),
					SeriesDef.of("fury-renegade", "FURY Renegade", "FURY RENEGADE"),
					SeriesDef.of("fury-beast", "FURY Beast", "FURY BEAST")),
			MakerDef.of("crucial", "Crucial", List.of("CRUCIAL"),
					SeriesDef.of("pro", "Pro", "PRO")),
			MakerDef.of("teamgroup", "TEAMGROUP", List.of("TEAMGROUP", "TEAM GROUP", "TFORCE"),
					SeriesDef.of("delta", "T-Force Delta", "DELTA"),
					SeriesDef.of("vulcan", "T-Force Vulcan", "VULCAN"),
					SeriesDef.of("t-create", "T-Create", "T CREATE", "TCREATE")),
			MakerDef.of("patriot", "Patriot", List.of("PATRIOT"),
					SeriesDef.of("viper", "Viper", "VIPER")),
			MakerDef.of("adata", "ADATA", List.of("ADATA", "XPG"),
					SeriesDef.of("lancer", "XPG Lancer", "LANCER")),
			MakerDef.of("samsung", "Samsung", List.of("SAMSUNG")),
			MakerDef.of("skhynix", "SK hynix", List.of("HYNIX")));

	/**
	 * 이 말이 제목에 있으면 정상 새 부품 한 개가 아니다(상자만, 고장, 노트북, 완본체, 부속품…).
	 * 가격이 크게 달라 시세를 흐린다. 빠져나온 글은 PriceStats의 이상값 제거가 한 번 더 거른다.
	 */
	public static final List<String> COMMON_EXCLUDES = List.of(
			"FOR PARTS", "NOT WORKING", "BROKEN", "DEFECTIVE", "AS IS", "BOX ONLY", "EMPTY BOX", "NO CARD",
			"LOT OF", "LAPTOP", "NOTEBOOK");

	public static final List<String> GPU_EXCLUDES = List.of(
			"BACKPLATE", "BRACKET", "WATERBLOCK", "WATER BLOCK", "SHROUD", "FAN REPLACEMENT", "COOLER ONLY",
			"HEATSINK", "GAMING PC", "GAMING DESKTOP", "DESKTOP PC", "COMPUTER", "PREBUILT", "PRE BUILT",
			"MINI PC", "CABLE", "ADAPTER", "RISER", "STAND", "HOLDER");

	public static final List<String> RAM_EXCLUDES = List.of(
			"SODIMM", "SO DIMM", "ECC", "RDIMM", "LRDIMM", "REGISTERED", "SERVER");

	public static List<ChipsetDef> chipsets(Category category) {
		return category == Category.GPU ? GPU_CHIPSETS : RAM_CHIPSETS;
	}

	public static List<MakerDef> makers(Category category) {
		return category == Category.GPU ? GPU_MAKERS : RAM_MAKERS;
	}

	public static List<String> excludes(Category category) {
		return category == Category.GPU ? GPU_EXCLUDES : RAM_EXCLUDES;
	}
}
