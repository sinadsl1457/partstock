package com.partstock.collect;

import com.partstock.catalog.ChipsetDef;
import java.util.List;

/**
 * 판매 글을 가져오는 곳. 지금은 eBay, 데이터가 나쁘면 다른 출처로 바꿔 끼운다.
 * 새 상품·즉시 구매 글만 돌려준다(경매·중고는 출처 쪽 검색 조건으로 거른다).
 */
public interface ListingSource {

	List<Listing> search(ChipsetDef chipset);

	/** 시세 계산에 필요한 것만. 글 번호·판매자는 받지 않는다(저장 금지 원칙). */
	record Listing(String title, long priceCents, String currency) {}
}
