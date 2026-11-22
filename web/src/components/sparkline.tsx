// 목록 한 줄의 작은 추이(최근 7일 매시간 대표가). 두 점 미만이면 그리지 않는다.
export function Sparkline({
  points,
  up,
  down,
  width = 64,
  height = 24,
}: {
  points: { p25Cents: number }[];
  up: string;
  down: string;
  width?: number;
  height?: number;
}) {
  if (points.length < 2) {
    return <span style={{ width }} className="inline-block" />;
  }
  const vals = points.map((p) => p.p25Cents);
  const min = Math.min(...vals);
  const max = Math.max(...vals);
  const span = max - min || 1;
  const xy = vals.map(
    (v, i) => `${((i / (vals.length - 1)) * (width - 2) + 1).toFixed(1)},${(height - 2 - ((v - min) / span) * (height - 4)).toFixed(1)}`,
  );
  const color = vals[vals.length - 1] >= vals[0] ? up : down;
  return (
    <svg width={width} height={height} viewBox={`0 0 ${width} ${height}`} aria-hidden="true">
      <polyline points={xy.join(" ")} fill="none" stroke={color} strokeWidth={1.5} />
    </svg>
  );
}
