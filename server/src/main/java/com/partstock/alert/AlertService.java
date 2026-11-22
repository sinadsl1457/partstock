package com.partstock.alert;

import com.partstock.alert.AlertStore.AlertRow;
import com.partstock.alert.AlertStore.DueRow;
import com.partstock.api.PriceQuery;
import com.partstock.catalog.Catalog;
import com.partstock.catalog.Category;
import com.partstock.catalog.ChipsetDef;
import com.partstock.catalog.MakerDef;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.time.Clock;
import java.time.OffsetDateTime;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

/** 목표가 알림: 기기 등록, 알림 걸기·보기·지우기, 매시간 수집 직후 조건에 닿은 알림 보내기. */
@Service
public class AlertService {

	private static final Logger log = LoggerFactory.getLogger(AlertService.class);

	private final AlertStore store;
	private final PriceQuery prices;
	private final PushSender push;
	private final Clock clock;
	private final int maxPerDevice;

	public AlertService(AlertStore store, PriceQuery prices, PushSender push, Clock clock,
			@Value("${partstock.alert.max-per-device}") int maxPerDevice) {
		this.store = store;
		this.prices = prices;
		this.push = push;
		this.clock = clock;
		this.maxPerDevice = maxPerDevice;
	}

	public void registerDevice(String token, String platform, String locale) {
		requireToken(token);
		String p = platform == null ? "" : platform.toUpperCase();
		if (!p.equals("ANDROID") && !p.equals("IOS")) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "platform은 ANDROID|IOS");
		}
		String l = locale != null && locale.toLowerCase().startsWith("ko") ? "ko" : "en";
		store.upsertDevice(token, p, l, clock.instant());
	}

	public List<Alert> list(String token) {
		requireDevice(token);
		return store.list(token).stream().map(this::toAlert).toList();
	}

	public Alert create(String token, String tickerKey, String direction, long targetCents) {
		requireDevice(token);
		if (!"BELOW".equals(direction) && !"ABOVE".equals(direction)) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "direction은 BELOW|ABOVE");
		}
		if (targetCents <= 0) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "목표가는 0보다 커야 합니다");
		}
		if (prices.ticker(tickerKey).isEmpty()) {
			throw new ResponseStatusException(HttpStatus.NOT_FOUND, "없는 종목: " + tickerKey);
		}
		if (store.countWaiting(token) >= maxPerDevice) {
			throw new ResponseStatusException(HttpStatus.CONFLICT, "대기 중 알림은 " + maxPerDevice + "개까지");
		}
		long id = store.insert(token, tickerKey, direction, targetCents, clock.instant());
		return store.find(id).map(this::toAlert).orElseThrow();
	}

	public void delete(String token, long id) {
		requireDevice(token);
		if (!store.delete(id, token)) {
			throw new ResponseStatusException(HttpStatus.NOT_FOUND, "없는 알림");
		}
	}

	/** 매시간 수집 직후. 보낸 것만 끄고, 잠깐 실패한 건 다음 시각에 다시. */
	public CheckResult checkAndSend() {
		Optional<PriceQuery.Latest> latest = prices.latest();
		if (latest.isEmpty()) {
			return new CheckResult(0, 0, 0, 0);
		}
		BigDecimal usdKrw = prices.fxOnOrBefore(latest.get().day()).map(PriceQuery.FxRow::usdKrw).orElse(null);
		int sent = 0, gone = 0, failed = 0;
		List<DueRow> due = store.due(latest.get().day());
		for (DueRow d : due) {
			Message m = message(d, usdKrw);
			switch (push.send(d.token(), m.title(), m.body(), Map.of("tickerKey", d.tickerKey(), "alertId",
					String.valueOf(d.id())))) {
				case SENT -> {
					store.markFired(d.id(), d.nowCents(), clock.instant());
					sent++;
				}
				case UNREGISTERED -> {
					// 앱을 지웠거나 토큰이 바뀜: 기기와 그 알림을 모두 지운다
					store.deleteDevice(d.token());
					gone++;
				}
				case FAILED -> failed++;
			}
		}
		if (!due.isEmpty()) {
			log.info("목표가 알림: 대상 {} / 보냄 {} / 기기 없음 {} / 실패 {}", due.size(), sent, gone, failed);
		}
		return new CheckResult(due.size(), sent, gone, failed);
	}

	public record CheckResult(int due, int sent, int unregistered, int failed) {}

	public record Alert(long id, String tickerKey, String tickerName, String direction, long targetCents,
			OffsetDateTime createdAt, OffsetDateTime firedAt, Long firedCents) {}

	record Message(String title, String body) {}

	/** 한국어는 원화(만원), 영어는 달러. 이름은 "RTX 5070 Ti · MSI Gaming Trio" */
	Message message(DueRow d, BigDecimal usdKrw) {
		String name = store.find(d.id()).map(this::fullName).orElse(d.tickerKey());
		boolean ko = "ko".equals(d.locale()) && usdKrw != null;
		String now = ko ? manwon(d.nowCents(), usdKrw) : dollars(d.nowCents());
		String target = ko ? manwon(d.targetCents(), usdKrw) : dollars(d.targetCents());
		if (ko) {
			String cond = "BELOW".equals(d.direction()) ? "이하" : "이상";
			return new Message(name + " 목표가 도달", "지금 " + now + " · 목표 " + target + " " + cond);
		}
		String cond = "BELOW".equals(d.direction()) ? "≤" : "≥";
		return new Message(name + " hit your target", "Now " + now + " · target " + cond + " " + target);
	}

	static String manwon(long cents, BigDecimal usdKrw) {
		double won = cents / 100.0 * usdKrw.doubleValue();
		return new DecimalFormat("#,##0.0").format(won / 10000) + "만원";
	}

	static String dollars(long cents) {
		return "$" + new DecimalFormat("#,##0").format(Math.round(cents / 100.0));
	}

	private Alert toAlert(AlertRow r) {
		return new Alert(r.id(), r.tickerKey(), fullName(r), r.direction(), r.targetCents(), r.createdAt(),
				r.firedAt(), r.firedCents());
	}

	private String fullName(AlertRow r) {
		Optional<ChipsetDef> chipset = Arrays.stream(Category.values())
				.flatMap(c -> Catalog.chipsets(c).stream())
				.filter(c -> c.key().equals(r.chipsetKey()))
				.findFirst();
		if (chipset.isEmpty()) {
			return r.displayName();
		}
		String maker = r.makerKey() == null ? null : Catalog.makers(chipset.get().category()).stream()
				.filter(m -> m.key().equals(r.makerKey())).map(MakerDef::displayName).findFirst().orElse(null);
		String series = "MODEL".equals(r.level()) ? r.displayName() : null;
		StringBuilder sb = new StringBuilder(chipset.get().displayName());
		if (maker != null) {
			sb.append(" · ").append(maker);
		}
		if (series != null) {
			sb.append(" ").append(series);
		}
		return sb.toString();
	}

	private static void requireToken(String token) {
		if (token == null || token.isBlank() || token.length() > 512) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "기기 토큰이 없습니다");
		}
	}

	private void requireDevice(String token) {
		requireToken(token);
		if (!store.deviceExists(token)) {
			throw new ResponseStatusException(HttpStatus.NOT_FOUND, "등록되지 않은 기기");
		}
	}
}
