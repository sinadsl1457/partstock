package com.partstock.catalog;

import java.util.Arrays;
import java.util.List;
import java.util.Locale;

/**
 * 판매 글 제목을 비교하기 쉬운 토큰 목록으로 바꾼다.
 * "GeForce RTX5070Ti 16GB-GDDR7" → [GEFORCE, RTX, 5070, TI, 16, GB, GDDR, 7]
 * 판매자마다 붙여 쓰기·대소문자·기호가 제각각이라, 글자↔숫자 경계와 기호를 모두 띄어 쓴 뒤 비교한다.
 */
public record Title(List<String> tokens) {

	public static Title of(String raw) {
		String s = raw.toUpperCase(Locale.ROOT)
				.replace("G.SKILL", "GSKILL")
				.replace("T-FORCE", "TFORCE")
				// "16GBx2"가 글자↔숫자 경계로만 나누면 GBX 한 토큰이 된다
				.replace("GBX", "GB X")
				.replaceAll("[^A-Z0-9]+", " ")
				.replaceAll("(?<=[A-Z])(?=[0-9])|(?<=[0-9])(?=[A-Z])", " ")
				.trim();
		return new Title(s.isEmpty() ? List.of() : Arrays.asList(s.split(" +")));
	}

	/** 토큰들이 이 순서대로 붙어 나오는 첫 위치. 없으면 -1. "ROG STRIX"처럼 여러 단어 이름을 찾을 때 쓴다. */
	public int indexOf(List<String> seq) {
		outer:
		for (int i = 0; i + seq.size() <= tokens.size(); i++) {
			for (int j = 0; j < seq.size(); j++) {
				if (!tokens.get(i + j).equals(seq.get(j))) {
					continue outer;
				}
			}
			return i;
		}
		return -1;
	}

	public boolean contains(List<String> seq) {
		return indexOf(seq) >= 0;
	}

	/** 공백으로 나눈 문구를 정규화해서 포함 여부를 본다. contains("ROG STRIX") */
	public boolean contains(String phrase) {
		return contains(Title.of(phrase).tokens());
	}

	public String tokenAt(int i) {
		return i >= 0 && i < tokens.size() ? tokens.get(i) : "";
	}
}
