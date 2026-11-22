package com.partstock.api;

import com.partstock.api.ApiDtos.Board;
import com.partstock.api.ApiDtos.BoardItem;
import com.partstock.api.ApiDtos.Candle;
import com.partstock.api.ApiDtos.Change;
import com.partstock.api.ApiDtos.Child;
import com.partstock.api.ApiDtos.Fx;
import com.partstock.api.ApiDtos.Point;
import com.partstock.api.ApiDtos.Price;
import com.partstock.api.ApiDtos.TickerDetail;
import com.partstock.api.ApiDtos.TickerInfo;
import com.partstock.api.PriceQuery.QuoteRow;
import com.partstock.api.PriceQuery.TickerRow;
import com.partstock.catalog.Catalog;
import com.partstock.catalog.Category;
import com.partstock.catalog.ChipsetDef;
import com.partstock.catalog.MakerDef;
import java.time.LocalDate;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

/** 시세판·종목 상세 응답을 만든다. 순서는 코드의 종목 목록(Catalog) 순서. */
@Service
public class PriceService {

	static final int SPARK_DAYS = 30;

	private final PriceQuery query;

	public PriceService(PriceQuery query) {
		this.query = query;
	}

	public Board board(Category category) {
		Optional<LocalDate> latest = query.latestDay();
		LocalDate day = latest.orElse(null);
		List<ChipsetDef> defs = Catalog.chipsets(category);
		Map<String, QuoteRow> quotes = latest
				.map(d -> query.quotes("CHIPSET", category.name(), null, null, d))
				.orElse(List.of())
				.stream()
				.collect(Collectors.toMap(QuoteRow::key, q -> q));
		Map<String, List<Point>> spark = latest
				.map(d -> query.daily(defs.stream().map(ChipsetDef::key).toList(), d.minusDays(SPARK_DAYS - 1), d))
				.orElse(List.of())
				.stream()
				.collect(Collectors.groupingBy(PriceQuery.DailyRow::tickerKey,
						Collectors.mapping(r -> new Point(r.day(), r.p25Cents(), r.medianCents(), r.p75Cents()),
								Collectors.toList())));

		List<BoardItem> items = defs.stream()
				.map(c -> {
					QuoteRow q = quotes.get(c.key());
					return new BoardItem(c.key(), c.displayName(), vendor(c), price(q), change(q),
							spark.getOrDefault(c.key(), List.of()), chipsetLinks(c, null));
				})
				.toList();
		return new Board(category.name(), day, fx(day), items);
	}

