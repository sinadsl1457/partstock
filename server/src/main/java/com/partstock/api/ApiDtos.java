package com.partstock.api;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/**
 * API 응답 모양. 가격은 모두 USD 센트 정수(웹·앱이 원화로 바꿀 때 fx.usdKrw를 곱한다).
 * 대표가 = p25(하위 25%). 시세가 없는 날은 price가 null.
 */
public final class ApiDtos {

	private ApiDtos() {}

	public record Fx(LocalDate day, BigDecimal usdKrw) {}

	public record Price(long p25Cents, long medianCents, long p75Cents, int listingCount) {}

	/** 전일 대비: 직전에 시세가 있던 날과 비교. 비교할 날이 없으면 null. */
	public record Change(LocalDate prevDay, long prevP25Cents, double pct) {}

	public record Point(LocalDate day, long p25Cents, long medianCents, long p75Cents) {}

	public record Candle(LocalDate start, long openCents, long highCents, long lowCents, long closeCents, int days) {}

	public record BoardItem(String key, String name, String vendor, Price price, Change change, List<Point> spark,
			Links links) {}

	public record Board(String category, LocalDate day, Fx fx, List<BoardItem> items) {}

	public record TickerInfo(String key, String level, String category, String name, String chipsetName,
			String makerName, String seriesName) {}

	public record Child(String key, String level, String name, Price price, Change change, Links links) {}

	/** period=day면 points(최근 30일), 나머지는 candles. */
	public record TickerDetail(TickerInfo ticker, LocalDate day, Fx fx, Price price, Change change, String period,
			List<Point> points, List<Candle> candles, List<Child> makers, List<Child> models, Links links) {}
}
