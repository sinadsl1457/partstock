"use client";
// 오른쪽 큰 차트. 기간(1일~전체)과 모양(선·봉)을 바꿔 가며 본다. 여섯 기간 데이터는 서버에서 한 번에 받아 온다.
// 원화 화면은 "지금 환율" 하나로 전체를 바꿔 그린다: 환율 변동이 아니라 부품 가격 움직임만 보이게.
// 차트: TradingView Lightweight Charts(Apache-2.0, 왼쪽 아래 로고는 라이선스 표시라 끄지 않는다).
import {
  AreaSeries,
  CandlestickSeries,
  ColorType,
  createChart,
  type IChartApi,
  type UTCTimestamp,
} from "lightweight-charts";
import { useEffect, useRef, useState } from "react";
import type { Chart, Range } from "@/lib/api";

export type ChartLabels = {
  ranges: Record<Range, string>;
  bucket: Record<string, string>;
  line: string;
  candle: string;
  rangeChange: string;
  high: string;
  low: string;
  collecting: string;
  tooFewPoints: string;
};

export function ChartPanel({
  charts,
  usdKrw,
  tzOffsetHours,
  colors,
  labels,
}: {
  charts: Record<Range, Chart | null>;
  usdKrw: number | null;
  /** 시간축 표시용(한국어 +9, 영어 0=UTC) */
  tzOffsetHours: number;
  colors: { up: string; down: string };
  labels: ChartLabels;
}) {
  const [range, setRange] = useState<Range>("1d");
  const [kind, setKind] = useState<"line" | "candle">("line");
  const box = useRef<HTMLDivElement>(null);
  const chart = charts[range];
  const bars = chart?.bars ?? [];

  const toPrice = (cents: number) => (usdKrw ? ((cents / 100) * usdKrw) / 10000 : cents / 100);
  const fmt = (v: number) =>
    usdKrw ? v.toLocaleString("ko-KR", { minimumFractionDigits: 1, maximumFractionDigits: 1 }) + "만원" : "$" + Math.round(v).toLocaleString("en-US");
  const pct = chart?.rangePct ?? null;
  const trend = pct === null || pct >= 0 ? colors.up : colors.down;
  const high = bars.length ? Math.max(...bars.map((b) => b.highCents)) : null;
  const low = bars.length ? Math.min(...bars.map((b) => b.lowCents)) : null;

  useEffect(() => {
    if (!box.current || bars.length === 0) return;
    const shift = tzOffsetHours * 3600;
    const time = (iso: string) => (Date.parse(iso) / 1000 + shift) as UTCTimestamp;
    const c: IChartApi = createChart(box.current, {
      autoSize: true,
      layout: { background: { type: ColorType.Solid, color: "#ffffff" }, textColor: "#4b5563", fontFamily: "inherit" },
      grid: { vertLines: { color: "#f3f4f6" }, horzLines: { color: "#f3f4f6" } },
      rightPriceScale: { borderColor: "#e5e7eb" },
      timeScale: { borderColor: "#e5e7eb", timeVisible: range === "1d" || range === "1w", secondsVisible: false },
      // 눈금은 원 단위(100원 반올림)·달러 단위: 한 시간 변화가 몇천 원이라 만원 단위로는 눈금이 다 같아 보임
      localization: {
        priceFormatter: (v: number) =>
          usdKrw ? (Math.round(v * 100) * 100).toLocaleString("ko-KR") : "$" + v.toLocaleString("en-US", { maximumFractionDigits: 2 }),
      },
      crosshair: { mode: 1 },
    });
    if (kind === "line") {
      const s = c.addSeries(AreaSeries, {
        lineColor: trend,
        topColor: trend + "33",
        bottomColor: trend + "05",
        lineWidth: 2,
      });
      s.setData(bars.map((b) => ({ time: time(b.t), value: toPrice(b.closeCents) })));
    } else {
      const s = c.addSeries(CandlestickSeries, {
        upColor: colors.up,
        downColor: colors.down,
        borderUpColor: colors.up,
        borderDownColor: colors.down,
        wickUpColor: colors.up,
        wickDownColor: colors.down,
      });
      s.setData(
        bars.map((b) => ({
          time: time(b.t),
          open: toPrice(b.openCents),
          high: toPrice(b.highCents),
          low: toPrice(b.lowCents),
          close: toPrice(b.closeCents),
        })),
      );
    }
    c.timeScale().fitContent();
    return () => c.remove();
    // eslint-disable-next-line react-hooks/exhaustive-deps -- toPrice는 usdKrw로 정해진다
  }, [bars, kind, range, usdKrw, tzOffsetHours, trend, colors]);

  const pill = (on: boolean) =>
    `min-h-9 rounded-lg px-3 text-[13px] ${on ? "bg-white font-semibold text-gray-900 shadow-sm" : "font-medium text-gray-600 hover:text-gray-900"}`;

  return (
    <div className="flex flex-col gap-3">
      <div className="flex flex-wrap items-center justify-between gap-2">
        <div className="flex flex-wrap gap-1 rounded-[10px] bg-gray-100 p-1" role="group">
          {(Object.keys(labels.ranges) as Range[]).map((r) => (
            <button key={r} type="button" onClick={() => setRange(r)} aria-pressed={r === range} className={pill(r === range)}>
              {labels.ranges[r]}
            </button>
          ))}
        </div>
        <div className="flex gap-1 rounded-[10px] bg-gray-100 p-1" role="group">
          <button type="button" onClick={() => setKind("line")} aria-pressed={kind === "line"} className={pill(kind === "line")}>
            {labels.line}
          </button>
          <button type="button" onClick={() => setKind("candle")} aria-pressed={kind === "candle"} className={pill(kind === "candle")}>
            {labels.candle}
          </button>
        </div>
      </div>

      <div className="num flex flex-wrap gap-x-5 gap-y-1 text-[13px] text-gray-600">
        <span>
          {labels.rangeChange}{" "}
          <b style={{ color: pct === null ? "#6b7280" : pct >= 0 ? colors.up : colors.down }}>
            {pct === null ? "—" : (pct > 0 ? "+" : "") + pct.toFixed(2) + "%"}
          </b>
        </span>
        {high !== null && (
          <span>
            {labels.high} <b className="text-gray-900">{fmt(toPrice(high))}</b>
          </span>
        )}
        {low !== null && (
          <span>
            {labels.low} <b className="text-gray-900">{fmt(toPrice(low))}</b>
          </span>
        )}
        {chart && <span className="text-gray-500">{labels.bucket[chart.bucket] ?? chart.bucket}</span>}
      </div>

      {bars.length === 0 ? (
        <div className="flex h-[380px] items-center justify-center rounded-lg bg-gray-50 text-sm text-gray-500">—</div>
      ) : (
        <div ref={box} className="h-[380px] w-full" />
      )}
      <p className="text-xs text-gray-500">{bars.length === 1 ? labels.tooFewPoints : labels.collecting}</p>
    </div>
  );
}
