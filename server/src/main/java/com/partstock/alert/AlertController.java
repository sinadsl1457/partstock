package com.partstock.alert;

import com.partstock.alert.AlertService.Alert;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

/**
 * 기기 토큰(FCM)이 곧 사용자. 토큰은 주소에 남지 않게 X-Device-Token 머리글로 받는다.
 * POST   /api/devices              {token, platform: ANDROID|IOS, locale}
 * GET    /api/alerts               내 알림
 * POST   /api/alerts               {tickerKey, direction: BELOW|ABOVE, targetCents}
 * DELETE /api/alerts/{id}
 */
@RestController
@RequestMapping("/api")
public class AlertController {

	static final String TOKEN = "X-Device-Token";

	private final AlertService alerts;

	public AlertController(AlertService alerts) {
		this.alerts = alerts;
	}

	public record DeviceRequest(String token, String platform, String locale) {}

	public record AlertRequest(String tickerKey, String direction, long targetCents) {}

	@PostMapping("/devices")
	@ResponseStatus(HttpStatus.NO_CONTENT)
	public void register(@RequestBody DeviceRequest req) {
		alerts.registerDevice(req.token(), req.platform(), req.locale());
	}

	@GetMapping("/alerts")
	public List<Alert> list(@RequestHeader(value = TOKEN, required = false) String token) {
		return alerts.list(token);
	}

	@PostMapping("/alerts")
	@ResponseStatus(HttpStatus.CREATED)
	public Alert create(@RequestHeader(value = TOKEN, required = false) String token, @RequestBody AlertRequest req) {
		return alerts.create(token, req.tickerKey(), req.direction(), req.targetCents());
	}

	@DeleteMapping("/alerts/{id}")
	@ResponseStatus(HttpStatus.NO_CONTENT)
	public void delete(@RequestHeader(value = TOKEN, required = false) String token, @PathVariable long id) {
		alerts.delete(token, id);
	}
}
