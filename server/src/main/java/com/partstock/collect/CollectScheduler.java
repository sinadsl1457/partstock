package com.partstock.collect;

import com.partstock.alert.AlertService;
import com.partstock.fx.FxRateService;
import java.time.Clock;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.event.EventListener;
import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;

/**
 * 매시간 환율 → 시세 수집 → 목표가 알림. 시각은 partstock.collect.cron(UTC), "-"면 꺼짐(테스트).
 * 켜질 때 이번 시각 수집이 아직 없으면 바로 한 번 돈다(배포·재시작으로 한 시간이 비지 않게).
 */
@Configuration(proxyBeanMethods = false)
@EnableScheduling
@EnableAsync
public class CollectScheduler {

	private static final Logger log = LoggerFactory.getLogger(CollectScheduler.class);

	private final CollectService collect;
	private final FxRateService fx;
	private final AlertService alerts;
	private final CollectionRunStore runs;
	private final Clock clock;
	private final boolean onStart;

	public CollectScheduler(CollectService collect, FxRateService fx, AlertService alerts, CollectionRunStore runs,
			Clock clock,
			@Value("${partstock.collect.on-start:false}") boolean onStart) {
		this.collect = collect;
		this.fx = fx;
		this.alerts = alerts;
		this.runs = runs;
		this.clock = clock;
		this.onStart = onStart;
	}

	@Scheduled(cron = "${partstock.collect.cron}", zone = "UTC")
	void hourly() {
		fx.collectRecent();
		collect.collectNow();
		// 방금 받은 시세로 목표가 알림 확인
		alerts.checkAndSend();
	}

	/** 다른 스레드에서: 수집이 몇 분 걸려도 서버 시작을 막지 않게. */
	@Async
	@EventListener(ApplicationReadyEvent.class)
	void catchUp() {
		Instant hour = clock.instant().truncatedTo(ChronoUnit.HOURS);
		if (!onStart || runs.hasCompletedRunSince(hour)) {
			return;
		}
		log.info("이번 시각({}) 수집 기록이 없어 시작하자마자 수집", hour);
		hourly();
	}
}
