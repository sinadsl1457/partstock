package com.partstock.collect;

import com.partstock.catalog.ChipsetDef;
import java.util.List;

/**
 * 판매 글을 가져오는 곳. 지금은 eBay, 데이터가 나쁘면 다른 출처로 바꿔 끼운다.
 * 새 상품·즉시 구매 글만 돌려준다(경매·중고는 출처 쪽 검색 조건으로 거른다).
 */
public interface ListingSource {

	List<Listing> search(ChipsetDef chipset);

	/** 지금까지 보낸 요청 수(쪽 단위). 수집 한 번에 몇 번 불렀는지 기록하려고 */
	default long requestCount() {
		return 0;
	}

	/**
	 * 시세 계산에 필요한 것만. 글 번호는 받지 않는다(저장 금지 원칙).
	 * sellerKey: 판매자 이름을 되돌릴 수 없게 바꾼 값. 같은 판매자의 같은 가격 글을 한 번만 세는 데만 쓰고 저장하지 않는다.
	 */
	record Listing(String title, long priceCents, String currency, String sellerKey) {

		public Listing(String title, long priceCents, String currency) {
			this(title, priceCents, currency, null);
		}
	}

	/**
	 * 같은 판매자 + 같은 가격은 한 번만(11/22: 한 판매자가 DDR4 32GB를 제목만 바꿔 $344.95에 197개 올려 시세가 그 값이 됨).
	 * 판매자를 모르면 같은 제목 + 같은 가격만 합친다.
	 */
	static List<Listing> dedupe(List<Listing> listings) {
		var seen = new java.util.HashSet<String>();
		return listings.stream()
				.filter(l -> seen.add((l.sellerKey() != null ? "s:" + l.sellerKey() : "t:" + l.title()) + "|" + l.priceCents()))
				.toList();
	}
}
