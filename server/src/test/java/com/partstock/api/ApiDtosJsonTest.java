package com.partstock.api;

import static org.assertj.core.api.Assertions.assertThat;

import com.partstock.api.ApiDtos.Price;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.json.JsonTest;
import tools.jackson.databind.json.JsonMapper;

/** 옛 앱(0.1.0, Play 심사본)은 p25Cents를 대표가로 읽는다 → 대표가가 p25가 아니어도 같은 값을 줘야 한다 */
@JsonTest
class ApiDtosJsonTest {

	@Autowired
	JsonMapper json;

	@Test
	void 옛_앱이_읽는_p25Cents에도_대표가를_준다() {
		// 9700X 11/23 23시: 대표가(하위 10%) $264.10, 진짜 하위 25%는 $288.46
		String out = json.writeValueAsString(new Price(26_410, 10, 32_668, 41_168, 43));

		assertThat(out).contains("\"priceCents\":26410").contains("\"p25Cents\":26410").contains("\"pricePct\":10");
	}
}
