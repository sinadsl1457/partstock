// 시세판 틀(코인 거래소처럼): 위에 탭·기준 시각, 왼쪽 종목 목록, 오른쪽 고른 종목 차트(page).
// 목록은 종목을 바꿔도 다시 그리지 않는다(같은 틀 안에서 오른쪽만 바뀜).
import Link from "next/link";
import { Suspense } from "react";
import { BoardList, type ListRow } from "@/components/board-list";
import { getBoard, type Category } from "@/lib/api";
import { mainPrice, pct, rate, time } from "@/lib/format";
import { dict, locales, upDownColors } from "@/lib/i18n";
import { categories, checkParams, type Cat } from "@/lib/route";

export function generateStaticParams() {
  return locales.flatMap((lang) => categories.map((category) => ({ lang, category })));
}

export default function CategoryLayout({ children, params }: LayoutProps<"/[lang]/[category]">) {
  return (
    <main className="mx-auto flex max-w-[1320px] flex-col gap-4 px-4 py-4 lg:px-6">
      <Suspense fallback={<div className="h-12" />}>
        <TopBar params={params} />
      </Suspense>
      <div className="grid items-start gap-4 lg:grid-cols-[400px_minmax(0,1fr)]">
        <Suspense fallback={<aside className="h-[640px] rounded-xl border border-line bg-surface" />}>
          <Aside params={params} />
        </Suspense>
        {children}
      </div>
    </main>
  );
}

async function TopBar({ params }: { params: LayoutProps<"/[lang]/[category]">["params"] }) {
  const p = await params;
  const { lang, category } = checkParams(p.lang, p.category);
  const t = dict(lang);
  const board = await getBoard(category.toUpperCase() as Category);
  const tab = (c: Cat, label: string) => (
    <Link
      href={`/${lang}/${c}`}
      aria-current={c === category ? "page" : undefined}
      className={`-mb-px inline-flex min-h-11 items-center border-b-2 px-1 text-[17px] no-underline ${
        c === category ? "border-accent font-bold text-ink" : "border-transparent font-medium text-muted hover:text-ink"
      }`}
    >
      {label}
    </Link>
  );
  return (
    <div className="flex flex-wrap items-center justify-between gap-3">
      <nav className="flex gap-6 border-b border-line">
        {tab("gpu", t.gpu)}
        {tab("ram", t.ram)}
      </nav>
      {board.updatedAt ? (
        <p className="num inline-flex items-center gap-2 rounded-full border border-line-hi px-3 py-1.5 text-[13px] text-sub">
          <span className="size-1.5 rounded-full bg-accent shadow-[0_0_8px_#7ee04b]" aria-hidden="true" />
          {t.updatedAt(time(board.updatedAt, lang))}
          {lang === "ko" && board.fx && ` · ${t.fx(rate(board.fx), board.fx.day)}`}
        </p>
      ) : (
        <p className="text-[13px] text-sub">{t.noData}</p>
      )}
    </div>
  );
}

async function Aside({ params }: { params: LayoutProps<"/[lang]/[category]">["params"] }) {
  const p = await params;
  const { lang, category } = checkParams(p.lang, p.category);
  const t = dict(lang);
  const colors = upDownColors(lang);
  const board = await getBoard(category.toUpperCase() as Category);
  const rows: ListRow[] = board.items.map((it) => {
    const m = it.price ? mainPrice(it.price, board.fx, lang) : null;
    const ch = it.change;
    return {
      key: it.key,
      name: it.name,
      vendor: t.vendor[it.vendor] ?? it.vendor,
      facets: it.facets ?? {},
      big: m?.big ?? null,
      small: m?.small ?? null,
      changeText: ch ? pct(ch.pct) : `${t.change24h} —`,
      changeColor: !ch || ch.pct === 0 ? "#8e978f" : ch.pct > 0 ? colors.up : colors.down,
      spark: it.spark,
    };
  });
  return (
    <aside className="overflow-hidden rounded-xl border border-line bg-surface lg:sticky lg:top-4">
      <Suspense fallback={<div style={{ height: rows.length * 57 + 44 }} />}>
        <BoardList
          rows={rows}
          base={`/${lang}/${category}`}
          category={category}
          tooFew={t.tooFew}
          colors={colors}
          labels={{
            filter: t.filter,
            title: t.filterTitle(category === "gpu" ? t.gpu : t.ram),
            reset: t.filterReset,
            apply: t.filterApply,
            empty: t.filterEmpty,
            hintMulti: t.filterHintMulti,
            facet: t.facet,
            pack: t.pack,
            priceHeader: `${t.price}(${t.priceHint}) · ${t.change24h}`,
          }}
        />
      </Suspense>
      <p className="border-t border-line px-4 py-3 text-xs leading-relaxed text-muted">{t.boardNote}</p>
    </aside>
  );
}
