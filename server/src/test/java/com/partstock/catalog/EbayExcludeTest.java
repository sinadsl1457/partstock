package com.partstock.catalog;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.Arrays;
import org.junit.jupiter.api.Test;

/**
 * eBay 바로가기에서 뺄 단어. eBay는 "Ryzen 5 7600"에 7600X를, "RTX 5070"에 5070 Ti를 같이 찾아 줘서
 * 싼 순으로 열면 다른 모델이 앞을 채웠다(11/25 사용자 발견). 단어 모양은 eBay에서 실제로 빠지는지 확인한 것.
 */
class EbayExcludeTest {

	static ChipsetDef chipset(String key) {
		return ListingClassifierTest.chipset(key);
	}

	@Test
	void 뒤에_붙으면_다른_모델인_이름을_뺀다() {
		assertThat(chipset("ryzen-5-7600").ebayExclude()).containsExactly("7600X");
		assertThat(chipset("ryzen-9-9950x").ebayExclude()).containsExactly("9950X3");
		assertThat(chipset("rtx-5090").ebayExclude()).containsExactly("5090D");
		assertThat(chipset("rtx-5070").ebayExclude()).containsExactly("SUPER", "5070SUPER", "TI", "5070TI");
		assertThat(chipset("rx-7600").ebayExclude()).containsExactly("XT", "7600XT");
		// 번호가 두 토큰이면 띄어 쓴 쪽만
		assertThat(chipset("rtx-4070-ti").ebayExclude()).containsExactly("SUPER");
	}

	@Test
	void 다른_모델이_없는_종목은_그대로() {
		assertThat(chipset("ryzen-5-7600x").ebayExclude()).containsExactly("7600X3");
		assertThat(chipset("rtx-5070-ti").ebayExclude()).containsExactly("SUPER");
		assertThat(chipset("ddr5-16gb").ebayExclude()).isEmpty();
		assertThat(chipset("990-pro-2tb").ebayExclude()).isEmpty();
	}

	/** 전체 목록을 눈으로 보려고 남긴다: ./gradlew test --tests '*EbayExcludeTest' -i */
	@Test
	void 전체_목록() {
		Arrays.stream(Category.values()).flatMap(c -> Catalog.chipsets(c).stream())
				.filter(c -> !c.ebayExclude().isEmpty())
				.forEach(c -> System.out.printf("%-22s %s -%s%n", c.key(), c.displayName(), String.join(" -", c.ebayExclude())));
	}
}
