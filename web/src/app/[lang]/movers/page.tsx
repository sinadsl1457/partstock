// /ko/movers: 급등락 탭. 왼쪽에 4개 분류 급등·급락 TOP 5, 오른쪽에 급등 1위(없으면 급락 1위) 종목 차트.
// 주소 movers는 [category]보다 먼저 잡힌다(고정 주소 우선).
import { notFound } from "next/navigation";
import { Suspense } from "react";
import { MoversList } from "@/components/movers-list";
import { TickerPanel } from "@/components/ticker-panel";
import { TopBar } from "@/components/top-bar";
import { getMovers } from "@/lib/api";
import { dict, isLocale, locales } from "@/lib/i18n";

export function generateStaticParams() {
  return locales.map((lang) => ({ lang }));
}

export default function MoversPage({ params }: PageProps<"/[lang]/movers">) {
  return (
    <main className="mx-auto flex max-w-[1320px] flex-col gap-4 px-4 py-4 lg:px-6">
      <Suspense fallback={<div className="h-[720px]" />}>
        <MoversBody params={params} />
      </Suspense>
    </main>
  );
}

async function MoversBody({ params }: { params: PageProps<"/[lang]/movers">["params"] }) {
  const { lang } = await params;
  if (!isLocale(lang)) notFound();
  const t = dict(lang);
  const movers = await getMovers();
  const first = movers.up[0] ?? movers.down[0];
  return (
    <>
      <TopBar lang={lang} active="movers" updatedAt={movers.updatedAt} fx={movers.fx} />
      <div className="grid items-start gap-4 lg:grid-cols-[400px_minmax(0,1fr)]">
        <aside className="overflow-hidden rounded-xl border border-line bg-surface lg:sticky lg:top-4">
          <MoversList lang={lang} movers={movers} />
          <p className="mt-2 border-t border-line px-4 py-3 text-xs leading-relaxed text-muted">{t.moversNote(movers.minListings)}</p>
        </aside>
        {first ? (
          <Suspense fallback={<section className="h-[720px] rounded-xl border border-line bg-surface" />}>
            <TickerPanel
              params={Promise.resolve({ lang, category: first.category.toLowerCase(), key: [first.key] })}
              listFirst
            />
          </Suspense>
        ) : (
          <section className="rounded-xl border border-line bg-surface p-6 text-sm text-muted">{t.noData}</section>
        )}
      </div>
    </>
  );
}
