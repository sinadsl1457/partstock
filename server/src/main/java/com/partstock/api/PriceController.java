package com.partstock.api;

import com.partstock.api.ApiDtos.Board;
import com.partstock.api.ApiDtos.Chart;
import com.partstock.api.ApiDtos.Movers;
import com.partstock.api.ApiDtos.TickerDetail;
import com.partstock.catalog.Category;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

/**
 * GET /api/board?category=GPU|RAM                  시세판(칩셋 목록, 24시간 변동, 7일 추이)
 * GET /api/movers                                 급등·급락 TOP 5(4개 분류, 판매 글 20개 이상)
 * GET /api/ticker?key=rtx-5070-ti                  종목 정보와 제조사·모델 목록(키에 /가 들어가서 파라미터)
 * GET /api/chart?key=rtx-5070-ti&range=1w          차트 봉(1d|1w|1m|3m|1y|all)
 */
@RestController
@RequestMapping("/api")
public class PriceController {

	private final PriceService service;

	public PriceController(PriceService service) {
		this.service = service;
	}

	@GetMapping("/board")
	public Board board(@RequestParam(defaultValue = "GPU") String category) {
		try {
			return service.board(Category.valueOf(category.toUpperCase()));
		} catch (IllegalArgumentException e) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "category는 GPU|RAM");
		}
	}

	@GetMapping("/movers")
	public Movers movers() {
		return service.movers();
	}

	@GetMapping("/ticker")
	public TickerDetail ticker(@RequestParam String key) {
		return service.ticker(key);
	}

	@GetMapping("/chart")
	public Chart chart(@RequestParam String key, @RequestParam(defaultValue = "1w") String range) {
		return service.chart(key, range);
	}
}
