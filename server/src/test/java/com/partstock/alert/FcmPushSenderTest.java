package com.partstock.alert;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.content;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.header;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.jsonPath;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.method;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.requestTo;
import static org.springframework.test.web.client.response.MockRestResponseCreators.withStatus;
import static org.springframework.test.web.client.response.MockRestResponseCreators.withSuccess;

import java.util.Map;
import org.junit.jupiter.api.Test;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.test.web.client.MockRestServiceServer;
import org.springframework.web.client.RestClient;

/** FCM HTTP v1 요청 모양과 응답 해석. 요청 모양은 Firebase 문서(messages:send) 기준. */
class FcmPushSenderTest {

	final RestClient.Builder builder = RestClient.builder();
	final MockRestServiceServer server = MockRestServiceServer.bindTo(builder).build();
	final FcmPushSender sender = new FcmPushSender(builder, () -> "access-token", "partstock-prices");

	@Test
	void 프로젝트_주소로_토큰과_알림을_보낸다() {
		server.expect(requestTo("https://fcm.googleapis.com/v1/projects/partstock-prices/messages:send"))
				.andExpect(method(HttpMethod.POST))
				.andExpect(header("Authorization", "Bearer access-token"))
				.andExpect(content().contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
				.andExpect(jsonPath("$.message.token").value("phone-a"))
				.andExpect(jsonPath("$.message.notification.title").value("제목"))
				.andExpect(jsonPath("$.message.notification.body").value("본문"))
				.andExpect(jsonPath("$.message.data.tickerKey").value("rtx-5070-ti"))
				.andExpect(jsonPath("$.message.android.priority").value("HIGH"))
				.andRespond(withSuccess("{\"name\":\"projects/partstock-prices/messages/1\"}", MediaType.APPLICATION_JSON));

		assertThat(sender.send("phone-a", "제목", "본문", Map.of("tickerKey", "rtx-5070-ti")))
				.isEqualTo(PushSender.Result.SENT);
		server.verify();
	}

	@Test
	void 없는_토큰은_UNREGISTERED() {
		server.expect(requestTo("https://fcm.googleapis.com/v1/projects/partstock-prices/messages:send"))
				.andRespond(withStatus(HttpStatus.NOT_FOUND).contentType(MediaType.APPLICATION_JSON)
						.body("{\"error\":{\"status\":\"NOT_FOUND\",\"details\":[{\"errorCode\":\"UNREGISTERED\"}]}}"));

		assertThat(sender.send("gone", "t", "b", Map.of())).isEqualTo(PushSender.Result.UNREGISTERED);
	}

	@Test
	void 서버_오류는_다음에_다시() {
		server.expect(requestTo("https://fcm.googleapis.com/v1/projects/partstock-prices/messages:send"))
				.andRespond(withStatus(HttpStatus.SERVICE_UNAVAILABLE));

		assertThat(sender.send("phone-a", "t", "b", Map.of())).isEqualTo(PushSender.Result.FAILED);
	}
}
