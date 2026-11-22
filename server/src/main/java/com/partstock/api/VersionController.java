package com.partstock.api;

import java.util.Map;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 지금 돌고 있는 서버가 어느 커밋인지. 자동 배포(GitHub Actions)가 새 버전으로 바뀌었는지 확인할 때 부른다.
 * 값은 이미지를 만들 때 넣은 APP_VERSION(커밋 번호). 로컬은 dev.
 */
@RestController
public class VersionController {

	private final String version;

	public VersionController(@Value("${app.version:dev}") String version) {
		this.version = version;
	}

	@GetMapping("/api/version")
	public Map<String, String> version() {
		return Map.of("version", version);
	}
}
