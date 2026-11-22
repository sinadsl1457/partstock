// 시세 목록 필터: 분류(VGA·RAM)마다 어떤 칸(facet)으로 거르는지. 필터를 늘리면 filterGroups에 한 줄 추가(앱과 같은 규칙).
// 서버가 종목마다 facets(series, ddr, pack)를 준다.
export type Cat = "gpu" | "ram";

/** single이면 하나만 고른다(RAM 구성). 아니면 여러 개, 아무것도 안 고르면 전체 */
export type FilterGroup = { facet: string; values: string[]; single?: boolean; initial: string[] };

export const filterGroups: Record<Cat, FilterGroup[]> = {
  gpu: [{ facet: "series", values: ["RTX50", "RTX40", "RX9000", "RX7000"], initial: [] }],
  ram: [
    { facet: "ddr", values: ["DDR5", "DDR4"], initial: [] },
    // 한국은 1개 단위 판매가 기본이라 1개가 처음 값(11/22 사용자 결정)
    { facet: "pack", values: ["1", "2"], single: true, initial: ["1"] },
  ],
};

export type BoardFilter = Record<string, string[]>;

export function initialFilter(c: Cat): BoardFilter {
  return Object.fromEntries(filterGroups[c].map((g) => [g.facet, g.initial]));
}

const same = (a: string[], b: string[]) => a.length === b.length && a.every((v) => b.includes(v));

/** 처음 값과 다른 묶음 수(필터 버튼에 표시) */
export function changedCount(c: Cat, f: BoardFilter): number {
  return filterGroups[c].filter((g) => !same(f[g.facet] ?? g.initial, g.initial)).length;
}

/** 고른 값이 없으면 통과, 종목에 그 칸이 없으면 거르지 않는다 */
export function matchesFilter(facets: Record<string, string> | undefined, f: BoardFilter): boolean {
  return Object.entries(f).every(([k, vs]) => {
    const v = facets?.[k];
    return vs.length === 0 || v === undefined || vs.includes(v);
  });
}

/** 저장본을 지금 정의에 맞춰 읽는다(없어진 값은 버리고, single이 비면 처음 값) */
export function parseFilter(c: Cat, raw: string | null): BoardFilter {
  let saved: Record<string, unknown> = {};
  try {
    saved = raw ? (JSON.parse(raw) as Record<string, unknown>) : {};
  } catch {}
  return Object.fromEntries(
    filterGroups[c].map((g) => {
      const vs = Array.isArray(saved[g.facet]) ? (saved[g.facet] as unknown[]).filter((v): v is string => g.values.includes(v as string)) : null;
      return [g.facet, vs === null || (g.single && vs.length !== 1) ? g.initial : vs];
    }),
  );
}

/** RTX50 → RTX 50 */
export function seriesLabel(v: string): string {
  return v.replace(/^(RTX|RX)(\d+)$/, "$1 $2");
}
