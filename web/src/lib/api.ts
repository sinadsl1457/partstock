// 시세 API(Spring 서버) 호출. 서버 컴포넌트에서만 쓴다.
// 시세는 매시간 정각에 바뀐다 → 10분마다 새로 받고, 받는 동안은 바로 전 것을 보여 준다.
import "server-only";
import { cacheLife } from "next/cache";

const BASE = process.env.PARTSTOCK_API_URL ?? "http://localhost:8080";
const LIFE = { stale: 300, revalidate: 600, expire: 3600 };

export type Category = "GPU" | "RAM" | "CPU" | "SSD";
export type Range = "1d" | "1w" | "1m" | "3m" | "1y" | "all";
export const ranges: Range[] = ["1d", "1w", "1m", "3m", "1y", "all"];

export type Fx = { day: string; usdKrw: number };
/** 글이 적어 대표가를 믿기 어려움. 서버 값(fewListings)이 없으면 같은 기준(20개)으로 */
export const few = (p: Price | null | undefined) => !!p && (p.fewListings ?? p.listingCount < 20);

export type Price = { priceCents: number; pricePct?: number; p25Cents: number; medianCents: number; p75Cents: number; listingCount: number; fewListings?: boolean };
export type Change = { prevAt: string; prevPriceCents: number; pct: number };
export type Links = { ebay: string; danawa: string };

export type BoardItem = {
  key: string;
  name: string;
  vendor: string;
  /** 필터용 분류: GPU {series: "RTX50"}, RAM {ddr: "DDR5", pack: "1"|"2"} */
  facets: Record<string, string>;
  price: Price | null;
  change: Change | null;
  spark: { t: string; priceCents: number }[];
  links: Links;
};
export type Board = { category: Category; day: string | null; updatedAt: string | null; fx: Fx | null; items: BoardItem[] };

export type Child = { key: string; level: string; name: string; price: Price | null; change: Change | null; links: Links };
export type TickerDetail = {
  ticker: {
    key: string;
    level: "CHIPSET" | "MAKER" | "MODEL";
    category: Category;
    name: string;
    chipsetName: string;
    makerName: string | null;
    seriesName: string | null;
  };
  day: string | null;
  updatedAt: string | null;
  fx: Fx | null;
  price: Price | null;
  change: Change | null;
  makers: Child[];
  models: Child[];
  links: Links;
};

export type Bar = {
  t: string;
  openCents: number;
  highCents: number;
  lowCents: number;
  closeCents: number;
  medianCents: number;
  samples: number;
};
export type Chart = {
  key: string;
  range: Range;
  bucket: string;
  bars: Bar[];
  rangePct: number | null;
  /** 처음 수집한 시각과 쌓인 매시간 시세 수(봉 시작 시각과 다름) */
  since: string | null;
  points: number;
};

/** 급등·급락 한 줄(서버 ApiDtos.Mover). price·change는 늘 있다 */
export type Mover = { key: string; name: string; category: Category; vendor: string; price: Price; change: Change };
/** 4개 분류에서 판매 글 minListings개 이상, 24시간 변동 상위(up)·하위(down) 각 5개 */
export type Movers = { day: string | null; updatedAt: string | null; fx: Fx | null; minListings: number; up: Mover[]; down: Mover[] };

async function get<T>(path: string): Promise<T | null> {
  const res = await fetch(BASE + path);
  if (res.status === 404) return null;
  if (!res.ok) throw new Error(`시세 API ${res.status}: ${path}`);
  return (await res.json()) as T;
}

export async function getBoard(category: Category): Promise<Board> {
  "use cache";
  cacheLife(LIFE);
  const board = await get<Board>(`/api/board?category=${category}`);
  if (!board) throw new Error("시세판 응답이 비었습니다");
  return board;
}

export async function getTicker(key: string): Promise<TickerDetail | null> {
  "use cache";
  cacheLife(LIFE);
  return get<TickerDetail>(`/api/ticker?key=${encodeURIComponent(key)}`);
}

export async function getChart(key: string, range: Range): Promise<Chart | null> {
  "use cache";
  cacheLife(LIFE);
  return get<Chart>(`/api/chart?key=${encodeURIComponent(key)}&range=${range}`);
}

export async function getMovers(): Promise<Movers> {
  "use cache";
  cacheLife(LIFE);
  const movers = await get<Movers>("/api/movers");
  if (!movers) throw new Error("급등락 응답이 비었습니다");
  return movers;
}