	/** period: day | week | month | year */
	public TickerDetail ticker(String key, String period) {
		TickerRow t = query.ticker(key)
				.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "없는 종목: " + key));
		ChipsetDef chipset = Catalog.chipsets(Category.valueOf(t.category())).stream()
				.filter(c -> c.key().equals(t.chipsetKey()))
				.findFirst()
				.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "목록에서 빠진 칩셋: " + key));
		Optional<MakerDef> maker = makerDef(chipset, t.makerKey());
		String seriesName = "MODEL".equals(t.level()) ? t.displayName() : null;
		String makerName = maker.map(MakerDef::displayName).orElse(null);
		TickerInfo info = new TickerInfo(t.key(), t.level(), t.category(),
				fullName(chipset.displayName(), makerName, seriesName), chipset.displayName(), makerName, seriesName);

		LocalDate day = query.latestDay().orElse(null);
		QuoteRow self = day == null ? null : query.quotes(t.level(), null, chipset.key(), null, day).stream()
				.filter(q -> q.key().equals(key)).findFirst().orElse(null);

		List<Point> points = List.of();
		List<Candle> candles = List.of();
		String p = period == null ? "week" : period;
		if (day != null) {
			switch (p) {
				case "day" -> points = query.daily(List.of(key), day.minusDays(SPARK_DAYS - 1), day).stream()
						.map(r -> new Point(r.day(), r.p25Cents(), r.medianCents(), r.p75Cents()))
						.toList();
				case "week", "month", "year" -> candles = query.candles(key, p, from(p, day), day).stream()
						.map(c -> new Candle(c.start(), c.openCents(), c.highCents(), c.lowCents(), c.closeCents(),
								c.days()))
						.toList();
				default -> throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "period는 day|week|month|year");
			}
		}

		List<Child> makers = List.of();
		List<Child> models = List.of();
		if (day != null && !"MODEL".equals(t.level())) {
			List<QuoteRow> under = query.quotes(null, null, chipset.key(), key, day);
			makers = children(under, "MAKER", chipset);
			models = children(under, "MODEL", chipset);
		}
		Links links = chipsetLinks(chipset, t, maker.orElse(null), seriesName);
		return new TickerDetail(info, day, fx(day), price(self), change(self), p, points, candles, makers, models,
				links);
	}

	private List<Child> children(List<QuoteRow> rows, String level, ChipsetDef chipset) {
		return rows.stream()
				.filter(r -> level.equals(r.level()))
				// 시세가 있는 것 먼저, 그 안에서 판매 글 많은 순
				.sorted(Comparator.comparing((QuoteRow r) -> r.p25Cents() == null)
						.thenComparing(r -> -(r.listingCount() == null ? 0 : r.listingCount())))
				.map(r -> {
					MakerDef m = makerDef(chipset, r.makerKey()).orElse(null);
					String makerName = m == null ? null : m.displayName();
					String name = "MODEL".equals(level) ? makerName + " " + r.displayName() : r.displayName();
					String series = "MODEL".equals(level) ? r.displayName() : null;
					TickerRow row = new TickerRow(r.key(), r.level(), chipset.category().name(), chipset.key(),
							r.makerKey(), r.seriesKey(), r.displayName(), r.danawaPcode());
					return new Child(r.key(), r.level(), name, price(r), change(r),
							chipsetLinks(chipset, row, m, series));
				})
				.toList();
	}

	private Fx fx(LocalDate day) {
		return day == null ? null : query.fxOnOrBefore(day).map(f -> new Fx(f.day(), f.usdKrw())).orElse(null);
	}

	private static Price price(QuoteRow q) {
		return q == null || q.p25Cents() == null ? null
				: new Price(q.p25Cents(), q.medianCents(), q.p75Cents(), q.listingCount());
	}

	private static Change change(QuoteRow q) {
		if (q == null || q.p25Cents() == null || q.prevP25Cents() == null || q.prevP25Cents() == 0) {
			return null;
		}
		double pct = Math.round((q.p25Cents() - q.prevP25Cents()) * 10000.0 / q.prevP25Cents()) / 100.0;
		return new Change(q.prevDay(), q.prevP25Cents(), pct);
	}

	private static LocalDate from(String period, LocalDate day) {
		return switch (period) {
			case "week" -> day.minusWeeks(26);
			case "month" -> day.minusMonths(24);
			default -> LocalDate.of(2000, 1, 1);
		};
	}

	private static String vendor(ChipsetDef c) {
		if (c.category() == Category.RAM) {
			return "DESKTOP"; // 화면 글자는 웹·앱이 언어에 맞게 바꾼다
		}
		return c.key().startsWith("rx-") ? "AMD" : "NVIDIA";
	}

	private static Optional<MakerDef> makerDef(ChipsetDef chipset, String makerKey) {
		return makerKey == null ? Optional.empty()
				: Catalog.makers(chipset.category()).stream().filter(m -> m.key().equals(makerKey)).findFirst();
	}

	static String fullName(String chipset, String maker, String series) {
		StringBuilder sb = new StringBuilder(chipset);
		if (maker != null) {
			sb.append(" · ").append(maker);
		}
		if (series != null) {
			sb.append(" ").append(series);
		}
		return sb.toString();
	}

	private static Links chipsetLinks(ChipsetDef chipset, TickerRow row) {
		return chipsetLinks(chipset, row, null, null);
	}

	/** 검색어: 칩셋 → "RTX 5070 Ti", 제조사 → "MSI RTX 5070 Ti", 모델 → "MSI RTX 5070 Ti Gaming Trio" */
	private static Links chipsetLinks(ChipsetDef chipset, TickerRow row, MakerDef maker, String series) {
		String base = chipset.category() == Category.RAM ? ramQuery(chipset) : chipset.displayName();
		String q = (maker == null ? "" : maker.displayName() + " ") + base + (series == null ? "" : " " + series);
		String ebayQ = maker == null && series == null ? chipset.ebayQuery() : q;
		return Links.of(ebayQ, chipset.category().ebayCategoryId, q, row == null ? null : row.danawaPcode());
	}

	/** "DDR5 32GB (2×16GB)" → "DDR5 32GB 16Gx2" (다나와 표기에 가깝게) */
	private static String ramQuery(ChipsetDef c) {
		return c.displayName().replaceAll("\\(2×(\\d+)GB\\)", "$1Gx2");
	}
}
