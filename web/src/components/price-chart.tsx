"use client";
// 종목 상세 차트. 일 = 최근 30일 대표가 선(+ 중앙값 연한 선), 주·월·년 = 봉.
// 원화 화면은 "지금 환율"로 전체를 바꿔 그린다: 환율 변동이 아니라 부품 가격 움직임만 보이게.
// 차트: TradingView Lightweight Charts(Apache-2.0, 오른쪽 아래 로고는 라이선스 표시라 끄지 않는다).
import { CandlestickSeries, ColorType, createChart, LineSeries, type IChartApi } from "lightweight-charts";
import { useEffect, useRef, useState } from "react";
import type { Candle, Period, Point } from "@/lib/api";

type Labels = {
  periods: Record<Period, string>;
  periodNote: Record<Period, string>;
  upDown: string;
  /** 쌓인 날이 적을 때 붙이는 안내(서버에서 만든 글자). 충분하면 null */
  accumulating: string | null;
  title: string;
};

export function PriceChart({
  data,
  initial,
  usdKrw,
  colors,
  labels,
}: {
  data: Record<Period, { points: Point[]; candles: Candle[] }>;
  initial: Period;
  usdKrw: number | null;
  colors: { up: string; down: string };
  labels: Labels;
}) {
  const [period, setPeriod] = useState<Period>(initial);
  const box = useRef<HTMLDivElement>(null);
  const { points, candles } = data[period];
  const count = period === "day" ? points.length : candles.length;

  useEffect(() => {
    if (!box.current || count < 2) return;
    const toPrice = (cents: number) => (usdKrw ? (cents / 100) * usdKrw / 10000 : cents / 100);
    const fmt = (v: number) =>
      usdKrw ? v.toLocaleString("ko-KR", { maximumFractionDigits: 1 }) + "만" : "$" + Math.round(v).toLocaleString("en-US");
    const chart: IChartApi = createChart(box.current, {
      autoSize: true,
      layout: { background: { type: ColorType.Solid, color: "#ffffff" }, textColor: "#4b5563", fontFamily: "inherit" },
      grid: { vertLines: { color: "#f3f4f6" }, horzLines: { color: "#f3f4f6" } },
      rightPriceScale: { borderColor: "#e5e7eb" },
      timeScale: { borderColor: "#e5e7eb" },
      localization: { priceFormatter: fmt },
    });
    if (period === "day") {
      const median = chart.addSeries(LineSeries, { color: "#cbd5e1", lineWidth: 1, priceLineVisible: false, lastValueVisible: false });
      median.setData(points.map((p) => ({ time: p.day, value: toPrice(p.medianCents) })));
      const p25 = chart.addSeries(LineSeries, { color: colors.up, lineWidth: 2 });
      p25.setData(points.map((p) => ({ time: p.day, value: toPrice(p.p25Cents) })));
    } else {
      const s = chart.addSeries(CandlestickSeries, {
        upColor: colors.up,
        downColor: colors.down,
        borderUpColor: colors.up,
        borderDownColor: colors.down,
        wickUpColor: colors.up,
        wickDownColor: colors.down,
      });
      s.setData(
        candles.map((c) => ({
          time: c.start,
          open: toPrice(c.openCents),
          high: toPrice(c.highCents),
          low: toPrice(c.lowCents),
          close: toPrice(c.closeCents),
        })),
      );
    }
    chart.timeScale().fitContent();
    return () => chart.remove();
  }, [period, points, candles, count, usdKrw, colors]);

  return (
    <section className="flex flex-col gap-4 rounded-xl border border-gray-200 bg-white p-6">
      <div className="flex flex-wrap items-center justify-between gap-3">
        <h2 className="text-lg font-bold">{labels.title}</h2>
        <div className="flex gap-1 rounded-[10px] bg-gray-100 p-1" role="group">
          {(Object.keys(labels.periods) as Period[]).map((p) => (
            <button
              key={p}
              type="button"
              onClick={() => setPeriod(p)}
              aria-pressed={p === period}
              className={`min-h-9 rounded-lg px-3.5 text-[13px] ${
                p === period ? "bg-white font-semibold text-gray-900 shadow-sm" : "font-medium text-gray-600"
              }`}
            >
              {labels.periods[p]}
            </button>
          ))}
        </div>
      </div>
      {count < 2 ? (
        // 점 하나로는 선이 안 되고 봉 하나는 납작한 줄이라 차트 대신 안내
        <div className="flex h-[300px] items-center justify-center rounded-lg bg-gray-50 px-6 text-center text-sm text-gray-500">
          {labels.accumulating ?? "—"}
        </div>
      ) : (
        <div ref={box} className="h-[300px] w-full" />
      )}
      <p className="text-[13px] leading-relaxed text-gray-600">
        {labels.periodNote[period]} {period !== "day" && `${labels.upDown}.`} {count >= 2 && labels.accumulating}
      </p>
    </section>
  );
}
