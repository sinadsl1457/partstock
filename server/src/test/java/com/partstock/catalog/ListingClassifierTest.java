package com.partstock.catalog;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.List;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

/** 제목 예시는 eBay에서 흔한 모양을 흉내 낸 것. 키를 받으면 실제 제목으로 사례를 늘린다. */
class ListingClassifierTest {

	static ChipsetDef chipset(String key) {
		return java.util.Arrays.stream(Category.values())
				.flatMap(cat -> Catalog.chipsets(cat).stream())
				.filter(c -> c.key().equals(key))
				.findFirst()
				.orElseThrow();
	}

	static List<String> keys(String chipsetKey, String title) {
		return ListingClassifier.classify(chipset(chipsetKey), title)
				.map(ListingClassifier.Classification::tickerKeys)
				.orElse(List.of());
	}

	@Test
	void 칩셋_제조사_모델까지_가른다() {
		assertThat(keys("rtx-5070-ti", "MSI GeForce RTX 5070 Ti 16GB GAMING TRIO OC GDDR7 Graphics Card NEW"))
				.containsExactly("rtx-5070-ti", "rtx-5070-ti/msi", "rtx-5070-ti/msi/gaming-trio");
	}

	@Test
	void 붙여_쓴_칩셋_이름도_알아본다() {
		assertThat(keys("rtx-5070-ti", "ASUS TUF Gaming RTX5070Ti OC 16GB")).containsExactly(
				"rtx-5070-ti", "rtx-5070-ti/asus", "rtx-5070-ti/asus/tuf");
	}

	@ParameterizedTest
	@CsvSource(delimiter = '|', textBlock = """
			rtx-5070    | MSI GeForce RTX 5070 Ti 16GB VENTUS 3X OC
			rtx-5070-ti | Gigabyte RTX 5070 12GB Windforce OC
			rtx-5060    | ZOTAC RTX 5060 Ti 8GB Twin Edge
			rx-9070     | Sapphire Pulse AMD Radeon RX 9070 XT 16GB
			""")
	void 검색한_칩셋과_다른_칩셋_글은_버린다(String queried, String title) {
		assertThat(keys(queried, title)).isEmpty();
	}

	@Test
	void 메모리_용량으로_나뉘는_칩셋은_용량까지_맞아야_한다() {
		assertThat(keys("rtx-5060-ti-16gb", "PNY RTX 5060 Ti 16GB OC Dual Fan")).contains("rtx-5060-ti-16gb");
		assertThat(keys("rtx-5060-ti-16gb", "PNY RTX 5060 Ti 8GB OC Dual Fan")).isEmpty();
		assertThat(keys("rtx-5060-ti-8gb", "PNY RTX 5060 Ti 8GB OC Dual Fan")).contains("rtx-5060-ti-8gb");
		// 용량이 없으면 어느 쪽인지 몰라 버린다
		assertThat(keys("rtx-5060-ti-16gb", "PNY RTX 5060 Ti OC")).isEmpty();
	}

	@ParameterizedTest
	@CsvSource(delimiter = '|', textBlock = """
			EMPTY BOX ONLY - MSI RTX 5070 Ti Gaming Trio
			MSI RTX 5070 Ti Gaming Trio FOR PARTS not working
			Gaming PC Ryzen 7 9800X3D RTX 5070 Ti 32GB DDR5 2TB
			EKWB water block for ASUS TUF RTX 5070 Ti
			Alienware laptop RTX 5070 Ti
			Lot of 3 RTX 5070 Ti
			""")
	void 부품_한_개가_아닌_글은_버린다(String title) {
		assertThat(keys("rtx-5070-ti", title)).isEmpty();
	}

	@Test
	void 비교_글처럼_칩셋이_둘_걸리면_버린다() {
		assertThat(keys("rtx-5070-ti", "RTX 5070 Ti or RTX 5080 Founders Edition")).isEmpty();
	}

	@Test
	void 제조사를_모르면_칩셋에만_센다() {
		assertThat(keys("rtx-5070-ti", "NVIDIA GeForce RTX 5070 Ti 16GB GDDR7 Graphics Card")).containsExactly("rtx-5070-ti");
	}

	@Test
	void 시리즈_이름만_써도_제조사를_안다() {
		assertThat(keys("rtx-5080", "AORUS GeForce RTX 5080 MASTER 16G")).containsExactly(
				"rtx-5080", "rtx-5080/gigabyte", "rtx-5080/gigabyte/aorus-master");
	}

