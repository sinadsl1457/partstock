package com.partstock.api;

import com.partstock.api.ApiDtos.Board;
import com.partstock.api.ApiDtos.TickerDetail;
import com.partstock.catalog.Category;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

/**
 * GET /api/board?category=GPU|RAM          시세판(칩셋 목록)
 * GET /api/ticker?key=rtx-5070-ti&period=week  종목 상세(키에 /가 들어가서 경로 대신 파라미터)
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

	@GetMapping("/ticker")
	public TickerDetail ticker(@RequestParam String key, @RequestParam(defaultValue = "week") String period) {
		return service.ticker(key, period);
	}
}
