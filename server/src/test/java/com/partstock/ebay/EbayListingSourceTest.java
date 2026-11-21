package com.partstock.ebay;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.header;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.method;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.queryParam;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.requestTo;
import static org.springframework.test.web.client.response.MockRestResponseCreators.withSuccess;

import com.partstock.catalog.Catalog;
import com.partstock.catalog.ChipsetDef;
import com.partstock.collect.ListingSource.Listing;
import java.time.Clock;
import java.time.Instant;
import java.time.ZoneOffset;
import org.junit.jupiter.api.Test;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.test.web.client.MockRestServiceServer;
import org.springframework.web.client.RestClient;

class EbayListingSourceTest {

	static final ChipsetDef RTX_5070_TI = Catalog.GPU_CHIPSETS.stream()
			.filter(c -> c.key().equals("rtx-5070-ti")).findFirst().orElseThrow();

	final Clock clock = Clock.fixed(Instant.parse("2026-11-20T03:00:00Z"), ZoneOffset.UTC);
	final RestClient.Builder builder = RestClient.builder();
	final MockRestServiceServer server = MockRestServiceServer.bindTo(builder).build();

	EbayListingSource source(String id, String secret) {
		return new EbayListingSource(builder, clock, "https://api.ebay.test", id, secret, 3);
	}

	@Test
	void 토큰을_받고_검색해서_제목과_센트_가격만_돌려준다() {
		server.expect(requestTo("https://api.ebay.test/identity/v1/oauth2/token"))
				.andExpect(method(HttpMethod.POST))
				.andExpect(header("Authorization", "Basic aWQ6c2VjcmV0")) // base64("id:secret")
				.andRespond(withSuccess("{\"access_token\":\"tok\",\"expires_in\":7200}", MediaType.APPLICATION_JSON));
		server.expect(requestTo(org.hamcrest.Matchers.startsWith("https://api.ebay.test/buy/browse/v1/item_summary/search")))
				.andExpect(queryParam("q", "RTX%205070%20Ti"))
				.andExpect(queryParam("category_ids", "27386"))
				.andExpect(queryParam("filter", org.hamcrest.Matchers.containsString("FIXED_PRICE")))
				.andExpect(header("Authorization", "Bearer tok"))
				.andExpect(header("X-EBAY-C-MARKETPLACE-ID", "EBAY_US"))
				.andRespond(withSuccess(new ClassPathResource("ebay/search-page1.json"), MediaType.APPLICATION_JSON));

		var listings = source("id", "secret").search(RTX_5070_TI);

		// 가격 없는 글은 빠지고, 다음 쪽이 없으니(실제 응답은 next 칸 자체가 없음) 한 번만 부른다
		assertThat(listings).containsExactly(
				new Listing("PNY NVIDIA GeForce RTX 5070 Ti OC Triple Fan Graphics Card 16GB GPU GDDR7 NEW", 135_000, "USD"),
				new Listing("MSI Gaming GeForce RTX 5070 Ti 16GB GDDR7 PCI Express 5.0 ATX Graphics Card RTX", 150_799, "USD"),
				new Listing("GIGABYTE AORUS GeForce RTX 5070 Ti Infinity 16GB GDDR7 GV-N507TAORUS IF-16GD", 199_999, "USD"));
		server.verify();
	}

	@Test
	void 키가_없으면_분명한_에러() {
		assertThatThrownBy(() -> source("", "").search(RTX_5070_TI))
				.hasMessageContaining("eBay 키가 없습니다");
	}

	@Test
	void 달러_문자열을_센트로() {
		assertThat(EbayListingSource.toCents("849.99")).isEqualTo(84_999);
		assertThat(EbayListingSource.toCents("799")).isEqualTo(79_900);
		assertThat(EbayListingSource.toCents("0.5")).isEqualTo(50);
	}
}