	@Test
	void 긴_시리즈_이름이_짧은_것보다_우선() {
		assertThat(keys("rtx-5090", "ZOTAC GAMING GeForce RTX 5090 AMP Extreme INFINITY 32GB")).contains(
				"rtx-5090/zotac/amp-extreme");
	}

	@Test
	void 제조사는_알지만_시리즈를_모르면_제조사까지만() {
		assertThat(keys("rx-9070-xt", "PowerColor AMD Radeon RX 9070 XT 16GB GDDR6")).containsExactly(
				"rx-9070-xt", "rx-9070-xt/powercolor");
	}

	@Test
	void 파운더스_에디션은_제조사_겸_모델() {
		assertThat(keys("rtx-5090", "NVIDIA GeForce RTX 5090 Founders Edition 32GB")).containsExactly(
				"rtx-5090", "rtx-5090/nvidia", "rtx-5090/nvidia/founders-edition");
	}

	@ParameterizedTest
	@CsvSource(delimiter = '|', textBlock = """
			Corsair Vengeance RGB 32GB (2x16GB) DDR5 6000MHz CL30 Desktop Memory | ddr5-2x16gb/corsair/vengeance-rgb
			G.SKILL Trident Z5 Neo RGB DDR5-6000 32GB 2x16GB                     | ddr5-2x16gb/gskill/trident-z5
			Kingston FURY Beast 32GB (16GBx2) DDR5 5600                          | ddr5-2x16gb/kingston/fury-beast
			Crucial Pro 32GB Kit (2 x 16GB) DDR5-5600 UDIMM                      | ddr5-2x16gb/crucial/pro
			G.SKILL Trident Z5 RGB Series 32GB (2 x 16GB) 288-Pin PC RAM DDR5 6000 | ddr5-2x16gb/gskill/trident-z5
			Patriot Viper Elite 5 32GB (2x16G) DDR5-6000 PC5-48000 C30 UDIMM XMP | ddr5-2x16gb/patriot/viper
			TEAMGROUP T-FORCE DELTA RGB DDR5 32GB (2x16) 7800MHz CL38-48-48-84   | ddr5-2x16gb/teamgroup/delta
			Corsair Vengeance DDR5 2x16 32GB 6400MHz RAM RGB XMP READY           | ddr5-2x16gb/corsair/vengeance
			""")
	void 램은_세대와_2개_묶음_구성으로_가른다(String title, String expectedModelKey) {
		assertThat(keys("ddr5-2x16gb", title)).contains("ddr5-2x16gb", expectedModelKey);
	}

	@ParameterizedTest
	@CsvSource(delimiter = '|', textBlock = """
			Corsair Vengeance 32GB (1x32GB) DDR5 5600
			Corsair Vengeance 64GB (2x32GB) DDR5 6000
			Crucial 32GB (2x16GB) DDR5 5600 SODIMM Laptop Memory
			Samsung 32GB 2x16GB DDR5 4800 ECC RDIMM Server
			Kingston 32GB (2x16GB) DDR5 4800 ECC Registered
			Corsair Vengeance LPX 32GB (2x16GB) DDR4 3200
			Crucial Pro DDR5 Kit 6400MHz 32GB (2x16GB) 64GB (2x32GB) Desktop Memory OC UDIMM
			Crucial Pro Overclocking 32GB DDR5 6000Mt/s  Desktop Memory Module UDIMM
			Factory Sealed G.Skill Trident Z5 NEO RGB  32GB (2x16) 6000 CL36  RAM
			""")
	void 다른_구성_노트북용_서버용_다른_세대_구성_모름_여러_구성_세대_모름은_버린다(String title) {
		// 세대가 제목에 없으면 검색어만 믿지 않는다(DDR4 글이 섞일 수 있어서)
		assertThat(keys("ddr5-2x16gb", title)).isEmpty();
	}

