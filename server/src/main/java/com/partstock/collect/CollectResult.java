package com.partstock.collect;

import java.util.List;

/** 한 번 수집한 결과 요약. 칩셋 하나가 실패해도 나머지는 계속하고 PARTIAL로 남긴다. */
public record CollectResult(
		Status status, int apiCalls, int listingsSeen, int listingsUsed, int pricesSaved, List<String> errors) {

	public enum Status { OK, PARTIAL, FAILED }
}
