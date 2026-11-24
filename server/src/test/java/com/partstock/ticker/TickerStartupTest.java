package com.partstock.ticker;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.partstock.TestcontainersConfiguration;
import java.time.Duration;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.annotation.Import;
import org.springframework.jdbc.core.simple.JdbcClient;
import org.springframework.test.web.servlet.MockMvc;

/**
 * 새 칩셋을 코드에 넣고 배포하면 다음 수집 전에도 그 종목 화면이 열려야 한다.
 * (11/22: 종목 표는 수집할 때만 맞춰서, 배포 직후 40 시리즈·램 1개짜리가 다음 정각까지 404였다)
 */
@SpringBootTest(properties = "partstock.collect.cron=-")
@AutoConfigureMockMvc
@Import(TestcontainersConfiguration.class)
class TickerStartupTest {

	@Autowired MockMvc mvc;
	@Autowired JdbcClient jdbc;
	@Autowired ConfigurableApplicationContext context;

	@Test
	void 서버가_켜지면_코드의_칩셋이_종목_표에_생긴다() throws Exception {
		jdbc.sql("delete from price_alert").update();
		jdbc.sql("delete from device").update();
		jdbc.sql("delete from daily_price").update();
		jdbc.sql("delete from price_snapshot").update();
		jdbc.sql("delete from market_check").update();
		jdbc.sql("delete from ticker").update();

		context.publishEvent(new ApplicationReadyEvent(new SpringApplication(), new String[0], context, Duration.ZERO));

		mvc.perform(get("/api/ticker").param("key", "rtx-4090"))
				.andExpect(status().isOk())
				.andExpect(jsonPath("$.ticker.name").value("RTX 4090"))
				.andExpect(jsonPath("$.price").doesNotExist());
	}
}