	// 1개짜리(11/22 점검의 실제 eBay 제목). "(1 x 8GB)"를 묶음으로 잘못 봐서 버리던 것을 고정
	@ParameterizedTest
	@CsvSource(delimiter = '|', textBlock = """
			ddr5-8gb  | Crucial 8GB (1 x 8GB) PC5-38400 (DDR5-4800) UDIMM Memory (CT8G48C40U5)
			ddr5-8gb  | NEW PNY 8GB 1x8GB PC5 DDR5 5600 Desktop Memory RAM MD8GSD5560046-TB
			ddr5-8gb  | A-Tech 8GB DDR5 4800 MHz PC5-38400 Desktop 288-Pin DIMM Non-ECC Memory RAM 1x 8G
			ddr5-8gb  | G.SKILL Flare X5 Series DDR5 RAM (AMD Expo) 8GB (1X8Gb) up to 6000Mt/S* CL30-38-
			ddr5-16gb | SK Hynix 16GB DDR5 5600MHz PC5-44800 1Rx8 UDIMM Desktop RAM HMCG78AGBUA081N
			ddr5-32gb | Crucial Pro Overclocking 32GB DDR5 6000Mt/s  Desktop Memory Module UDIMM
			""")
	void 램_1개짜리(String chipsetKey, String title) {
		assertThat(keys(chipsetKey, title)).contains(chipsetKey);
	}

	@ParameterizedTest
	@CsvSource(delimiter = '|', textBlock = """
			ddr5-16gb | PNY DDR5 16GB (2x8GB) 5600MHz CL46 Performance Desktop Memory Kit
			ddr5-16gb | G.SKILL F56000J3038F8GH2FX5 16GB DDR5 6000 Desktop Memory Kit CL30
			ddr5-16gb | NEW 32GB (2x16GB) PNY DDR5 PC5-6000 Desktop RAM PC UDIMM
			ddr5-16gb | Kingston FURY Beast 32GB (16GBx2) DDR5 5600
			ddr5-16gb | Samsung 16GB DDR5 4800 2PCS Desktop RAM
			ddr5-16gb | Crucial 16GB DDR4 3200 Desktop Memory
			ddr5-8gb  | SK Hynix 16GB DDR5 5600MHz PC5-44800 1Rx8 UDIMM Desktop RAM HMCG78AGBUA081N
			""")
	void 램_1개짜리에_묶음_다른_용량_다른_세대는_넣지_않는다(String chipsetKey, String title) {
		assertThat(keys(chipsetKey, title)).isEmpty();
	}

	// 40 시리즈: 같은 번호의 Ti·Super를 가른다(11/22 점검의 실제 제목)
	@ParameterizedTest
	@CsvSource(delimiter = '|', textBlock = """
			ASUS Prime GeForce RTX 4070 Ti SUPER 16GB GDDR6X Graphics Card - NEW SHIPS TODAY | rtx-4070-ti-super
			MSI Gaming GeForce RTX 4070 Ti 12GB GDDR6X PCI Express 4.0 Video Card RTX 4070 T  | rtx-4070-ti
			MSI Ventus GeForce RTX 4070 12GB GDDR6X PCI Express 4.0 ATX Video Card RTX 4070    | rtx-4070
			ZOTAC Gaming GeForce RTX 4080 16GB AMP Extreme AIRO GDDR6X  ZT-D40810B-10P *NEW*  | rtx-4080
			ASRock Challenger Radeon RX 7600 8GB GDDR6 PCI Express 4.0 x8 ATX Graphics Card   | rx-7600
			""")
	void 그래픽카드_40_시리즈(String title, String expected) {
		for (String key : List.of("rtx-4070-ti-super", "rtx-4070-ti", "rtx-4070-super", "rtx-4070", "rtx-4080",
				"rtx-4080-super", "rx-7600")) {
			if (key.equals(expected)) {
				assertThat(keys(key, title)).as(key).contains(key);
			} else {
				assertThat(keys(key, title)).as(key).isEmpty();
			}
		}
	}

	@Test
	void 필터용_분류() {
		assertThat(chipset("rtx-4070").facets()).containsEntry("series", "RTX40");
		assertThat(chipset("rtx-5090").facets()).containsEntry("series", "RTX50");
		assertThat(chipset("rx-9070-xt").facets()).containsEntry("series", "RX9000");
		assertThat(chipset("rx-7900-xtx").facets()).containsEntry("series", "RX7000");
		assertThat(chipset("ddr5-16gb").facets()).containsEntry("ddr", "DDR5").containsEntry("pack", "1");
		assertThat(chipset("ddr4-2x8gb").facets()).containsEntry("ddr", "DDR4").containsEntry("pack", "2");
	}

