package com.partstock.catalog;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.List;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

/** 제목 예시는 eBay에서 흔한 모양을 흉내 낸 것. 키를 받으면 실제 제목으로 사례를 늘린다. */
class ListingClassifierTest {

	static ChipsetDef chipset(String key) {
		return Catalog.GPU_CHIPSETS.stream()
				.filter(c -> c.key().equals(key))
				.findFirst()
				.orElseGet(() -> Catalog.RAM_CHIPSETS.stream().filter(c -> c.key().equals(key)).findFirst().orElseThrow());
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
			Corsair Vengeance RGB 32GB (2x16GB) DDR5 6000MHz CL30 Desktop Memory | ddr5-32gb/corsair/vengeance-rgb
			G.SKILL Trident Z5 Neo RGB DDR5-6000 32GB 2x16GB                     | ddr5-32gb/gskill/trident-z5
			Kingston FURY Beast 32GB (16GBx2) DDR5 5600                          | ddr5-32gb/kingston/fury-beast
			Crucial Pro 32GB Kit (2 x 16GB) DDR5-5600 UDIMM                      | ddr5-32gb/crucial/pro
			G.SKILL Trident Z5 RGB Series 32GB (2 x 16GB) 288-Pin PC RAM DDR5 6000 | ddr5-32gb/gskill/trident-z5
			Patriot Viper Elite 5 32GB (2x16G) DDR5-6000 PC5-48000 C30 UDIMM XMP | ddr5-32gb/patriot/viper
			TEAMGROUP T-FORCE DELTA RGB DDR5 32GB (2x16) 7800MHz CL38-48-48-84   | ddr5-32gb/teamgroup/delta
			Corsair Vengeance DDR5 2x16 32GB 6400MHz RAM RGB XMP READY           | ddr5-32gb/corsair/vengeance
			""")
	void 램은_세대와_2개_묶음_구성으로_가른다(String title, String expectedModelKey) {
		assertThat(keys("ddr5-32gb", title)).contains("ddr5-32gb", expectedModelKey);
	}

	@ParameterizedTest
	@CsvSource(delimiter = '|', textBlock = """
			Corsair Vengeance 32GB (1x32GB) DDR5 5600
			Corsair Vengeance 64GB (2x32GB) DDR5 6000
			Crucial 32GB (2x16GB) DDR5 5600 SODIMM Laptop Memory
			Samsung 32GB 2x16GB DDR5 4800 ECC RDIMM Server
			Corsair Vengeance LPX 32GB (2x16GB) DDR4 3200
			Crucial Pro DDR5 Kit 6400MHz 32GB (2x16GB) 64GB (2x32GB) Desktop Memory OC UDIMM
			Crucial Pro Overclocking 32GB DDR5 6000Mt/s  Desktop Memory Module UDIMM
			Factory Sealed G.Skill Trident Z5 NEO RGB  32GB (2x16) 6000 CL36  RAM
			""")
	void 다른_구성_노트북용_서버용_다른_세대_구성_모름_여러_구성_세대_모름은_버린다(String title) {
		// 세대가 제목에 없으면 검색어만 믿지 않는다(DDR4 글이 섞일 수 있어서)
		assertThat(keys("ddr5-32gb", title)).isEmpty();
	}
}
