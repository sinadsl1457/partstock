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
        <Suspense fallback={<aside className="h-[640px] rounded-xl border border-gray-200 bg-white" />}>
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
      className={`inline-flex min-h-10 items-center rounded-lg px-5 text-sm no-underline ${
        c === category ? "bg-white font-semibold text-gray-900 shadow-sm" : "font-medium text-gray-600"
      }`}
    >
      {label}
    </Link>
  );
  return (
    <div className="flex flex-wrap items-center justify-between gap-3">
      <nav className="flex gap-1 rounded-[10px] bg-gray-200 p-1">
        {tab("gpu", t.gpu)}
        {tab("ram", t.ram)}
      </nav>
      {board.updatedAt ? (
        <p className="num text-[13px] text-gray-600">
          {t.updatedAt(time(board.updatedAt, lang))}
          {lang === "ko" && board.fx && ` · ${t.fx(rate(board.fx), board.fx.day)}`}
        </p>
      ) : (
        <p className="text-[13px] text-gray-600">{t.noData}</p>
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
      big: m?.big ?? null,
      small: m?.small ?? null,
      changeText: ch ? pct(ch.pct) : `${t.change24h} —`,
      changeColor: !ch || ch.pct === 0 ? "#6b7280" : ch.pct > 0 ? colors.up : colors.down,
      spark: it.spark,
    };
  });
  return (
    <aside className="overflow-hidden rounded-xl border border-gray-200 bg-white lg:sticky lg:top-4">
      <div className="flex justify-between border-b border-gray-100 bg-gray-50 px-4 py-2 text-xs text-gray-600">
        <span>{category === "gpu" ? t.gpu : t.ram}</span>
        <span>
          {t.price}({t.priceHint}) · {t.change24h}
        </span>
      </div>
      <Suspense fallback={<div style={{ height: rows.length * 57 }} />}>
        <BoardList rows={rows} base={`/${lang}/${category}`} tooFew={t.tooFew} colors={colors} />
      </Suspense>
      <p className="border-t border-gray-100 px-4 py-3 text-xs leading-relaxed text-gray-500">{t.boardNote}</p>
    </aside>
  );
}
