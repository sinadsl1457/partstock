// 급등락 화면 왼쪽: 급등 TOP 5, 급락 TOP 5. 줄을 누르면 그 종목의 분류 화면(/ko/gpu/rx-9070-xt)으로.
import Link from "next/link";
import type { Mover, Movers } from "@/lib/api";
import { mainPrice } from "@/lib/format";
import { dict, upDownColors, type Locale } from "@/lib/i18n";
import type { Cat } from "@/lib/route";

export function MoversList({ lang, movers }: { lang: Locale; movers: Movers }) {
  const t = dict(lang);
  const colors = upDownColors(lang);
  const section = (title: string, color: string, list: Mover[], empty: string) => (
    <div className="flex flex-col">
      <div className="flex items-baseline justify-between px-4 pb-1.5 pt-4">
        <h2 className="text-[15px] font-bold" style={{ color }}>
          {title}
        </h2>
        <span className="text-xs text-muted">{t.moversVs}</span>
      </div>
      {list.length === 0 ? (
        <p className="px-4 pb-3 pt-1 text-sm text-muted">{empty}</p>
      ) : (
        <ol>
          {list.map((m, i) => {
            const price = mainPrice(m.price, movers.fx, lang);
            const cat = m.category.toLowerCase() as Cat;
            const p = m.change.pct;
            return (
              <li key={m.key}>
                <Link
                  href={`/${lang}/${cat}/${m.key}`}
                  className="flex items-center gap-3 px-4 py-2.5 text-ink no-underline hover:bg-surface-hi"
                >
                  <span className="num w-5 text-center text-sm font-bold text-muted">{i + 1}</span>
                  <span className="flex min-w-0 flex-1 flex-col gap-0.5">
                    <span className="truncate text-[15px] font-semibold">{m.name}</span>
                    <span className="text-xs text-muted">
                      {t.cat[cat]} · {t.listingsShort(m.price.listingCount)}
                    </span>
                  </span>
                  <span className="flex flex-col items-end gap-1">
                    <span className="num text-[15px] font-bold">{price.big}</span>
                    <span
                      className="num rounded-[5px] px-1.5 py-0.5 text-xs font-bold"
                      style={{ color: p > 0 ? colors.up : colors.down, backgroundColor: `${p > 0 ? colors.up : colors.down}24` }}
                    >
                      {p > 0 ? "▲ " : "▼ "}
                      {Math.abs(p).toFixed(2)}%
                    </span>
                  </span>
                </Link>
              </li>
            );
          })}
        </ol>
      )}
    </div>
  );
  return (
    <>
      {section(t.moversUp, colors.up, movers.up, t.moversNoneUp)}
      <div className="mx-4 my-1 border-t border-line" />
      {section(t.moversDown, colors.down, movers.down, t.moversNoneDown)}
    </>
  );
}
