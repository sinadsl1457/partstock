package com.partstock.collect;

import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;

/** 하루 한 번 수집. 시각은 partstock.collect.cron(UTC), "-"면 꺼짐(테스트). */
@Configuration(proxyBeanMethods = false)
@EnableScheduling
public class CollectScheduler {

	private final CollectService collect;

	public CollectScheduler(CollectService collect) {
		this.collect = collect;
	}

	@Scheduled(cron = "${partstock.collect.cron}", zone = "UTC")
	void daily() {
		collect.collectToday();
	}
}
