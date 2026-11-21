package com.partstock.catalog;

/** 시세판 탭. eBay 카테고리 번호는 실제 응답의 categoryName으로 확인함(2026-11-21). */
public enum Category {
	GPU("27386"),
	RAM("170083");

	/** eBay 카테고리: Graphics/Video Cards, Memory (RAM) */
	public final String ebayCategoryId;

	Category(String ebayCategoryId) {
		this.ebayCategoryId = ebayCategoryId;
	}
}
