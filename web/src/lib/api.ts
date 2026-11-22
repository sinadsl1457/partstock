// 시세 API(Spring 서버) 호출. 서버 컴포넌트에서만 쓴다.
// 시세는 하루 한 번(낮 12시) 바뀌어서 1시간 캐시(cacheLife 'hours')면 충분하다.
import "server-only";
import { cacheLife } from "next/cache";

const BASE = process.env.PARTSTOCK_API_URL ?? "http://localhost:8080";

export type Category = "GPU" | "RAM";
export type Period = "day" | "week" | "month" | "year";

export type Fx = { day: string; usdKrw: number };
export type Price = { p25Cents: number; medianCents: number; p75Cents: number; listingCount: number };
export type Change = { prevDay: string; prevP25Cents: number; pct: number };
export type Point = { day: string; p25Cents: number; medianCents: number; p75Cents: number };
export type Candle = {
  start: string;
  openCents: number;
  highCents: number;
  lowCents: number;
  closeCents: number;
  days: number;
};
export type Links = { ebay: string; danawa: string };

export type BoardItem = {
  key: string;
  name: string;
  vendor: string;
  price: Price | null;
  change: Change | null;
  spark: Point[];
  links: Links;
};
export type Board = { category: Category; day: string | null; fx: Fx | null; items: BoardItem[] };

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
  fx: Fx | null;
  price: Price | null;
  change: Change | null;
  period: Period;
  points: Point[];
  candles: Candle[];
  makers: Child[];
  models: Child[];
  links: Links;
};

async function get<T>(path: string): Promise<T | null> {
  const res = await fetch(BASE + path);
  if (res.status === 404) return null;
  if (!res.ok) throw new Error(`시세 API ${res.status}: ${path}`);
  return (await res.json()) as T;
}

export async function getBoard(category: Category): Promise<Board> {
  "use cache";
  cacheLife("hours");
  const board = await get<Board>(`/api/board?category=${category}`);
  if (!board) throw new Error("시세판 응답이 비었습니다");
  return board;
}

export async function getTicker(key: string, period: Period): Promise<TickerDetail | null> {
  "use cache";
  cacheLife("hours");
  return get<TickerDetail>(`/api/ticker?key=${encodeURIComponent(key)}&period=${period}`);
}
