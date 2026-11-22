package com.partstock.api;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.util.List;

/**
 * API 응답 모양. 가격은 모두 USD 센트 정수(웹·앱이 원화로 바꿀 때 fx.usdKrw를 곱한다).
 * 대표가 = p25(하위 25%). 시세가 없으면 price가 null. 시각은 UTC(ISO-8601).
 */
public final class ApiDtos {

	private ApiDtos() {}

	public record Fx(LocalDate day, BigDecimal usdKrw) {}

	public record Price(long p25Cents, long medianCents, long p75Cents, int listingCount) {}

	/** 24시간 변동: 24시간 전(또는 그 전 가장 가까운) 시세와 비교. 비교할 시세가 없으면 null. */
	public record Change(OffsetDateTime prevAt, long prevP25Cents, double pct) {}

	public record SparkPoint(OffsetDateTime t, long p25Cents) {}

	public record BoardItem(String key, String name, String vendor, Price price, Change change,
			List<SparkPoint> spark, Links links) {}

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

	/** range: 1d|1w|1m|3m|1y|all, rangePct = 첫 봉 시가 대비 마지막 봉 종가(봉이 2개 미만이면 null). */
	public record Chart(String key, String range, String bucket, List<Bar> bars, Double rangePct) {}
}
