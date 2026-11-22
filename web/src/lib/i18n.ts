// 화면 글자(한국어·영어). 언어는 주소 맨 앞(/ko, /en)으로 정한다.
export const locales = ["ko", "en"] as const;
export type Locale = (typeof locales)[number];

export function isLocale(s: string): s is Locale {
  return (locales as readonly string[]).includes(s);
}

const ko = {
  tagline: "그래픽카드·램 시세판 · eBay 새 상품 기준",
  gpu: "그래픽카드",
  ram: "램",
  colName: "종목",
  colPrice: "대표가 (하위 25%)",
  colMedian: "중앙값",
  colChange: "전일 대비",
  colTrend: "30일 추이",
  colCount: "판매 글",
  colJump: "바로가기",
  jumpDefault: "바로가기",
  ebay: "eBay",
  danawa: "다나와",
  viewOnEbay: "eBay에서 보기",
  viewOnDanawa: "다나와에서 보기",
  updated: (day: string) => `기준일 ${day} · 매일 낮 12시 갱신`,
  fx: (rate: string, day: string) => `1달러 = ${rate}원 (${day} 고시)`,
  boardNote:
    "대표가는 미국 eBay 새 상품·즉시 구매 글 가격의 하위 25%입니다. 시세보다 비싸게 걸어 둔 글의 영향을 덜 받습니다. 원화는 기준 환율로 바꾼 값이며 배송비·관세는 들어 있지 않습니다.",
  noData: "아직 수집 전입니다. 매일 낮 12시에 시세가 들어옵니다.",
  tooFew: "글 부족",
  listings: (n: number) => `판매 글 ${n}개`,
  accumulating: (n: number) => `차트는 하루에 한 점씩 쌓입니다. 지금 ${n}일치 (수집 시작 2026-11-22).`,
  chart: "시세 차트",
  periods: { day: "일", week: "주", month: "월", year: "년" },
  periodNote: {
    day: "최근 30일 하루 대표가. 연한 선은 중앙값.",
    week: "주봉: 봉 하나 = 그 주 하루 대표가의 처음·최고·최저·마지막.",
    month: "월봉: 봉 하나 = 그 달 하루 대표가의 처음·최고·최저·마지막.",
    year: "연봉: 봉 하나 = 그 해 하루 대표가의 처음·최고·최저·마지막.",
  },
  upDown: "상승 빨강, 하락 파랑",
  makers: "제조사별",
  models: "모델별",
  modelsNote: "판매 글 5개 이상일 때만 시세 표시",
  median: "중앙값",
  back: "시세판",
  notFound: "없는 종목입니다.",
  loading: "불러오는 중…",
  source: "가격 출처: eBay(미국). 환율: 유럽중앙은행 기준 환율.",
  vendor: { NVIDIA: "NVIDIA", AMD: "AMD", DESKTOP: "데스크톱용" } as Record<string, string>,
};

export type Dict = typeof ko;

const en: Dict = {
  tagline: "GPU & RAM price board · new listings on eBay",
  gpu: "Graphics cards",
  ram: "Memory",
  colName: "Item",
  colPrice: "Price (25th pct.)",
  colMedian: "Median",
  colChange: "1D change",
  colTrend: "30-day trend",
  colCount: "Listings",
  colJump: "Shop",
  jumpDefault: "Open in",
  ebay: "eBay",
  danawa: "Danawa",
  viewOnEbay: "View on eBay",
  viewOnDanawa: "View on Danawa",
  updated: (day: string) => `As of ${day} · updated daily 03:00 UTC`,
  fx: () => "",
  boardNote:
    "Price is the 25th percentile of new, Buy It Now listings on eBay US, so overpriced listings that never sell matter less. Shipping and tax not included.",
  noData: "No data yet. Prices arrive once a day.",
  tooFew: "Too few",
  listings: (n: number) => `${n} listings`,
  accumulating: (n: number) => `One point per day. ${n} day(s) so far (collecting since 2026-11-22).`,
  chart: "Price chart",
  periods: { day: "1D", week: "1W", month: "1M", year: "1Y" },
  periodNote: {
    day: "Daily price over the last 30 days. Faint line: median.",
    week: "Weekly candles: first, high, low and last daily price of each week.",
    month: "Monthly candles: first, high, low and last daily price of each month.",
    year: "Yearly candles: first, high, low and last daily price of each year.",
  },
  upDown: "Green up, red down",
  makers: "By brand",
  models: "By model",
  modelsNote: "Shown only with 5+ listings that day",
  median: "Median",
  back: "Board",
  notFound: "No such item.",
  loading: "Loading…",
  source: "Prices: eBay US.",
  vendor: { NVIDIA: "NVIDIA", AMD: "AMD", DESKTOP: "Desktop" },
};

export function dict(locale: Locale): Dict {
  return locale === "ko" ? ko : en;
}

/** 상승·하락 색: 한국은 빨강 상승·파랑 하락, 영어권은 초록 상승·빨강 하락 */
export function upDownColors(locale: Locale) {
  return locale === "ko" ? { up: "#dc2626", down: "#2563eb" } : { up: "#16a34a", down: "#dc2626" };
}
