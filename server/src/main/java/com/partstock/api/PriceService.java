package com.partstock.api;

import com.partstock.api.ApiDtos.Bar;
import com.partstock.api.ApiDtos.Board;
import com.partstock.api.ApiDtos.BoardItem;
import com.partstock.api.ApiDtos.Change;
import com.partstock.api.ApiDtos.Chart;
import com.partstock.api.ApiDtos.Child;
import com.partstock.api.ApiDtos.Fx;
import com.partstock.api.ApiDtos.Mover;
import com.partstock.api.ApiDtos.Movers;
import com.partstock.api.ApiDtos.Price;
import com.partstock.api.ApiDtos.SparkPoint;
import com.partstock.api.ApiDtos.TickerDetail;
import com.partstock.api.ApiDtos.TickerInfo;
import com.partstock.api.PriceQuery.Latest;
import com.partstock.api.PriceQuery.QuoteRow;
import com.partstock.api.PriceQuery.TickerRow;
import com.partstock.catalog.Catalog;
import com.partstock.catalog.Category;
import com.partstock.catalog.ChipsetDef;
import com.partstock.catalog.MakerDef;
import java.time.Duration;
import java.time.Instant;
import java.time.LocalDate;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

/** 시세판·종목·차트 응답을 만든다. 순서는 코드의 종목 목록(Catalog) 순서. */
@Service
public class PriceService {

	/** 시세판 작은 추이 그래프: 최근 7일 매시간 */
	static final Duration SPARK = Duration.ofDays(7);

	/** 차트 기간 → (보는 길이, 봉 하나 길이) */
	enum Range {
		D1("1d", Duration.ofDays(1), "1 hour"),
		W1("1w", Duration.ofDays(7), "4 hours"),
		M1("1m", Duration.ofDays(30), "1 day"),
		M3("3m", Duration.ofDays(90), "1 day"),
		Y1("1y", Duration.ofDays(365), "7 days"),
		ALL("all", null, "7 days");

		final String code;
		final Duration span;
		final String bucket;

		Range(String code, Duration span, String bucket) {
			this.code = code;
			this.span = span;
			this.bucket = bucket;
		}

