// 종목 상세: /ko/t/rtx-5070-ti, /ko/t/rtx-5070-ti/msi, /ko/t/rtx-5070-ti/msi/gaming-trio
// 종목은 매일 새로 생길 수 있어 미리 만들지 않고 요청 때 만든다(Suspense 안에서).
import Link from "next/link";
import { notFound } from "next/navigation";
import { Suspense } from "react";
import { JumpButtons } from "@/components/jump";
import { PriceChart } from "@/components/price-chart";
import { getTicker, type Child, type Fx, type Period } from "@/lib/api";
import { mainPrice, pct, usd } from "@/lib/format";
import { dict, isLocale, upDownColors, type Locale } from "@/lib/i18n";

const periods: Period[] = ["day", "week", "month", "year"];

export default function TickerPage({ params }: PageProps<"/[lang]/t/[...key]">) {
  return (
    <main className="mx-auto flex max-w-[1200px] flex-col gap-4 p-6">
      <Suspense fallback={<div className="h-[600px] rounded-xl border border-gray-200 bg-white" />}>
        <TickerContent params={params} />
      </Suspense>
    </main>
  );
}

async function TickerContent({ params }: { params: PageProps<"/[lang]/t/[...key]">["params"] }) {
  const { lang, key: parts } = await params;
  if (!isLocale(lang)) notFound();
  const key = parts.map(decodeURIComponent).join("/");
  const t = dict(lang);
  const colors = upDownColors(lang);

  // 네 기간을 한 번에 받아 두면 기간 버튼을 눌러도 기다리지 않는다(각각 1시간 캐시)
  const all = await Promise.all(periods.map((p) => getTicker(key, p)));
  const d = all[1];
  if (!d) notFound();
  const data = Object.fromEntries(
    periods.map((p, i) => [p, { points: all[i]?.points ?? [], candles: all[i]?.candles ?? [] }]),
  ) as Record<Period, { points: typeof d.points; candles: typeof d.candles }>;
  const main = d.price ? mainPrice(d.price, d.fx, lang) : null;
  const crumbs = key.split("/");

  return (
    <>
      <nav aria-label="breadcrumb" className="text-sm text-gray-600">
        <Link href={`/${lang}/${d.ticker.category.toLowerCase()}`} className="text-gray-600">
          {t.back}
        </Link>
        {crumbs.map((_, i) => {
          const sub = crumbs.slice(0, i + 1).join("/");
          const label = i === 0 ? d.ticker.chipsetName : i === 1 ? d.ticker.makerName : d.ticker.seriesName;
          return (
            <span key={sub}>
              {" / "}
              {i === crumbs.length - 1 ? (
                <span className="font-semibold text-gray-900">{label}</span>
              ) : (
                <Link href={`/${lang}/t/${sub}`} className="text-gray-600">
                  {label}
                </Link>
              )}
            </span>
          );
        })}
      </nav>

      <section className="flex flex-wrap items-end justify-between gap-6 rounded-xl border border-gray-200 bg-white p-6">
        <div className="flex flex-col gap-1.5">
          <h1 className="text-[32px] font-bold tracking-tight">{d.ticker.name}</h1>
          {main && d.price ? (
            <>
              <div className="num flex flex-wrap items-baseline gap-3">
                <span className="text-4xl font-bold">{main.big}</span>
                {main.small && <span className="text-lg text-gray-600">{main.small}</span>}
                <span
                  className="text-base font-semibold"
                  style={{ color: !d.change || d.change.pct === 0 ? "#6b7280" : d.change.pct > 0 ? colors.up : colors.down }}
                >
                  {d.change ? pct(d.change.pct) : "—"}
                </span>
              </div>
              <div className="num text-sm text-gray-600">
                {t.colPrice} · {t.median} {usd(d.price.medianCents)} · {t.listings(d.price.listingCount)} · {d.day}
              </div>
            </>
          ) : (
            <span className="w-fit rounded-md bg-gray-100 px-2 py-1 text-sm text-gray-500">{t.tooFew}</span>
          )}
        </div>
        <JumpButtons links={d.links} ebay={t.viewOnEbay} danawa={t.viewOnDanawa} size="lg" />
      </section>

      <PriceChart
        data={data}
        initial="week"
        usdKrw={lang === "ko" && d.fx ? d.fx.usdKrw : null}
        colors={colors}
        labels={{
          periods: t.periods,
          periodNote: t.periodNote,
          upDown: t.upDown,
          accumulating: data.day.points.length < 14 ? t.accumulating(data.day.points.length) : null,
          title: t.chart,
        }}
      />

      {(d.makers.length > 0 || d.models.length > 0) && (
        <div className="grid grid-cols-[repeat(auto-fit,minmax(340px,1fr))] gap-4">
          {d.makers.length > 0 && <ChildList title={t.makers} items={d.makers} fx={d.fx} lang={lang} />}
          {d.models.length > 0 && <ChildList title={t.models} note={t.modelsNote} items={d.models} fx={d.fx} lang={lang} />}
        </div>
      )}
    </>
  );
}

function ChildList({ title, note, items, fx, lang }: { title: string; note?: string; items: Child[]; fx: Fx | null; lang: Locale }) {
  const t = dict(lang);
  return (
    <section className="overflow-hidden rounded-xl border border-gray-200 bg-white">
      <h2 className="border-b border-gray-100 px-5 py-4 text-base font-bold">
        {title} {note && <span className="text-xs font-medium text-gray-500">{note}</span>}
      </h2>
      {items.map((c) => {
        const m = c.price ? mainPrice(c.price, fx, lang) : null;
        return (
          <div key={c.key} className="flex items-center justify-between gap-3 border-t border-gray-50 px-5 py-3">
            <div className="min-w-0">
              <Link href={`/${lang}/t/${c.key}`} className="text-[15px] font-semibold text-gray-900 no-underline hover:underline">
                {c.name}
              </Link>
              <div className="num text-xs text-gray-500">
                {c.price && `${t.listings(c.price.listingCount)} · ${t.median} ${usd(c.price.medianCents)}`}
              </div>
            </div>
            <div className="flex items-center gap-3">
              {m ? (
                <div className="num text-right">
                  <div className="text-[15px] font-bold">{m.big}</div>
                  {m.small && <div className="text-xs text-gray-500">{m.small}</div>}
                </div>
              ) : (
                <span className="rounded-md bg-gray-100 px-2 py-1 text-[13px] text-gray-500">{t.tooFew}</span>
              )}
              <JumpButtons links={c.links} ebay={t.ebay} danawa={t.danawa} />
            </div>
          </div>
        );
      })}
    </section>
  );
}
