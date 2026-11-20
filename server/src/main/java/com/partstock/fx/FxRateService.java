package com.partstock.fx;

import java.math.BigDecimal;
import java.time.Clock;
import java.time.LocalDate;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;

/**
 * 원/달러 기준 환율을 받아 fx_rate에 쌓는다. 매번 최근 일주일치를 다시 받아 덮어써서,
 * 하루 수집이 빠져도 다음 날 저절로 채워진다.
 */
@Service
public class FxRateService {

	private static final Logger log = LoggerFactory.getLogger(FxRateService.class);
	static final int LOOKBACK_DAYS = 7;

	private final RestClient http;
	private final JdbcClient jdbc;
	private final Clock clock;

	public FxRateService(RestClient.Builder builder, JdbcClient jdbc, Clock clock,
			@Value("${fx.base-url}") String baseUrl) {
		this.http = builder.baseUrl(baseUrl).build();
		this.jdbc = jdbc;
		this.clock = clock;
	}

	/** 저장한 날 수. 실패하면 0을 돌려주고 시세 수집은 계속한다(환율은 화면 표시용). */
	public int collectRecent() {
		LocalDate today = LocalDate.now(clock);
		try {
			RangeResponse res = http.get()
					.uri("/v1/{from}..{to}?base=USD&symbols=KRW", today.minusDays(LOOKBACK_DAYS), today)
					.retrieve()
					.body(RangeResponse.class);
			if (res == null || res.rates() == null) {
				return 0;
			}
			res.rates().forEach((day, rates) -> {
				BigDecimal krw = rates.get("KRW");
				if (krw != null) {
					upsert(day, krw);
				}
			});
			return res.rates().size();
		} catch (RuntimeException e) {
			log.warn("환율 수집 실패: {}", e.toString());
			return 0;
		}
	}

	void upsert(LocalDate day, BigDecimal usdKrw) {
		jdbc.sql("""
				insert into fx_rate (day, usd_krw) values (:day, :rate)
				on conflict (day) do update set usd_krw = excluded.usd_krw
				""")
				.param("day", day)
				.param("rate", usdKrw)
				.update();
	}

	record RangeResponse(Map<LocalDate, Map<String, BigDecimal>> rates) {}
}
