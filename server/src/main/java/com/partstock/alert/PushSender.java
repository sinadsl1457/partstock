package com.partstock.alert;

import java.util.Map;

/** 푸시 보내기. 실제는 FCM, 키가 없거나 테스트면 가짜로 바꿔 끼운다. */
public interface PushSender {

	Result send(String token, String title, String body, Map<String, String> data);

	enum Result {
		SENT,
		/** 앱을 지웠거나 토큰이 바뀜 → 기기를 지운다 */
		UNREGISTERED,
		/** 잠깐 실패(네트워크·FCM 오류) → 다음 시각에 다시 */
		FAILED
	}
}
