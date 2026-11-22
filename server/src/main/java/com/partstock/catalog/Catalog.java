package com.partstock.catalog;

import static com.partstock.catalog.ChipsetDef.CpuBrand.INTEL;
import static com.partstock.catalog.ChipsetDef.GpuVendor.AMD;
import static com.partstock.catalog.ChipsetDef.cpu;
import static com.partstock.catalog.ChipsetDef.ssd;
import static com.partstock.catalog.ChipsetDef.GpuVendor.NVIDIA;
import static com.partstock.catalog.ChipsetDef.gpu;
import static com.partstock.catalog.ChipsetDef.ram;
import static com.partstock.catalog.ChipsetDef.ramSingle;
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
			// 8GB는 미국 eBay 새 상품이 하루 3개 정도라 시세가 안 나와 뺐다(11/21 실측). 16GB 쪽은 8GB 글이 섞이지 않게 계속 거른다
			gpu("rx-9060-xt-16gb", "RX 9060 XT 16GB", AMD, List.of("9060", "XT"), Set.of(), 16, 8),
			// 이전 세대(11/22 사용자 결정: 40 시리즈까지, AMD는 같은 세대 RX 7000). 새 상품이 적어 데이터 없는 시각이 잦다
			// (11/22 점검: 4080 Super·4060 Ti 16GB·7900 XT·7900 GRE는 1~3개)
			gpu("rtx-4090", "RTX 4090", NVIDIA, List.of("4090"), Set.of("D"), null, null),
			gpu("rtx-4080-super", "RTX 4080 Super", NVIDIA, List.of("4080", "SUPER"), Set.of(), null, null),
			gpu("rtx-4080", "RTX 4080", NVIDIA, List.of("4080"), Set.of("SUPER"), null, null),
			gpu("rtx-4070-ti-super", "RTX 4070 Ti Super", NVIDIA, List.of("4070", "TI", "SUPER"), Set.of(), null, null),
			gpu("rtx-4070-ti", "RTX 4070 Ti", NVIDIA, List.of("4070", "TI"), Set.of("SUPER"), null, null),
			gpu("rtx-4070-super", "RTX 4070 Super", NVIDIA, List.of("4070", "SUPER"), Set.of(), null, null),
			gpu("rtx-4070", "RTX 4070", NVIDIA, List.of("4070"), Set.of("TI", "SUPER"), null, null),
			gpu("rtx-4060-ti-16gb", "RTX 4060 Ti 16GB", NVIDIA, List.of("4060", "TI"), Set.of(), 16, 8),
			gpu("rtx-4060-ti-8gb", "RTX 4060 Ti 8GB", NVIDIA, List.of("4060", "TI"), Set.of(), 8, 16),
			gpu("rtx-4060", "RTX 4060", NVIDIA, List.of("4060"), Set.of("TI"), null, null),
			gpu("rx-7900-xtx", "RX 7900 XTX", AMD, List.of("7900", "XTX"), Set.of(), null, null),
			gpu("rx-7900-xt", "RX 7900 XT", AMD, List.of("7900", "XT"), Set.of(), null, null),
			gpu("rx-7900-gre", "RX 7900 GRE", AMD, List.of("7900", "GRE"), Set.of(), null, null),
			gpu("rx-7800-xt", "RX 7800 XT", AMD, List.of("7800", "XT"), Set.of(), null, null),
			gpu("rx-7700-xt", "RX 7700 XT", AMD, List.of("7700", "XT"), Set.of(), null, null),
			gpu("rx-7600", "RX 7600", AMD, List.of("7600"), Set.of("XT"), null, null));

	/**
	 * 1개짜리가 기본(한국은 1개 단위 판매가 흔함, 11/22 사용자 결정), 2개 묶음은 필터로 본다.
	 * 2개 묶음 키는 11/22에 ddr5-32gb → ddr5-2x16gb로 옮겼다(V5 마이그레이션, 1개짜리가 그 이름을 씀).
	 */
	public static final List<ChipsetDef> RAM_CHIPSETS = List.of(
			ramSingle("ddr5-16gb", 5, 16),
			ramSingle("ddr5-32gb", 5, 32),
			ramSingle("ddr5-8gb", 5, 8),
			ramSingle("ddr5-48gb", 5, 48),
			ramSingle("ddr4-16gb", 4, 16),
			ramSingle("ddr4-8gb", 4, 8),
			ramSingle("ddr4-32gb", 4, 32),
			ram("ddr5-2x16gb", 5, 16),
			ram("ddr5-2x32gb", 5, 32),
			ram("ddr5-2x48gb", 5, 48),
			ram("ddr5-2x8gb", 5, 8),
			ram("ddr4-2x16gb", 4, 16),
			ram("ddr4-2x8gb", 4, 8),
			ram("ddr4-2x32gb", 4, 32));

	/**
	 * CPU(11/22 사용자 결정: VGA·RAM 다음 분류). AMD Ryzen 9000·7000, Intel Core Ultra 200S·14·13세대.
	 * CPU는 칩 = 제품이라 제조사·모델 단계가 없다(종목 하나 = 칩 하나).
	 */
	public static final List<ChipsetDef> CPU_CHIPSETS = List.of(
			// 9950X3D2(듀얼 에디션, 더 비쌈)는 다른 제품이라 뒤에 2가 오면 뺀다
			cpu("ryzen-9-9950x3d", "Ryzen 9 9950X3D", com.partstock.catalog.ChipsetDef.CpuBrand.AMD, "RYZEN9000", List.of("9950", "X", "3", "D"), Set.of("2")),
			cpu("ryzen-9-9950x", "Ryzen 9 9950X", com.partstock.catalog.ChipsetDef.CpuBrand.AMD, "RYZEN9000", List.of("9950", "X"), Set.of("3")),
			cpu("ryzen-9-9900x", "Ryzen 9 9900X", com.partstock.catalog.ChipsetDef.CpuBrand.AMD, "RYZEN9000", List.of("9900", "X"), Set.of("3")),
			cpu("ryzen-7-9800x3d", "Ryzen 7 9800X3D", com.partstock.catalog.ChipsetDef.CpuBrand.AMD, "RYZEN9000", List.of("9800", "X", "3", "D"), Set.of()),
			cpu("ryzen-7-9700x", "Ryzen 7 9700X", com.partstock.catalog.ChipsetDef.CpuBrand.AMD, "RYZEN9000", List.of("9700", "X"), Set.of("3")),
			cpu("ryzen-5-9600x", "Ryzen 5 9600X", com.partstock.catalog.ChipsetDef.CpuBrand.AMD, "RYZEN9000", List.of("9600", "X"), Set.of("3")),
			cpu("ryzen-9-7950x3d", "Ryzen 9 7950X3D", com.partstock.catalog.ChipsetDef.CpuBrand.AMD, "RYZEN7000", List.of("7950", "X", "3", "D"), Set.of()),
			cpu("ryzen-7-7800x3d", "Ryzen 7 7800X3D", com.partstock.catalog.ChipsetDef.CpuBrand.AMD, "RYZEN7000", List.of("7800", "X", "3", "D"), Set.of()),
			cpu("ryzen-7-7700x", "Ryzen 7 7700X", com.partstock.catalog.ChipsetDef.CpuBrand.AMD, "RYZEN7000", List.of("7700", "X"), Set.of("3")),
			cpu("ryzen-5-7600x", "Ryzen 5 7600X", com.partstock.catalog.ChipsetDef.CpuBrand.AMD, "RYZEN7000", List.of("7600", "X"), Set.of("3")),
			cpu("ryzen-5-7600", "Ryzen 5 7600", com.partstock.catalog.ChipsetDef.CpuBrand.AMD, "RYZEN7000", List.of("7600"), Set.of("X")),
			cpu("core-ultra-9-285k", "Core Ultra 9 285K", INTEL, "ULTRA200", List.of("285", "K"), Set.of()),
			cpu("core-ultra-7-265k", "Core Ultra 7 265K", INTEL, "ULTRA200", List.of("265", "K"), Set.of()),
			cpu("core-ultra-7-265kf", "Core Ultra 7 265KF", INTEL, "ULTRA200", List.of("265", "KF"), Set.of()),
			cpu("core-ultra-5-245k", "Core Ultra 5 245K", INTEL, "ULTRA200", List.of("245", "K"), Set.of()),
			cpu("core-i9-14900k", "Core i9-14900K", INTEL, "CORE14", List.of("14900", "K"), Set.of()),
			cpu("core-i7-14700k", "Core i7-14700K", INTEL, "CORE14", List.of("14700", "K"), Set.of()),
			cpu("core-i7-14700kf", "Core i7-14700KF", INTEL, "CORE14", List.of("14700", "KF"), Set.of()),
			cpu("core-i5-14600k", "Core i5-14600K", INTEL, "CORE14", List.of("14600", "K"), Set.of()),
			cpu("core-i5-14400f", "Core i5-14400F", INTEL, "CORE14", List.of("14400", "F"), Set.of()),
			cpu("core-i9-13900k", "Core i9-13900K", INTEL, "CORE13", List.of("13900", "K"), Set.of()),
			cpu("core-i7-13700k", "Core i7-13700K", INTEL, "CORE13", List.of("13700", "K"), Set.of()),
			cpu("core-i5-13600k", "Core i5-13600K", INTEL, "CORE13", List.of("13600", "K"), Set.of()),
			cpu("core-i5-13400f", "Core i5-13400F", INTEL, "CORE13", List.of("13400", "F"), Set.of()));

	/**
	 * SSD(11/22 사용자 결정). 인기 NVMe·SATA 14모델 × 용량. 종목 = 모델 + 용량(용량마다 값이 달라서).
	 * 방열판 포함 판(PS5용 등)은 같은 종목으로 센다.
	 */
	public static final List<ChipsetDef> SSD_CHIPSETS = List.of(
			ssd("990-pro-1tb", "Samsung 990 PRO", com.partstock.catalog.ChipsetDef.SsdBrand.SAMSUNG, "NVME4", List.of("990", "PRO"), Set.of(), 1),
			ssd("990-pro-2tb", "Samsung 990 PRO", com.partstock.catalog.ChipsetDef.SsdBrand.SAMSUNG, "NVME4", List.of("990", "PRO"), Set.of(), 2),
			ssd("990-pro-4tb", "Samsung 990 PRO", com.partstock.catalog.ChipsetDef.SsdBrand.SAMSUNG, "NVME4", List.of("990", "PRO"), Set.of(), 4),
			ssd("990-evo-plus-1tb", "Samsung 990 EVO Plus", com.partstock.catalog.ChipsetDef.SsdBrand.SAMSUNG, "NVME4", List.of("990", "EVO", "PLUS"), Set.of(), 1),
			ssd("990-evo-plus-2tb", "Samsung 990 EVO Plus", com.partstock.catalog.ChipsetDef.SsdBrand.SAMSUNG, "NVME4", List.of("990", "EVO", "PLUS"), Set.of(), 2),
			ssd("990-evo-plus-4tb", "Samsung 990 EVO Plus", com.partstock.catalog.ChipsetDef.SsdBrand.SAMSUNG, "NVME4", List.of("990", "EVO", "PLUS"), Set.of(), 4),
			ssd("9100-pro-1tb", "Samsung 9100 PRO", com.partstock.catalog.ChipsetDef.SsdBrand.SAMSUNG, "NVME5", List.of("9100", "PRO"), Set.of(), 1),
			ssd("9100-pro-2tb", "Samsung 9100 PRO", com.partstock.catalog.ChipsetDef.SsdBrand.SAMSUNG, "NVME5", List.of("9100", "PRO"), Set.of(), 2),
			ssd("9100-pro-4tb", "Samsung 9100 PRO", com.partstock.catalog.ChipsetDef.SsdBrand.SAMSUNG, "NVME5", List.of("9100", "PRO"), Set.of(), 4),
			ssd("870-evo-1tb", "Samsung 870 EVO", com.partstock.catalog.ChipsetDef.SsdBrand.SAMSUNG, "SATA", List.of("870", "EVO"), Set.of(), 1),
			ssd("870-evo-2tb", "Samsung 870 EVO", com.partstock.catalog.ChipsetDef.SsdBrand.SAMSUNG, "SATA", List.of("870", "EVO"), Set.of(), 2),
			ssd("870-evo-4tb", "Samsung 870 EVO", com.partstock.catalog.ChipsetDef.SsdBrand.SAMSUNG, "SATA", List.of("870", "EVO"), Set.of(), 4),
			ssd("sn850x-1tb", "WD Black SN850X", com.partstock.catalog.ChipsetDef.SsdBrand.WD, "NVME4", List.of("SN", "850", "X"), Set.of(), 1),
			ssd("sn850x-2tb", "WD Black SN850X", com.partstock.catalog.ChipsetDef.SsdBrand.WD, "NVME4", List.of("SN", "850", "X"), Set.of(), 2),
			ssd("sn850x-4tb", "WD Black SN850X", com.partstock.catalog.ChipsetDef.SsdBrand.WD, "NVME4", List.of("SN", "850", "X"), Set.of(), 4),
			ssd("sn8100-1tb", "WD Black SN8100", com.partstock.catalog.ChipsetDef.SsdBrand.WD, "NVME5", List.of("SN", "8100"), Set.of(), 1),
			ssd("sn8100-2tb", "WD Black SN8100", com.partstock.catalog.ChipsetDef.SsdBrand.WD, "NVME5", List.of("SN", "8100"), Set.of(), 2),
			ssd("sn8100-4tb", "WD Black SN8100", com.partstock.catalog.ChipsetDef.SsdBrand.WD, "NVME5", List.of("SN", "8100"), Set.of(), 4),
			ssd("sn5000-1tb", "WD Blue SN5000", com.partstock.catalog.ChipsetDef.SsdBrand.WD, "NVME4", List.of("SN", "5000"), Set.of(), 1),
			ssd("sn5000-2tb", "WD Blue SN5000", com.partstock.catalog.ChipsetDef.SsdBrand.WD, "NVME4", List.of("SN", "5000"), Set.of(), 2),
			ssd("t705-1tb", "Crucial T705", com.partstock.catalog.ChipsetDef.SsdBrand.CRUCIAL, "NVME5", List.of("T", "705"), Set.of(), 1),
			ssd("t705-2tb", "Crucial T705", com.partstock.catalog.ChipsetDef.SsdBrand.CRUCIAL, "NVME5", List.of("T", "705"), Set.of(), 2),
			ssd("t705-4tb", "Crucial T705", com.partstock.catalog.ChipsetDef.SsdBrand.CRUCIAL, "NVME5", List.of("T", "705"), Set.of(), 4),
			ssd("t500-1tb", "Crucial T500", com.partstock.catalog.ChipsetDef.SsdBrand.CRUCIAL, "NVME4", List.of("T", "500"), Set.of(), 1),
			ssd("t500-2tb", "Crucial T500", com.partstock.catalog.ChipsetDef.SsdBrand.CRUCIAL, "NVME4", List.of("T", "500"), Set.of(), 2),
			ssd("p3-plus-1tb", "Crucial P3 Plus", com.partstock.catalog.ChipsetDef.SsdBrand.CRUCIAL, "NVME4", List.of("P", "3", "PLUS"), Set.of(), 1),
			ssd("p3-plus-2tb", "Crucial P3 Plus", com.partstock.catalog.ChipsetDef.SsdBrand.CRUCIAL, "NVME4", List.of("P", "3", "PLUS"), Set.of(), 2),
			ssd("p3-plus-4tb", "Crucial P3 Plus", com.partstock.catalog.ChipsetDef.SsdBrand.CRUCIAL, "NVME4", List.of("P", "3", "PLUS"), Set.of(), 4),
			ssd("mx500-1tb", "Crucial MX500", com.partstock.catalog.ChipsetDef.SsdBrand.CRUCIAL, "SATA", List.of("MX", "500"), Set.of(), 1),
			ssd("mx500-2tb", "Crucial MX500", com.partstock.catalog.ChipsetDef.SsdBrand.CRUCIAL, "SATA", List.of("MX", "500"), Set.of(), 2),
			ssd("kc3000-1tb", "Kingston KC3000", com.partstock.catalog.ChipsetDef.SsdBrand.KINGSTON, "NVME4", List.of("KC", "3000"), Set.of(), 1),
			ssd("kc3000-2tb", "Kingston KC3000", com.partstock.catalog.ChipsetDef.SsdBrand.KINGSTON, "NVME4", List.of("KC", "3000"), Set.of(), 2),
			ssd("nv3-1tb", "Kingston NV3", com.partstock.catalog.ChipsetDef.SsdBrand.KINGSTON, "NVME4", List.of("NV", "3"), Set.of(), 1),
			ssd("nv3-2tb", "Kingston NV3", com.partstock.catalog.ChipsetDef.SsdBrand.KINGSTON, "NVME4", List.of("NV", "3"), Set.of(), 2),
			ssd("p41-1tb", "SK hynix Platinum P41", com.partstock.catalog.ChipsetDef.SsdBrand.SKHYNIX, "NVME4", List.of("P", "41"), Set.of(), 1),
			ssd("p41-2tb", "SK hynix Platinum P41", com.partstock.catalog.ChipsetDef.SsdBrand.SKHYNIX, "NVME4", List.of("P", "41"), Set.of(), 2));

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

	/** 메인보드·쿨러 묶음, 엔지니어링 샘플(ES·QS), 완본체 */
	public static final List<String> CPU_EXCLUDES = List.of(
			"COMBO", "BUNDLE", "MOTHERBOARD", "MOBO", "ENGINEERING SAMPLE", "ES", "QS", "GAMING PC", "DESKTOP PC",
			"COMPUTER", "PREBUILT");

	/** 외장 케이스·휴대용·여러 개 묶음·노트북 완제품 */
	public static final List<String> SSD_EXCLUDES = List.of(
			"ENCLOSURE", "EXTERNAL", "PORTABLE", "USB", "ADAPTER", "LOT", "PACK", "MACBOOK", "DESKTOP PC", "COMPUTER");

	public static final List<String> RAM_EXCLUDES = List.of(
			"SODIMM", "SO DIMM", "ECC", "RDIMM", "LRDIMM", "REGISTERED", "SERVER");

	public static List<ChipsetDef> chipsets(Category category) {
		return switch (category) {
			case GPU -> GPU_CHIPSETS;
			case RAM -> RAM_CHIPSETS;
			case CPU -> CPU_CHIPSETS;
			case SSD -> SSD_CHIPSETS;
		};
	}

	public static List<MakerDef> makers(Category category) {
		return switch (category) {
			case GPU -> GPU_MAKERS;
			case RAM -> RAM_MAKERS;
			case CPU, SSD -> List.of(); // 종목 = 제품(제조사·모델 단계 없음)
		};
	}

	public static List<String> excludes(Category category) {
		return switch (category) {
			case GPU -> GPU_EXCLUDES;
			case RAM -> RAM_EXCLUDES;
			case CPU -> CPU_EXCLUDES;
			case SSD -> SSD_EXCLUDES;
		};
	}
}
