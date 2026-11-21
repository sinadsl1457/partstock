package com.partstock.collect;

import com.partstock.fx.FxRateService;
import java.time.Clock;
import java.time.LocalDate;
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
 * 하루 한 번 환율 → 시세 수집. 시각은 partstock.collect.cron(UTC), "-"면 꺼짐(테스트).
 * 켜질 때 그날 수집이 아직 없으면 바로 한 번 돈다(배포·재시작한 날이 비지 않게).
 */
@Configuration(proxyBeanMethods = false)
@EnableScheduling
@EnableAsync
public class CollectScheduler {

	private static final Logger log = LoggerFactory.getLogger(CollectScheduler.class);

	private final CollectService collect;
	private final FxRateService fx;
	private final CollectionRunStore runs;
	private final Clock clock;
	private final boolean onStart;

	public CollectScheduler(CollectService collect, FxRateService fx, CollectionRunStore runs, Clock clock,
			@Value("${partstock.collect.on-start:false}") boolean onStart) {
		this.collect = collect;
		this.fx = fx;
		this.runs = runs;
		this.clock = clock;
		this.onStart = onStart;
	}

	@Scheduled(cron = "${partstock.collect.cron}", zone = "UTC")
	void daily() {
		fx.collectRecent();
		collect.collectToday();
	}

	/** 다른 스레드에서: 수집이 몇 분 걸려도 서버 시작을 막지 않게. */
	@Async
	@EventListener(ApplicationReadyEvent.class)
	void catchUp() {
		LocalDate today = LocalDate.now(clock);
		if (!onStart || runs.hasCompletedRun(today)) {
			return;
		}
		log.info("오늘({}) 수집 기록이 없어 시작하자마자 수집", today);
		daily();
	}
}
