// 시세판 한 줄의 작은 30일 추이(대표가). 두 점 미만이면 그리지 않는다.
import type { Point } from "@/lib/api";

export function Sparkline({ points, up, down }: { points: Point[]; up: string; down: string }) {
  if (points.length < 2) {
    return <span className="text-xs text-gray-400">—</span>;
  }
  const w = 120;
  const h = 32;
  const vals = points.map((p) => p.p25Cents);
  const min = Math.min(...vals);
  const max = Math.max(...vals);
  const span = max - min || 1;
  const xy = vals.map((v, i) => `${((i / (vals.length - 1)) * (w - 4) + 2).toFixed(1)},${(h - 3 - ((v - min) / span) * (h - 6)).toFixed(1)}`);
  const color = vals[vals.length - 1] >= vals[0] ? up : down;
  return (
    <svg width={w} height={h} viewBox={`0 0 ${w} ${h}`} role="img" aria-label="30일 추이">
      <polyline points={xy.join(" ")} fill="none" stroke={color} strokeWidth={1.5} />
    </svg>
  );
}
