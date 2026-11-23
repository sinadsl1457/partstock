"use client";
// 왼쪽 종목 목록(코인 거래소처럼). 누르면 같은 화면 오른쪽 차트가 그 종목으로 바뀐다.
// 위의 "필터"로 분류별 필터 창을 열고(VGA 시리즈, RAM 세대·구성), 고른 값은 브라우저에 분류마다 기억한다.
import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import { useEffect, useMemo, useState, useSyncExternalStore } from "react";
import {
  changedCount,
  filterGroups,
  initialFilter,
  matchesFilter,
  parseFilter,
  seriesLabel,
  type BoardFilter,
  type Cat,
} from "@/lib/filters";
import { Sparkline } from "./sparkline";

export type ListRow = {
  key: string;
  name: string;
  vendor: string;
  facets: Record<string, string>;
  big: string | null;
  small: string | null;
  changeText: string;
  changeColor: string;
  spark: { p25Cents: number }[];
};

/** 서버에서 언어에 맞춰 만든 글자(클라이언트로 함수는 못 넘겨서 {count} 자리만 남긴 글자) */
export type FilterLabels = {
  filter: string;
  title: string;
  reset: string;
  apply: string;
  empty: string;
  hintMulti: string;
  facet: Record<string, string>;
  pack: Record<string, string>;
  brand: Record<string, string>;
  /** "Core {gen}세대" */
  coreGen: string;
  priceHeader: string;
};

const EVENT = "partstock-filter";
const storageKey = (c: Cat) => `partstock.filter.${c}`;

function subscribe(onChange: () => void) {
  window.addEventListener(EVENT, onChange);
  window.addEventListener("storage", onChange);
  return () => {
    window.removeEventListener(EVENT, onChange);
    window.removeEventListener("storage", onChange);
  };
}

function readRaw(c: Cat): string | null {
  try {
    return localStorage.getItem(storageKey(c));
  } catch {
    return null; // 저장소를 못 쓰면 처음 값
  }
}

function saveFilter(c: Cat, f: BoardFilter) {
  try {
    localStorage.setItem(storageKey(c), JSON.stringify(f));
  } catch {}
  window.dispatchEvent(new Event(EVENT));
}

export function BoardList({
  rows,
  base,
  category,
  tooFew,
  colors,
  labels,
}: {
  rows: ListRow[];
  base: string;
  category: Cat;
  tooFew: string;
  colors: { up: string; down: string };
  labels: FilterLabels;
}) {
  const path = usePathname() ?? base;
  // 저장된 글자 그대로를 스냅숏으로(매번 새 객체를 만들면 끝없이 다시 그린다)
  const raw = useSyncExternalStore(subscribe, () => readRaw(category), () => null);
  const filter = useMemo(() => parseFilter(category, raw), [category, raw]);
  const [open, setOpen] = useState(false);
  const router = useRouter();
  const shown = rows.filter((r) => matchesFilter(r.facets, filter));
  const keyInPath = path.length > base.length ? decodeURIComponent(path.slice(base.length + 1)).split("/")[0] : null;
  // 주소에 종목이 없으면 오른쪽은 전체 목록 첫 종목을 보여 준다
  const selected = keyInPath ?? rows[0]?.key;
  const changed = changedCount(category, filter);

  // 주소에 종목이 없는데 그 첫 종목이 필터로 가려지면, 오른쪽도 필터된 첫 종목으로(왼쪽 목록과 어긋나지 않게).
  // 주소에 종목이 있으면(공유한 링크 등) 그대로 둔다.
  useEffect(() => {
    if (!keyInPath && shown.length > 0 && !shown.some((r) => r.key === selected)) {
      router.replace(`${base}/${shown[0].key}`, { scroll: false });
    }
  }, [keyInPath, shown, selected, base, router]);

  return (
    <>
      <div className="flex items-center justify-between border-b border-line bg-surface-hi px-2 py-1 text-xs text-sub">
        <button
          type="button"
          onClick={() => setOpen((o) => !o)}
          aria-expanded={open}
          className={`inline-flex min-h-9 items-center gap-1.5 rounded-lg px-2 text-[13px] font-semibold hover:bg-line ${
            changed > 0 ? "text-accent" : "text-sub"
          }`}
        >
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" aria-hidden="true">
            <path d="M4 6h10M18 6h2M4 12h4M12 12h8M4 18h12M20 18h0" />
            <circle cx="16" cy="6" r="2" />
            <circle cx="10" cy="12" r="2" />
            <circle cx="18" cy="18" r="2" />
          </svg>
          {changed > 0 ? `${labels.filter} ${changed}` : labels.filter}
        </button>
        <span className="pr-2">{labels.priceHeader}</span>
      </div>
      {open && (
        <FilterPanel
          category={category}
          current={filter}
          rows={rows}
          labels={labels}
          onApply={(f) => {
            saveFilter(category, f);
            setOpen(false);
            // 보고 있던 종목이 가려지면 필터된 첫 종목으로(사용자가 직접 바꾼 경우만)
            const next = rows.filter((r) => matchesFilter(r.facets, f));
            if (keyInPath && next.length > 0 && !next.some((r) => r.key === keyInPath)) {
              router.push(`${base}/${next[0].key}`, { scroll: false });
            }
          }}
        />
      )}
      <ul className="divide-y divide-line">
        {shown.map((r) => {
          const on = r.key === selected;
          return (
            <li key={r.key}>
              <Link
                href={`${base}/${r.key}`}
                scroll={false}
                aria-current={on ? "true" : undefined}
                className={`flex min-h-14 items-center gap-3 px-4 py-2.5 no-underline ${
                  on ? "bg-surface-hi shadow-[inset_3px_0_0_#7ee04b]" : "hover:bg-surface-hi"
                }`}
              >
                <div className="min-w-0 flex-1">
                  {/* SSD는 용량이 이름 끝에 있어 잘리면 안 된다 → 두 줄까지 */}
                  <div className="line-clamp-2 text-[15px] leading-snug font-semibold text-ink">{r.name}</div>
                  <div className="text-xs text-muted">{r.vendor}</div>
                </div>
                <Sparkline points={r.spark} up={colors.up} down={colors.down} />
                <div className="num w-[92px] text-right">
                  {r.big ? (
                    <>
                      <div className="text-[15px] font-bold text-ink">{r.big}</div>
                      {/* 값보다 흐름이 핵심이라 등락을 색 띠로(11/23 사용자 결정) */}
                      <span
                        className="mt-0.5 inline-block rounded-[5px] px-1.5 py-px text-xs font-bold"
                        style={{ color: r.changeColor, background: r.changeColor + "24" }}
                      >
                        {r.changeText}
                      </span>
                    </>
                  ) : (
                    <span className="rounded-md border border-line-hi px-2 py-1 text-xs text-muted">{tooFew}</span>
                  )}
                </div>
              </Link>
            </li>
          );
        })}
      </ul>
    </>
  );
}

