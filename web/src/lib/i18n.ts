// 화면 글자(한국어·영어). 언어는 주소 맨 앞(/ko, /en)으로 정한다.
export const locales = ["ko", "en"] as const;
export type Locale = (typeof locales)[number];

export function isLocale(s: string): s is Locale {
  return (locales as readonly string[]).includes(s);
}

const ko = {
  tagline: "VGA·RAM 시세 · eBay 새 상품 기준",
  gpu: "VGA",
  ram: "RAM",
  jumpDefault: "바로가기",
  ebay: "eBay",
  danawa: "다나와",
  viewOnEbay: "eBay에서 보기",
  viewOnDanawa: "다나와에서 보기",
  change24h: "24시간",
  price: "대표가",
  priceHint: "하위 25%",
  median: "중앙값",
  listings: (n: number) => `판매 글 ${n}개`,
  updatedAt: (time: string) => `${time} 기준 · 매시간 갱신`,
  fx: (rate: string, day: string) => `1달러 = ${rate}원 (${day} 고시)`,
  boardNote:
    "대표가 = 미국 eBay 새 상품·즉시 구매 글 가격의 하위 25%. 원화는 기준 환율로 바꾼 값이며 배송비·관세는 빠져 있습니다.",
  noData: "아직 수집 전입니다. 매시간 정각에 시세가 들어옵니다.",
  tooFew: "데이터 없음",
  filter: "필터",
  filterTitle: (c: string) => `${c} 필터`,
  filterReset: "초기화",
  filterApply: "{count}개 종목 보기",
  filterEmpty: "조건에 맞는 종목이 없어요",
  filterHintMulti: "여러 개 고를 수 있어요. 아무것도 안 고르면 전체",
  facet: { series: "시리즈", ddr: "세대", pack: "구성" } as Record<string, string>,
  pack: { "1": "1개", "2": "2개 묶음" } as Record<string, string>,
  ranges: { "1d": "1일", "1w": "1주", "1m": "1달", "3m": "3달", "1y": "1년", all: "전체" },
  bucket: { "1 hour": "1시간 봉", "4 hours": "4시간 봉", "1 day": "일봉", "7 days": "주봉" } as Record<string, string>,
  line: "선",
  candle: "봉",
  rangeChange: "기간 등락",
  high: "최고",
  low: "최저",
  collecting: (since: string, n: number) => `${since}부터 매시간 쌓는 중 · 지금 ${n}개`,
  tooFewPoints: "아직 점이 하나뿐입니다. 한 시간마다 하나씩 늘어납니다.",
  makers: "제조사별",
  models: "모델별",
  modelsNote: "판매 글 5개 이상일 때만 시세",
  notFound: "없는 종목입니다.",
  source: "가격: eBay(미국) · 환율: 유럽중앙은행 기준 환율 · 차트: TradingView Lightweight Charts",
  vendor: { NVIDIA: "NVIDIA", AMD: "AMD", DESKTOP: "데스크톱용" } as Record<string, string>,
};

export type Dict = typeof ko;

const en: Dict = {
  tagline: "GPU & RAM prices · new listings on eBay",
  gpu: "GPU",
  ram: "RAM",
  jumpDefault: "Open in",
  ebay: "eBay",
  danawa: "Danawa",
  viewOnEbay: "View on eBay",
  viewOnDanawa: "View on Danawa",
  change24h: "24h",
  price: "Price",
  priceHint: "25th pct.",
  median: "Median",
  listings: (n: number) => `${n} listings`,
  updatedAt: (time: string) => `As of ${time} · updated hourly`,
  fx: () => "",
  boardNote: "Price = 25th percentile of new, Buy It Now listings on eBay US. Shipping and tax not included.",
  noData: "No data yet. Prices arrive every hour.",
  tooFew: "No data",
  filter: "Filter",
  filterTitle: (c: string) => `${c} filter`,
  filterReset: "Reset",
  filterApply: "Show {count} items",
  filterEmpty: "No items match",
  filterHintMulti: "Pick any. None picked means all",
  facet: { series: "Series", ddr: "Generation", pack: "Pack" },
  pack: { "1": "Single", "2": "2-stick kit" },
  ranges: { "1d": "1D", "1w": "1W", "1m": "1M", "3m": "3M", "1y": "1Y", all: "All" },
  bucket: { "1 hour": "1h candles", "4 hours": "4h candles", "1 day": "Daily", "7 days": "Weekly" },
  line: "Line",
  candle: "Candles",
  rangeChange: "Change",
  high: "High",
  low: "Low",
  collecting: (since: string, n: number) => `Collecting hourly since ${since} · ${n} so far`,
  tooFewPoints: "Only one point so far. One more every hour.",
  makers: "By brand",
  models: "By model",
  modelsNote: "Shown with 5+ listings",
  notFound: "No such item.",
  source: "Prices: eBay US · Charts: TradingView Lightweight Charts",
  vendor: { NVIDIA: "NVIDIA", AMD: "AMD", DESKTOP: "Desktop" },
};

export function dict(locale: Locale): Dict {
  return locale === "ko" ? ko : en;
}

/** 상승·하락 색: 한국은 빨강 상승·파랑 하락, 영어권은 초록 상승·빨강 하락 */
export function upDownColors(locale: Locale) {
  return locale === "ko" ? { up: "#ff6464", down: "#5c9dff" } : { up: "#34d399", down: "#ff6464" };
}
