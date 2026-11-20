package com.partstock.collect;

import com.partstock.fx.FxRateService;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;

/** 하루 한 번 환율 → 시세 수집. 시각은 partstock.collect.cron(UTC), "-"면 꺼짐(테스트). */
@Configuration(proxyBeanMethods = false)
@EnableScheduling
public class CollectScheduler {

	private final CollectService collect;
	private final FxRateService fx;

	public CollectScheduler(CollectService collect, FxRateService fx) {
		this.collect = collect;
		this.fx = fx;
	}

	@Scheduled(cron = "${partstock.collect.cron}", zone = "UTC")
	void daily() {
		fx.collectRecent();
		collect.collectToday();
	}
}
