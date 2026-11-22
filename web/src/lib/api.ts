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
export type Price = { p25Cents: number; medianCents: number; p75Cents: number; listingCount: number };
export type Change = { prevAt: string; prevP25Cents: number; pct: number };
export type Links = { ebay: string; danawa: string };

export type BoardItem = {
  key: string;
  name: string;
  vendor: string;
  /** 필터용 분류: GPU {series: "RTX50"}, RAM {ddr: "DDR5", pack: "1"|"2"} */
  facets: Record<string, string>;
  price: Price | null;
  change: Change | null;
  spark: { t: string; p25Cents: number }[];
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
