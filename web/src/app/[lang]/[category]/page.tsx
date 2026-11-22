// 시세판: 그래픽카드(/ko/gpu) 또는 램(/ko/ram) 칩셋 목록.
import Link from "next/link";
import { notFound } from "next/navigation";
import { Suspense } from "react";
import { JumpButtons } from "@/components/jump";
import { Sparkline } from "@/components/sparkline";
import { getBoard, type Category } from "@/lib/api";
import { mainPrice, pct, rate, usd } from "@/lib/format";
import { dict, isLocale, locales, upDownColors } from "@/lib/i18n";

const categories = ["gpu", "ram"] as const;

export function generateStaticParams() {
  return locales.flatMap((lang) => categories.map((category) => ({ lang, category })));
}

export default function BoardPage({ params }: PageProps<"/[lang]/[category]">) {
  return (
    <Suspense fallback={<main className="mx-auto h-[800px] max-w-[1200px] p-6" />}>
      <BoardContent params={params} />
    </Suspense>
  );
}

async function BoardContent({ params }: { params: PageProps<"/[lang]/[category]">["params"] }) {
  const { lang, category } = await params;
  if (!isLocale(lang) || !(categories as readonly string[]).includes(category)) notFound();
  const t = dict(lang);
  const colors = upDownColors(lang);
  const board = await getBoard(category.toUpperCase() as Category);

  const tab = (c: (typeof categories)[number], label: string) => (
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
    <main className="mx-auto flex max-w-[1200px] flex-col gap-4 p-6">
      <div className="flex flex-wrap items-center justify-between gap-3">
        <nav className="flex gap-1 rounded-[10px] bg-gray-200 p-1">
          {tab("gpu", t.gpu)}
          {tab("ram", t.ram)}
        </nav>
        {board.day && (
          <p className="num text-[13px] text-gray-600">
            {t.updated(board.day)}
            {lang === "ko" && board.fx && ` · ${t.fx(rate(board.fx), board.fx.day)}`}
          </p>
        )}
      </div>

      {!board.day && <p className="rounded-xl border border-gray-200 bg-white p-6 text-gray-600">{t.noData}</p>}

      <section className="overflow-hidden rounded-xl border border-gray-200 bg-white">
        <div className="overflow-x-auto">
          <table className="w-full min-w-[860px] border-collapse text-left">
            <thead>
              <tr className="bg-gray-50 text-xs font-medium text-gray-600">
                <th className="px-4 py-3 font-medium">{t.colName}</th>
                <th className="px-4 py-3 text-right font-medium">{t.colPrice}</th>
                <th className="px-4 py-3 text-right font-medium">{t.colMedian}</th>
                <th className="px-4 py-3 text-right font-medium">{t.colChange}</th>
                <th className="px-4 py-3 font-medium">{t.colTrend}</th>
                <th className="px-4 py-3 text-right font-medium">{t.colCount}</th>
                <th className="px-4 py-3 text-right font-medium">{t.colJump}</th>
              </tr>
            </thead>
            <tbody>
              {board.items.map((it) => {
                const main = it.price ? mainPrice(it.price, board.fx, lang) : null;
                const ch = it.change;
                return (
                  <tr key={it.key} className="border-t border-gray-100">
                    <td className="px-4 py-3.5">
                      <Link href={`/${lang}/t/${it.key}`} className="text-[15px] font-semibold text-gray-900 no-underline hover:underline">
                        {it.name}
                      </Link>
                      <div className="mt-0.5 text-xs text-gray-500">{t.vendor[it.vendor] ?? it.vendor}</div>
                    </td>
                    <td className="num px-4 py-3.5 text-right">
                      {main ? (
                        <>
                          <div className="text-base font-bold">{main.big}</div>
                          {main.small && <div className="text-xs text-gray-500">{main.small}</div>}
                        </>
                      ) : (
                        <span className="rounded-md bg-gray-100 px-2 py-1 text-[13px] text-gray-500">{t.tooFew}</span>
                      )}
                    </td>
                    <td className="num px-4 py-3.5 text-right text-sm text-gray-700">{it.price ? usd(it.price.medianCents) : "—"}</td>
                    <td
                      className="num px-4 py-3.5 text-right text-sm"
                      style={{ color: !ch || ch.pct === 0 ? "#6b7280" : ch.pct > 0 ? colors.up : colors.down }}
                    >
                      {ch ? pct(ch.pct) : "—"}
                    </td>
                    <td className="px-4 py-2.5">
                      <Sparkline points={it.spark} up={colors.up} down={colors.down} />
                    </td>
                    <td className="num px-4 py-3.5 text-right text-sm text-gray-700">{it.price ? it.price.listingCount : "—"}</td>
                    <td className="px-4 py-3.5 text-right">
                      <JumpButtons links={it.links} ebay={t.ebay} danawa={t.danawa} />
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      </section>

      <p className="text-[13px] leading-relaxed text-gray-600">{t.boardNote}</p>
      <p className="text-xs text-gray-500">{t.source}</p>
    </main>
  );
}
