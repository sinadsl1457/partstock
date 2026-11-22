package com.partstock.api;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

/**
 * 바로가기 주소. 웹·앱이 같은 주소를 쓰게 서버에서 만든다.
 * eBay: 우리가 센 것과 같은 조건(새 상품·즉시 구매)의 검색 결과.
 * 다나와: 상품 번호(pcode)를 사람이 넣어 둔 종목은 상품 페이지, 아니면 검색 결과(다나와는 긁어 오지 않고 링크만).
 */
public record Links(String ebay, String danawa) {

	static Links of(String ebayQuery, String ebayCategoryId, String danawaQuery, String danawaPcode) {
		String ebay = "https://www.ebay.com/sch/i.html?_nkw=" + enc(ebayQuery) + "&_sacat=" + ebayCategoryId
				+ "&LH_BIN=1&LH_ItemCondition=1000";
		String danawa = danawaPcode != null && !danawaPcode.isBlank()
				? "https://prod.danawa.com/info/?pcode=" + enc(danawaPcode)
				: "https://search.danawa.com/dsearch.php?query=" + enc(danawaQuery);
		return new Links(ebay, danawa);
	}

	private static String enc(String s) {
		return URLEncoder.encode(s, StandardCharsets.UTF_8).replace("+", "%20");
	}
}
