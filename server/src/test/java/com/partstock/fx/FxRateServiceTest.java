package com.partstock.fx;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.requestTo;
import static org.springframework.test.web.client.response.MockRestResponseCreators.withServerError;
import static org.springframework.test.web.client.response.MockRestResponseCreators.withSuccess;

import com.partstock.TestcontainersConfiguration;
import java.math.BigDecimal;
import java.time.Clock;
import java.time.Instant;
import java.time.ZoneOffset;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.annotation.Import;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.MediaType;
import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.test.web.client.MockRestServiceServer;
import org.springframework.web.client.RestClient;

/** 응답 예시(fx/range.json)는 2026-11-20에 Frankfurter에서 실제로 받은 것. */
@SpringBootTest(properties = "partstock.collect.cron=-")
@Import(TestcontainersConfiguration.class)
class FxRateServiceTest {

	@Autowired JdbcClient jdbc;

	final Clock clock = Clock.fixed(Instant.parse("2026-11-20T03:00:00Z"), ZoneOffset.UTC);
	final RestClient.Builder builder = RestClient.builder();
	final MockRestServiceServer server = MockRestServiceServer.bindTo(builder).build();
	FxRateService fx;

	@BeforeEach
	void setUp() {
		jdbc.sql("delete from fx_rate").update();
		fx = new FxRateService(builder, jdbc, clock, "https://fx.test");
	}

	@Test
	void 최근_일주일_환율을_받아_날짜별로_저장한다() {
		server.expect(requestTo("https://fx.test/v1/2026-11-13..2026-11-20?base=USD&symbols=KRW"))
				.andRespond(withSuccess(new ClassPathResource("fx/range.json"), MediaType.APPLICATION_JSON));

		int saved = fx.collectRecent();

		assertThat(saved).isEqualTo(5); // 주말(14·15일)은 고시가 없다
		assertThat(rate("2026-11-19")).isEqualByComparingTo("1328.45");
		assertThat(rate("2026-11-13")).isEqualByComparingTo("1337.13");
	}

	@Test
	void 다시_받으면_덮어쓴다() {
		fx.upsert(java.time.LocalDate.parse("2026-11-19"), new BigDecimal("1000.00"));
		server.expect(requestTo("https://fx.test/v1/2026-11-13..2026-11-20?base=USD&symbols=KRW"))
				.andRespond(withSuccess(new ClassPathResource("fx/range.json"), MediaType.APPLICATION_JSON));

		fx.collectRecent();

		assertThat(rate("2026-11-19")).isEqualByComparingTo("1328.45");
	}

	@Test
	void 실패해도_예외를_던지지_않는다() {
		server.expect(requestTo("https://fx.test/v1/2026-11-13..2026-11-20?base=USD&symbols=KRW"))
				.andRespond(withServerError());

		assertThat(fx.collectRecent()).isZero();
	}

	BigDecimal rate(String day) {
		return jdbc.sql("select usd_krw from fx_rate where day = :d::date").param("d", day)
				.query(BigDecimal.class).single();
	}
}
