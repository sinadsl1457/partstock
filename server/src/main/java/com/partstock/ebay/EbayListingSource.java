package com.partstock.ebay;

import com.partstock.catalog.ChipsetDef;
import com.partstock.collect.ListingSource;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.nio.charset.StandardCharsets;
import java.time.Clock;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.web.client.RestClient;

/**
 * eBay Browse API(item_summary/search)로 미국 eBay의 새 상품·즉시 구매 글을 받는다.
 * 응답 모양은 eBay 공개 문서 기준. 키를 받으면 실제 응답으로 확인한다(src/test/resources/ebay).
 */
@Component
public class EbayListingSource implements ListingSource {

	static final int PAGE_SIZE = 200;
	/** 새 상품(1000), 즉시 구매, 미국 판매자. 경매·중고·해외 배송 글은 가격 성격이 달라 뺀다. */
	static final String FILTER = "buyingOptions:{FIXED_PRICE},conditionIds:{1000},itemLocationCountry:US";

	private final RestClient http;
	private final String clientId;
	private final String clientSecret;
	private final int maxPages;
	private final Clock clock;

	private String token;
	private Instant tokenExpiresAt = Instant.EPOCH;

	public EbayListingSource(RestClient.Builder builder, Clock clock,
			@Value("${ebay.base-url}") String baseUrl,
			@Value("${ebay.client-id}") String clientId,
			@Value("${ebay.client-secret}") String clientSecret,
			@Value("${ebay.max-pages}") int maxPages) {
		this.http = builder.baseUrl(baseUrl).build();
		this.clock = clock;
		this.clientId = clientId;
		this.clientSecret = clientSecret;
		this.maxPages = maxPages;
	}

	@Override
	public List<Listing> search(ChipsetDef chipset) {
		List<Listing> out = new ArrayList<>();
		for (int page = 0; page < maxPages; page++) {
			int offset = page * PAGE_SIZE;
			SearchResponse res = http.get()
					.uri(u -> u.path("/buy/browse/v1/item_summary/search")
							.queryParam("q", chipset.ebayQuery())
							.queryParam("category_ids", chipset.category().ebayCategoryId)
							// 조건 값의 중괄호를 주소 빈칸 표시로 읽지 않게 변수로 넘긴다
							.queryParam("filter", "{filter}")
							.queryParam("limit", PAGE_SIZE)
							.queryParam("offset", offset)
							.build(Map.of("filter", FILTER)))
					.header("Authorization", "Bearer " + token())
					.header("X-EBAY-C-MARKETPLACE-ID", "EBAY_US")
					.retrieve()
					.body(SearchResponse.class);
			if (res == null || res.itemSummaries() == null) {
				break;
			}
			for (ItemSummary item : res.itemSummaries()) {
				if (item.title() != null && item.price() != null && item.price().value() != null) {
					out.add(new Listing(item.title(), toCents(item.price().value()), item.price().currency()));
				}
			}
			if (res.next() == null || offset + PAGE_SIZE >= res.total()) {
				break;
			}
		}
		return out;
	}

	/** "799.99" → 79999 */
	static long toCents(String value) {
		return new BigDecimal(value).setScale(2, RoundingMode.HALF_UP).movePointRight(2).longValueExact();
	}

	/** 앱 토큰(client credentials). 약 2시간 유효, 만료 5분 전에 새로 받는다. */
	private synchronized String token() {
		Instant now = clock.instant();
		if (token != null && now.isBefore(tokenExpiresAt.minusSeconds(300))) {
			return token;
		}
		if (clientId.isBlank() || clientSecret.isBlank()) {
			throw new IllegalStateException("eBay 키가 없습니다: application-local.properties에 ebay.client-id/secret");
		}
		var form = new LinkedMultiValueMap<String, String>();
		form.add("grant_type", "client_credentials");
		form.add("scope", "https://api.ebay.com/oauth/api_scope");
		String basic = Base64.getEncoder()
				.encodeToString((clientId + ":" + clientSecret).getBytes(StandardCharsets.UTF_8));
		TokenResponse res = http.post()
				.uri("/identity/v1/oauth2/token")
				.header("Authorization", "Basic " + basic)
				.contentType(MediaType.APPLICATION_FORM_URLENCODED)
				.body(form)
				.retrieve()
				.body(TokenResponse.class);
		if (res == null || res.access_token() == null) {
			throw new IllegalStateException("eBay 토큰 응답이 비었습니다");
		}
		token = res.access_token();
		tokenExpiresAt = now.plusSeconds(res.expires_in());
		return token;
	}

	record TokenResponse(String access_token, long expires_in) {}

	record SearchResponse(int total, String next, List<ItemSummary> itemSummaries) {}

	record ItemSummary(String title, Price price) {}

	record Price(String value, String currency) {}
}