		static Range of(String code) {
			for (Range r : values()) {
				if (r.code.equals(code)) {
					return r;
				}
			}
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "range는 1d|1w|1m|3m|1y|all");
		}
	}

	/** 급등·급락에 넣는 최소 판매 글 수. 글이 적으면 싼 글 하나로 ±16%씩 튄다(11/24 실측: RX 7900 XTX 글 5개 +16%) */
	static final int MOVER_MIN_LISTINGS = 20;
	static final int MOVER_LIMIT = 5;

	private final PriceQuery query;

	public PriceService(PriceQuery query) {
		this.query = query;
	}

	public Board board(Category category) {
		Optional<Latest> latest = query.latest();
		// 단종돼 새 상품 글이 중고보다 적은 칩셋은 뺀다(남은 새 글은 비싼 재고라 시세가 부풀어 있다)
		java.util.Set<String> usedMarket = query.usedMarketKeys();
		List<ChipsetDef> defs = Catalog.chipsets(category).stream().filter(c -> !usedMarket.contains(c.key())).toList();
		Map<String, QuoteRow> quotes = latest
				.map(l -> query.quotes("CHIPSET", category.name(), null, null, l.day(), prevAt(l)))
				.orElse(List.of())
				.stream()
				.collect(Collectors.toMap(QuoteRow::key, q -> q));
		Map<String, List<SparkPoint>> spark = latest
				.map(l -> query.snapshots(defs.stream().map(ChipsetDef::key).toList(),
						l.ts().toInstant().minus(SPARK), l.ts().toInstant()))
				.orElse(List.of())
				.stream()
				.collect(Collectors.groupingBy(PriceQuery.SnapRow::tickerKey,
						Collectors.mapping(r -> new SparkPoint(r.ts(), r.priceCents()), Collectors.toList())));

		List<BoardItem> items = defs.stream()
				.map(c -> {
					QuoteRow q = quotes.get(c.key());
					return new BoardItem(c.key(), c.displayName(), vendor(c), c.facets(), price(q), change(q),
							spark.getOrDefault(c.key(), List.of()), links(c, null, null, null));
				})
				.toList();
		LocalDate day = latest.map(Latest::day).orElse(null);
		return new Board(category.name(), day, latest.map(Latest::ts).orElse(null), fx(day), items);
	}

	public Movers movers() {
		Optional<Latest> latest = query.latest();
		LocalDate day = latest.map(Latest::day).orElse(null);
		if (latest.isEmpty()) {
			return new Movers(null, null, null, MOVER_MIN_LISTINGS, List.of(), List.of());
		}
		Map<String, ChipsetDef> defs = Arrays.stream(Category.values())
				.flatMap(c -> Catalog.chipsets(c).stream())
				.collect(Collectors.toMap(ChipsetDef::key, c -> c));
		java.util.Set<String> usedMarket = query.usedMarketKeys();
		List<Mover> all = query.quotes("CHIPSET", null, null, null, day, prevAt(latest.get())).stream()
				.filter(q -> defs.containsKey(q.key()) && !usedMarket.contains(q.key()))
				.filter(q -> q.listingCount() != null && q.listingCount() >= MOVER_MIN_LISTINGS)
				.map(q -> {
					ChipsetDef c = defs.get(q.key());
					return new Mover(c.key(), c.displayName(), c.category().name(), vendor(c), price(q), change(q));
				})
				.filter(m -> m.price() != null && m.change() != null && m.change().pct() != 0)
				.toList();
		// 변동이 같으면 판매 글이 많은 쪽(더 믿을 만한 값)을 위로
		Comparator<Mover> byListings = Comparator.comparingInt((Mover m) -> -m.price().listingCount());
		List<Mover> up = all.stream().filter(m -> m.change().pct() > 0)
				.sorted(Comparator.comparingDouble((Mover m) -> -m.change().pct()).thenComparing(byListings))
				.limit(MOVER_LIMIT).toList();
		List<Mover> down = all.stream().filter(m -> m.change().pct() < 0)
				.sorted(Comparator.comparingDouble((Mover m) -> m.change().pct()).thenComparing(byListings))
				.limit(MOVER_LIMIT).toList();
		return new Movers(day, latest.get().ts(), fx(day), MOVER_MIN_LISTINGS, up, down);
	}

	public TickerDetail ticker(String key) {
		Resolved r = resolve(key);
		TickerRow t = r.row();
		Optional<Latest> latest = query.latest();
		LocalDate day = latest.map(Latest::day).orElse(null);

		QuoteRow self = latest.flatMap(l -> query.quotes(t.level(), null, r.chipset().key(), null, l.day(), prevAt(l))
				.stream().filter(q -> q.key().equals(key)).findFirst()).orElse(null);

		List<Child> makers = List.of();
		List<Child> models = List.of();
		if (latest.isPresent() && !"MODEL".equals(t.level())) {
			List<QuoteRow> under = query.quotes(null, null, r.chipset().key(), key, day, prevAt(latest.get()));
			makers = children(under, "MAKER", r.chipset());
			models = children(under, "MODEL", r.chipset());
		}
		return new TickerDetail(r.info(), day, latest.map(Latest::ts).orElse(null), fx(day), price(self),
				change(self), makers, models, links(r.chipset(), t.danawaPcode(), r.maker(), r.info().seriesName()),
				query.usedMarketKeys().contains(r.chipset().key()));
	}

	public Chart chart(String key, String rangeCode) {
		Range range = Range.of(rangeCode);
		resolve(key); // 없는 종목이면 404
		Optional<Latest> latest = query.latest();
		if (latest.isEmpty()) {
			return new Chart(key, range.code, range.bucket, List.of(), null, null, 0);
		}
		Instant to = latest.get().ts().toInstant();
		Instant from = range.span == null ? Instant.EPOCH : to.minus(range.span);
		List<Bar> bars = query.bars(key, range.bucket, from, to).stream()
				.map(b -> new Bar(b.t(), b.openCents(), b.highCents(), b.lowCents(), b.closeCents(), b.medianCents(),
						b.samples()))
				.toList();
		Double pct = bars.size() < 2 ? null : pct(bars.getFirst().openCents(), bars.getLast().closeCents());
		PriceQuery.Collected c = query.collected(key);
		return new Chart(key, range.code, range.bucket, bars, pct, c.since(), c.points());
	}

	private record Resolved(TickerRow row, ChipsetDef chipset, MakerDef maker, TickerInfo info) {}

	private Resolved resolve(String key) {
		TickerRow t = query.ticker(key)
				.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "없는 종목: " + key));
		ChipsetDef chipset = Catalog.chipsets(Category.valueOf(t.category())).stream()
				.filter(c -> c.key().equals(t.chipsetKey()))
				.findFirst()
				.orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "목록에서 빠진 칩셋: " + key));
		MakerDef maker = makerDef(chipset, t.makerKey()).orElse(null);
		String seriesName = "MODEL".equals(t.level()) ? t.displayName() : null;
		String makerName = maker == null ? null : maker.displayName();
		TickerInfo info = new TickerInfo(t.key(), t.level(), t.category(),
				fullName(chipset.displayName(), makerName, seriesName), chipset.displayName(), makerName, seriesName);
		return new Resolved(t, chipset, maker, info);
	}

	private List<Child> children(List<QuoteRow> rows, String level, ChipsetDef chipset) {
		return rows.stream()
				.filter(r -> level.equals(r.level()))
				// 시세가 있는 것 먼저, 그 안에서 판매 글 많은 순
				.sorted(Comparator.comparing((QuoteRow r) -> r.priceCents() == null)
						.thenComparing(r -> -(r.listingCount() == null ? 0 : r.listingCount())))
				.map(r -> {
					MakerDef m = makerDef(chipset, r.makerKey()).orElse(null);
					String makerName = m == null ? null : m.displayName();
					String series = "MODEL".equals(level) ? r.displayName() : null;
					String name = series != null ? makerName + " " + series : r.displayName();
					return new Child(r.key(), r.level(), name, price(r), change(r),
							links(chipset, r.danawaPcode(), m, series));
				})
				.toList();
	}

	private static Instant prevAt(Latest l) {
		return l.ts().toInstant().minus(Duration.ofHours(24));
	}

	private Fx fx(LocalDate day) {
		return day == null ? null : query.fxOnOrBefore(day).map(f -> new Fx(f.day(), f.usdKrw())).orElse(null);
	}

	private static Price price(QuoteRow q) {
		return q == null || q.priceCents() == null ? null
				: new Price(q.priceCents(), com.partstock.price.PriceStats.pricePct(q.listingCount()), q.medianCents(), q.p75Cents(), q.listingCount());
	}

	private static Change change(QuoteRow q) {
		if (q == null || q.priceCents() == null || q.prevPriceCents() == null || q.prevPriceCents() == 0) {
			return null;
		}
		return new Change(q.prevAt(), q.prevPriceCents(), pct(q.prevPriceCents(), q.priceCents()));
	}

	private static double pct(long from, long to) {
		return Math.round((to - from) * 10000.0 / from) / 100.0;
	}

	private static String vendor(ChipsetDef c) {
		if (c.category() == Category.RAM) {
			return "DESKTOP"; // 화면 글자는 웹·앱이 언어에 맞게 바꾼다
		}
		if (c.category() == Category.CPU) {
			return c.facets().get("brand"); // AMD | INTEL
		}
		if (c.category() == Category.SSD) {
			return c.facets().get("iface"); // NVME5 | NVME4 | SATA (이름에 브랜드가 있어 규격을 보여 준다)
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

	/** 검색어: 칩셋 → "RTX 5070 Ti", 제조사 → "MSI RTX 5070 Ti", 모델 → "MSI RTX 5070 Ti Gaming Trio" */
	private static Links links(ChipsetDef chipset, String danawaPcode, MakerDef maker, String series) {
		String base = chipset.category() == Category.RAM ? ramQuery(chipset) : chipset.displayName();
		String q = (maker == null ? "" : maker.displayName() + " ") + base + (series == null ? "" : " " + series);
		// 제조사·모델 링크는 칩셋 이름을 따옴표로 묶는다. 안 묶으면 eBay가 글이 적을 때 일부 단어만 맞는 글로 채워서
		// GIGABYTE를 눌렀는데 MSI·PNY·5060 Ti·라이저 케이블이 싼 순서 맨 위에 나왔다(11/23, 74개 중 57개가 다른 글)
		String ebayQ = maker == null && series == null ? chipset.ebayQuery()
				: (maker == null ? "" : maker.displayName() + " ") + "\"" + base + "\"" + (series == null ? "" : " " + series);
		return Links.of(ebayQ + ebayExclude(chipset), chipset.category().ebayCategoryId, q, danawaPcode);
	}

	/** " -7600X" 처럼 eBay 검색어 뒤에 붙일 빼기 단어(제조사·모델 링크도 같은 칩셋 이름이라 똑같이 섞인다) */
	static String ebayExclude(ChipsetDef chipset) {
		StringBuilder sb = new StringBuilder();
		chipset.ebayExclude().forEach(w -> sb.append(" -").append(w));
		return sb.toString();
	}

	/** "DDR5 32GB (2×16GB)" → "DDR5 32GB 16Gx2" (다나와 표기에 가깝게) */
	private static String ramQuery(ChipsetDef c) {
		return c.displayName().replaceAll("\\(2×(\\d+)GB\\)", "$1Gx2");
	}
}