/** 필터 창: 고르는 동안 맞는 종목 수를 바로 세고, 적용을 눌러야 목록이 바뀐다 */
function FilterPanel({
  category,
  current,
  rows,
  labels,
  onApply,
}: {
  category: Cat;
  current: BoardFilter;
  rows: ListRow[];
  labels: FilterLabels;
  onApply: (f: BoardFilter) => void;
}) {
  const [f, setF] = useState<BoardFilter>(current);
  const count = rows.filter((r) => matchesFilter(r.facets, f)).length;
  const valueLabel = (facet: string, v: string) =>
    facet === "series"
      ? seriesLabel(v, labels.coreGen)
      : facet === "pack"
        ? (labels.pack[v] ?? v)
        : facet === "brand"
          ? (labels.brand[v] ?? v)
          : facet === "iface"
            ? ({ NVME5: "NVMe Gen5", NVME4: "NVMe Gen4" }[v] ?? v)
            : v;

  return (
    <div className="flex flex-col gap-4 border-b border-line bg-surface-hi px-4 py-4">
      <div className="flex items-center justify-between">
        <h2 className="text-base font-bold">{labels.title}</h2>
        <button type="button" onClick={() => setF(initialFilter(category))} className="min-h-9 px-2 text-[13px] text-muted hover:text-ink">
          {labels.reset}
        </button>
      </div>
      {filterGroups[category].map((g) => (
        <fieldset key={g.facet} className="flex flex-col gap-2">
          <legend className="mb-2 text-xs font-semibold tracking-wide text-muted">
            {labels.facet[g.facet] ?? g.facet}
            {!g.single && <span className="ml-2 font-normal text-faint">{labels.hintMulti}</span>}
          </legend>
          <div className="flex flex-wrap gap-2">
            {g.values.map((v) => {
              const on = (f[g.facet] ?? []).includes(v);
              return (
                <button
                  key={v}
                  type="button"
                  aria-pressed={on}
                  onClick={() =>
                    setF((prev) => {
                      const now = prev[g.facet] ?? [];
                      const next = g.single ? [v] : on ? now.filter((x) => x !== v) : [...now, v];
                      return { ...prev, [g.facet]: next };
                    })
                  }
                  className={`inline-flex min-h-10 items-center gap-1 rounded-[10px] border px-4 text-sm ${
                    on ? "border-accent bg-accent/10 font-bold text-accent" : "border-line-hi text-sub hover:text-ink"
                  }`}
                >
                  {on && <span aria-hidden="true">✓</span>}
                  {valueLabel(g.facet, v)}
                </button>
              );
            })}
          </div>
        </fieldset>
      ))}
      <button
        type="button"
        disabled={count === 0}
        onClick={() => onApply(f)}
        className="min-h-11 rounded-xl bg-accent text-[15px] font-semibold text-on-accent hover:brightness-110 disabled:opacity-40"
      >
        {count === 0 ? labels.empty : labels.apply.replace("{count}", String(count))}
      </button>
    </div>
  );
}