	// CPU(11/22 점검의 실제 eBay 제목). 번호가 비슷한 다른 CPU를 가른다
	@ParameterizedTest
	@CsvSource(delimiter = '|', textBlock = """
			AMD Ryzen 7 9800X3D 8-Core 16-Thread Processor CPU Socket AM5                    | ryzen-7-9800x3d
			NEW Sealed Box AMD Ryzen 9 9950X3D 16-Core Socket AM5 CPU 100-100000719WOF      | ryzen-9-9950x3d
			AMD Ryzen 5 7600X 6-Core 4.7GHz Socket AM5 CPU Processor MPN 100-100000593WOF  | ryzen-5-7600x
			Intel Core i9-14900K 24-Core 3.20GHz LGA1700 Desktop CPU *New W/ Bad Box*       | core-i9-14900k
			Intel Core i7-14700KF Unlocked Desktop Processor                                 | core-i7-14700kf
			Intel Core Ultra 7 265K Desktop Processor                                        | core-ultra-7-265k
			""")
	void CPU(String title, String expected) {
		for (ChipsetDef c : Catalog.CPU_CHIPSETS) {
			if (c.key().equals(expected)) {
				assertThat(keys(c.key(), title)).as(c.key()).containsExactly(expected); // CPU는 제조사·모델 단계가 없다
			} else {
				assertThat(keys(c.key(), title)).as(c.key()).isEmpty();
			}
		}
	}

	@ParameterizedTest
	@CsvSource(delimiter = '|', textBlock = """
			AMD - Ryzen 9 9950X3D2 Dual Edition 16-Core - 32-Thread 4.3GHz (5.6GHz Boost)
			AMD Ryzen 7 9800X3D + ASUS TUF B650 Motherboard Combo
			Intel Core i9-14900K ES QS Engineering Sample
			""")
	void CPU_다른_제품_묶음_샘플은_버린다(String title) {
		for (ChipsetDef c : Catalog.CPU_CHIPSETS) {
			assertThat(keys(c.key(), title)).as(c.key()).isEmpty();
		}
	}

	// SSD(11/22 점검의 실제 eBay 제목): 모델 + 용량. 2000GB도 2TB
	@ParameterizedTest
	@CsvSource(delimiter = '|', textBlock = """
			NEW Samsung 990 PRO 2TB NVMe PCIe 4.0 M.2 2280 SSD MZ-V9P2T0/AM (AMX)          | 990-pro-2tb
			Samsung 990PRO 2000GB M.2 NVMe Internal SSD                                     | 990-pro-2tb
			SAMSUNG 990 EVO Plus 1TB PCIe 4.0/5.0 NVMe M.2 2280 Internal SSD               | 990-evo-plus-1tb
			WD_BLACK SN850X 2TB NVMe SSD M.2 2280 PCIe 4.0 x4 Internal Solid State Drive  | sn850x-2tb
			Western Digital 4TB WD Blue SN5000 NVMe Internal SSD                            | -
			""")
	void SSD(String title, String expected) {
		for (ChipsetDef c : Catalog.SSD_CHIPSETS) {
			if (c.key().equals(expected)) {
				assertThat(keys(c.key(), title)).as(c.key()).containsExactly(expected);
			} else {
				assertThat(keys(c.key(), title)).as(c.key()).isEmpty(); // SN5000 4TB는 목록에 없는 용량
			}
		}
	}

	@ParameterizedTest
	@CsvSource(delimiter = '|', textBlock = """
			SAMSUNG 990 PRO 1TB 2TB 4TB M.2 2280 PCIe 4.0 x4 NVMe 2.0 V7 V-NAND 3bit MLC SSD
			Samsung 990 1TB NVMe M.2 Internal SSD MZ-V9V1T0 Sealed
			WD_BLACK 4TB SN850P NVMe M.2 SSD With Heatsink Model WDBBYV0040BNC Brand New
			Crucial BX500 1TB 3D NAND SATA 2.5Inch Up to 540MBs Internal SSD CT1000BX500SSD1
			Samsung T7 Portable SSD 2TB USB 3.2 External
			Lot of 5 Samsung 870 EVO 1TB SATA SSD
			""")
	void SSD_여러_용량_다른_모델_외장_묶음은_버린다(String title) {
		for (ChipsetDef c : Catalog.SSD_CHIPSETS) {
			assertThat(keys(c.key(), title)).as(c.key()).isEmpty();
		}
	}
}
