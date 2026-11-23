// 가격 글자 만들기. API는 USD 센트 정수만 주고, 원화는 여기서 환율을 곱한다.
import type { Fx, Price } from "./api";
import type { Locale } from "./i18n";

export function usd(cents: number): string {
  const dollars = cents / 100;
  return "$" + dollars.toLocaleString("en-US", { maximumFractionDigits: dollars >= 100 ? 0 : 2 });
}

/** 1,858,502원 → "185.9만원" */
export function krw(cents: number, fx: Fx): string {
  const won = (cents / 100) * fx.usdKrw;
  return (won / 10000).toLocaleString("ko-KR", { minimumFractionDigits: 1, maximumFractionDigits: 1 }) + "만원";
}

/** 큰 글자(대표가)와 작은 글자. 한국어는 원화 크게 + 달러 작게, 영어는 달러만. */
export function mainPrice(p: Price, fx: Fx | null, locale: Locale): { big: string; small: string | null } {
  // 대표가(priceCents). 서버가 먼저 배포되기 전 잠깐은 옛 응답이라 p25Cents로 대신한다
  const cents = p.priceCents ?? p.p25Cents;
  if (locale === "ko" && fx) return { big: krw(cents, fx), small: usd(cents) };
  return { big: usd(cents), small: null };
}

export function pct(v: number): string {
  return (v > 0 ? "+" : "") + v.toFixed(2) + "%";
}

export function rate(fx: Fx): string {
  return fx.usdKrw.toLocaleString("ko-KR", { minimumFractionDigits: 2, maximumFractionDigits: 2 });
}

/** 업데이트 시각: 한국어는 한국 시간, 영어는 UTC */
export function time(iso: string, locale: Locale): string {
  const d = new Date(iso);
  return locale === "ko"
    ? d.toLocaleString("ko-KR", { timeZone: "Asia/Seoul", month: "numeric", day: "numeric", hour: "numeric", minute: "2-digit" })
    : d.toLocaleString("en-US", { timeZone: "UTC", month: "short", day: "numeric", hour: "2-digit", minute: "2-digit", hour12: false }) + " UTC";
}
