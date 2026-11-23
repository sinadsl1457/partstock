package com.partstock.api;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.util.List;
import java.util.Map;

/**
 * API 응답 모양. 가격은 모두 USD 센트 정수(웹·앱이 원화로 바꿀 때 fx.usdKrw를 곱한다).
 * 대표가 = priceCents(글 20개 이상이면 하위 10%, 적으면 하위 25%; PriceStats). 시세가 없으면 price가 null.
 * p25Cents·prevP25Cents(Change)·p25Cents(SparkPoint)는 대표가가 p25이던 때의 앱·웹을 위해 남긴 이름이다. 시각은 UTC(ISO-8601).
 */
public final class ApiDtos {

	private ApiDtos() {}

	public record Fx(LocalDate day, BigDecimal usdKrw) {}

	/** pricePct = 대표가가 하위 몇 %인지(10 또는 25) */
	public record Price(long priceCents, int pricePct, long p25Cents, long medianCents, long p75Cents, int listingCount) {}

	/** 24시간 변동: 24시간 전(또는 그 전 가장 가까운) 시세와 비교. 비교할 시세가 없으면 null. */
	public record Change(OffsetDateTime prevAt, long prevPriceCents, double pct) {
		/** 옛 앱 호환(값은 대표가) */
		@JsonProperty("prevP25Cents")
		public long prevP25Cents() {
			return prevPriceCents;
		}
	}

	public record SparkPoint(OffsetDateTime t, long priceCents) {
		/** 옛 앱·웹 호환(값은 대표가) */
		@JsonProperty("p25Cents")
		public long p25Cents() {
			return priceCents;
		}
	}

	/** facets: 화면 필터용 분류(GPU series, RAM ddr·pack). 글자는 웹·앱이 바꾼다 */
	public record BoardItem(String key, String name, String vendor, Map<String, String> facets, Price price,
			Change change, List<SparkPoint> spark, Links links) {}

	/** updatedAt = 가장 최근 수집 시각. */
	public record Board(String category, LocalDate day, OffsetDateTime updatedAt, Fx fx, List<BoardItem> items) {}

	public record TickerInfo(String key, String level, String category, String name, String chipsetName,
			String makerName, String seriesName) {}

	public record Child(String key, String level, String name, Price price, Change change, Links links) {}

	public record TickerDetail(TickerInfo ticker, LocalDate day, OffsetDateTime updatedAt, Fx fx, Price price,
			Change change, List<Child> makers, List<Child> models, Links links) {}

	/** 봉 하나. 선 차트는 closeCents를 잇는다. */
	public record Bar(OffsetDateTime t, long openCents, long highCents, long lowCents, long closeCents,
			long medianCents, int samples) {}

	/**
	 * range: 1d|1w|1m|3m|1y|all, rangePct = 첫 봉 시가 대비 마지막 봉 종가(봉이 2개 미만이면 null).
	 * since·points = 이 종목을 처음 수집한 시각과 지금까지 쌓인 매시간 시세 수(봉의 시작 시각과 다르다).
	 */
	public record Chart(String key, String range, String bucket, List<Bar> bars, Double rangePct,
			OffsetDateTime since, int points) {}
}
