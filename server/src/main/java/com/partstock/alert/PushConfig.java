package com.partstock.alert;

import java.io.IOException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestClient;

/** 키 파일이 있으면 FCM, 없으면 보내지 않고 기록만(로컬·테스트에서 서버가 키 없이도 뜨게). */
@Configuration(proxyBeanMethods = false)
public class PushConfig {

	private static final Logger log = LoggerFactory.getLogger(PushConfig.class);

	@Bean
	PushSender pushSender(RestClient.Builder builder, @Value("${fcm.credentials-file}") String file) throws IOException {
		if (file == null || file.isBlank()) {
			log.warn("FCM 키 파일이 없어 알림을 보내지 않고 기록만 남깁니다(fcm.credentials-file)");
			return (token, title, body, data) -> {
				// 보낸 척하면 알림이 꺼져 버리므로 실패로: 키를 넣으면 다음 시각에 보내진다
				log.info("[알림 보내지 않음] {} / {}", title, body);
				return PushSender.Result.FAILED;
			};
		}
		return FcmPushSender.fromFile(builder, file);
	}
}
