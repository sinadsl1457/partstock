package com.partstock.catalog;

/** 시세판 탭. eBay 카테고리 번호는 키를 받은 뒤 실제 응답으로 확인한다. */
public enum Category {
	GPU("27386"),
	RAM("170083");

	/** eBay 카테고리: Graphics/Video Cards, Memory (RAM) */
	public final String ebayCategoryId;

	Category(String ebayCategoryId) {
		this.ebayCategoryId = ebayCategoryId;
	}
}
