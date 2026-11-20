package com.partstock.price;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * 한 종목의 하루 시세. 판매 글 가격(센트)에서 이상값을 뺀 뒤 계산한다.
 * 가격은 센트 단위 정수: 소수 반올림 오차 없이 더하고 비교하려고.
 */
public record PriceStats(
		long medianCents,
		long p25Cents,
		long p75Cents,
		long minCents,
		long maxCents,
		int listingCount,
		int rawCount) {

	/**
	 * 이상값 기준: 사분위 범위(IQR)의 1.5배 밖(튜키 울타리).
	 * "상자만 팝니다"(아주 쌈)·"PC 통째로"(아주 비쌈)처럼 제목 걸러내기를 빠져나온 글을 여기서 한 번 더 뺀다.
	 */
	static final double FENCE = 1.5;

	/** 판매 글이 minCount개 미만이면 그날 시세는 비워 둔다(몇 개로 낸 중앙값은 믿기 어렵다). */
	public static Optional<PriceStats> of(List<Long> prices, int minCount) {
		if (prices.size() < minCount || prices.isEmpty()) {
			return Optional.empty();
		}
		List<Long> sorted = new ArrayList<>(prices);
		sorted.sort(null);

		double q1 = quantile(sorted, 0.25);
		double q3 = quantile(sorted, 0.75);
		double iqr = q3 - q1;
		double low = q1 - FENCE * iqr;
		double high = q3 + FENCE * iqr;
		List<Long> kept = sorted.stream().filter(p -> p >= low && p <= high).toList();

		if (kept.size() < minCount) {
			return Optional.empty();
		}
		return Optional.of(new PriceStats(
				Math.round(quantile(kept, 0.5)),
				Math.round(quantile(kept, 0.25)),
				Math.round(quantile(kept, 0.75)),
				kept.getFirst(),
				kept.getLast(),
				kept.size(),
				prices.size()));
	}

	/** 정렬된 목록의 분위수. 칸 사이는 직선으로 잇는다(PostgreSQL percentile_cont와 같은 방식). */
	static double quantile(List<Long> sorted, double q) {
		if (sorted.size() == 1) {
			return sorted.getFirst();
		}
		double pos = q * (sorted.size() - 1);
		int lower = (int) Math.floor(pos);
		int upper = (int) Math.ceil(pos);
		double frac = pos - lower;
		return sorted.get(lower) + (sorted.get(upper) - sorted.get(lower)) * frac;
	}
}
