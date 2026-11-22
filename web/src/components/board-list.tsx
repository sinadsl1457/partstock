"use client";
// 왼쪽 종목 목록(코인 거래소처럼). 누르면 같은 화면 오른쪽 차트가 그 종목으로 바뀐다.
// 지금 고른 줄을 칠하려고 주소를 읽어서 클라이언트 컴포넌트.
import Link from "next/link";
import { usePathname } from "next/navigation";
import { Sparkline } from "./sparkline";

export type ListRow = {
  key: string;
  name: string;
  vendor: string;
  big: string | null;
  small: string | null;
  changeText: string;
  changeColor: string;
  spark: { p25Cents: number }[];
};

export function BoardList({
  rows,
  base,
  tooFew,
  colors,
}: {
  rows: ListRow[];
  base: string;
  tooFew: string;
  colors: { up: string; down: string };
}) {
  const path = usePathname() ?? base;
  const selected = path.length > base.length ? decodeURIComponent(path.slice(base.length + 1)).split("/")[0] : rows[0]?.key;
  return (
    <ul className="divide-y divide-line">
      {rows.map((r) => {
        const on = r.key === selected;
        return (
          <li key={r.key}>
            <Link
              href={`${base}/${r.key}`}
              scroll={false}
              aria-current={on ? "true" : undefined}
              className={`flex min-h-14 items-center gap-3 px-4 py-2.5 no-underline ${on ? "bg-surface-hi shadow-[inset_3px_0_0_#7ee04b]" : "hover:bg-surface-hi"}`}
            >
              <div className="min-w-0 flex-1">
                <div className="truncate text-[15px] font-semibold text-ink">{r.name}</div>
                <div className="text-xs text-muted">{r.vendor}</div>
              </div>
              <Sparkline points={r.spark} up={colors.up} down={colors.down} />
              <div className="num w-[92px] text-right">
                {r.big ? (
                  <>
                    <div className="text-[15px] font-bold text-ink">{r.big}</div>
                    <div className="text-xs" style={{ color: r.changeColor }}>
                      {r.changeText}
                    </div>
                  </>
                ) : (
                  <span className="rounded-md bg-surface-hi px-2 py-1 text-xs text-muted">{tooFew}</span>
                )}
              </div>
            </Link>
          </li>
        );
      })}
    </ul>
  );
}
