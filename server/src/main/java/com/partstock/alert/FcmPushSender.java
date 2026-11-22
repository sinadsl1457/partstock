package com.partstock.alert;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.auth.oauth2.ServiceAccountCredentials;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.MediaType;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestClientException;

/**
 * FCM HTTP v1로 한 기기에 보낸다. 서비스 계정 키로 접근 토큰을 받아(1시간짜리, 라이브러리가 알아서 갱신) 붙인다.
 * https://firebase.google.com/docs/cloud-messaging/send-message (POST /v1/projects/{id}/messages:send)
 */
public class FcmPushSender implements PushSender {

	private static final Logger log = LoggerFactory.getLogger(FcmPushSender.class);
	static final String SCOPE = "https://www.googleapis.com/auth/firebase.messaging";

	private final RestClient http;
	private final TokenSource tokens;
	private final String projectId;

	public FcmPushSender(RestClient.Builder builder, TokenSource tokens, String projectId) {
		this.http = builder.baseUrl("https://fcm.googleapis.com").build();
		this.tokens = tokens;
		this.projectId = projectId;
	}

	/** 키 파일에서 만든다. 프로젝트 id는 키 안에 들어 있다. */
	public static FcmPushSender fromFile(RestClient.Builder builder, String path) throws IOException {
		try (InputStream in = new FileInputStream(path)) {
			ServiceAccountCredentials creds = (ServiceAccountCredentials) GoogleCredentials.fromStream(in);
			GoogleCredentials scoped = creds.createScoped(List.of(SCOPE));
			TokenSource source = () -> {
				scoped.refreshIfExpired();
				return scoped.getAccessToken().getTokenValue();
			};
			return new FcmPushSender(builder, source, creds.getProjectId());
		}
	}

	@Override
	public Result send(String token, String title, String body, Map<String, String> data) {
		Map<String, Object> message = Map.of("message", Map.of(
				"token", token,
				"notification", Map.of("title", title, "body", body),
				"data", data,
				"android", Map.of("priority", "HIGH")));
		try {
			http.post()
					.uri("/v1/projects/{id}/messages:send", projectId)
					.header("Authorization", "Bearer " + tokens.accessToken())
					.contentType(MediaType.APPLICATION_JSON)
					.body(message)
					.retrieve()
					.toBodilessEntity();
			return Result.SENT;
		} catch (org.springframework.web.client.HttpClientErrorException e) {
			// 404 UNREGISTERED: 앱을 지웠거나 토큰이 바뀜. 400 INVALID_ARGUMENT도 토큰 모양이 틀린 경우가 대부분
			HttpStatusCode status = e.getStatusCode();
			if (status.value() == 404 || e.getResponseBodyAsString().contains("UNREGISTERED")) {
				return Result.UNREGISTERED;
			}
			log.warn("FCM 거절 {}: {}", status, e.getResponseBodyAsString());
			return Result.FAILED;
		} catch (RestClientException | IOException e) {
			log.warn("FCM 보내기 실패: {}", e.toString());
			return Result.FAILED;
		}
	}

	/** 접근 토큰. 테스트에서 가짜로 바꿔 끼운다. */
	@FunctionalInterface
	public interface TokenSource {
		String accessToken() throws IOException;
	}
}
