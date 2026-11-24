// 오른쪽: 고른 종목(없으면 목록 첫 종목)의 현재가·차트·제조사·모델. 두 주소 파일이 같이 쓴다.
//   [category]/page.tsx        /ko/gpu                 → 목록 첫 종목
//   [category]/[...key]/page.tsx /ko/gpu/rtx-5070-ti/msi → 그 종목
// 한 파일([[...key]])로 두면 Vercel이 /ko/gpu용으로 미리 만든 화면을 /ko/gpu/* 전부에 내보냈다(11/22 운영에서 발견).
import Link from "next/link";
import { notFound } from "next/navigation";
import { ChartPanel } from "@/components/chart-panel";
import { JumpButtons } from "@/components/jump";
import { few, getBoard, getChart, getTicker, ranges, type Category, type Chart, type Child, type Fx, type Range } from "@/lib/api";
import { mainPrice, pct, time, usd } from "@/lib/format";
import { dict, upDownColors, type Locale } from "@/lib/i18n";
import { checkParams } from "@/lib/route";

export async function TickerPanel({
  params,
  listFirst = false,
}: {
  params: Promise<{ lang: string; category: string; key?: string[] }>;
  /** 급등락 화면: 종목을 정해 넘기지만 휴대폰에서도 목록(순위)이 먼저 */
  listFirst?: boolean;
}) {
  const p = await params;
  const { lang, category } = checkParams(p.lang, p.category);
  const t = dict(lang);
  const colors = upDownColors(lang);
  const base = `/${lang}/${category}`;

  let key = p.key?.map(decodeURIComponent).join("/");
  if (!key) {
    const board = await getBoard(category.toUpperCase() as Category);
    key = board.items[0]?.key;
    if (!key) notFound();
  }
  const [d, ...chartList] = await Promise.all([getTicker(key), ...ranges.map((r) => getChart(key, r))]);
  if (!d) notFound();
  const charts = Object.fromEntries(ranges.map((r, i) => [r, chartList[i]])) as Record<Range, Chart | null>;
  const main = d.price ? mainPrice(d.price, d.fx, lang) : null;
  const ch = d.change;
  const since = charts["1d"]?.since;
  const parts = key.split("/");

  return (
    // 휴대폰에서 종목을 고르고 들어오면 차트가 목록보다 위에
    <section className={`flex min-w-0 flex-col gap-4 ${p.key && !listFirst ? "order-first lg:order-none" : ""}`}>
      <div className="flex flex-col gap-4 rounded-xl border border-line bg-surface p-5 lg:p-6">
        <nav aria-label="breadcrumb" className="text-[13px] text-muted">
          {parts.map((_, i) => {
            const sub = parts.slice(0, i + 1).join("/");
            const label = i === 0 ? d.ticker.chipsetName : i === 1 ? d.ticker.makerName : d.ticker.seriesName;
            return (
              <span key={sub}>
                {i > 0 && " › "}
                {i === parts.length - 1 ? (
                  <span className="text-ink">{label}</span>
                ) : (
                  <Link href={`${base}/${sub}`} scroll={false} className="text-muted">
                    {label}
                  </Link>
                )}
              </span>
            );
          })}
        </nav>

        <div className="flex flex-wrap items-end justify-between gap-4">
          <div className="flex flex-col gap-1">
            <h1 className="text-2xl font-bold tracking-tight lg:text-[28px]">{d.ticker.name}</h1>
            {main && d.price ? (
              <>
                <div className="num flex flex-wrap items-baseline gap-x-3 gap-y-1">
                  <span className="text-[34px] font-bold leading-tight">{main.big}</span>
                  {main.small && <span className="text-lg text-sub">{main.small}</span>}
                  <span
                    className="text-base font-semibold"
                    style={{ color: !ch || ch.pct === 0 ? "#8e978f" : ch.pct > 0 ? colors.up : colors.down }}
                  >
                    {t.change24h} {ch ? pct(ch.pct) : "—"}
                  </span>
                </div>
                <div className="num text-[13px] text-sub">
                  {t.price}({t.pricePct(d.price.pricePct ?? 25)}) · {t.median} {usd(d.price.medianCents)} · {t.listings(d.price.listingCount)}
                  {few(d.price) && <span className="text-warn"> · {t.fewListings}</span>}
                  {d.updatedAt && ` · ${time(d.updatedAt, lang)}`}
                </div>
                {/* 원화 값을 한국 실구매가로 오해하지 않게 */}
                <p className="max-w-[560px] text-xs leading-relaxed text-faint">ⓘ {t.marketNote}</p>
              </>
            ) : (
              <span className="w-fit rounded-md bg-surface-hi px-2 py-1 text-sm text-muted">{t.tooFew}</span>
            )}
          </div>
          <JumpButtons links={d.links} ebay={t.viewOnEbay} danawa={t.viewOnDanawa} size="lg" />
        </div>

        <ChartPanel
          charts={charts}
          usdKrw={lang === "ko" && d.fx ? d.fx.usdKrw : null}
          tzOffsetHours={lang === "ko" ? 9 : 0}
          colors={colors}
          labels={{
            ranges: t.ranges,
            bucket: t.bucket,
            line: t.line,
            candle: t.candle,
            rangeChange: t.rangeChange,
            high: t.high,
            low: t.low,
            collecting: since ? t.collecting(time(since, lang), charts["1d"]?.points ?? 0) : "",
            tooFewPoints: t.tooFewPoints,
          }}
        />
        <p className="text-xs text-muted">{t.source}</p>
      </div>

      {(d.makers.length > 0 || d.models.length > 0) && (
        <div className="grid grid-cols-[repeat(auto-fit,minmax(320px,1fr))] gap-4">
          {d.makers.length > 0 && <ChildList title={t.makers} items={d.makers} fx={d.fx} lang={lang} base={base} />}
          {d.models.length > 0 && (
            <ChildList title={t.models} note={t.modelsNote} items={d.models} fx={d.fx} lang={lang} base={base} />
          )}
        </div>
      )}
    </section>
  );
}

function ChildList({
  title,
  note,
  items,
  fx,
  lang,
  base,
}: {
  title: string;
  note?: string;
  items: Child[];
  fx: Fx | null;
  lang: Locale;
  base: string;
}) {
  const t = dict(lang);
  const colors = upDownColors(lang);
  return (
    <section className="overflow-hidden rounded-xl border border-line bg-surface">
      <h2 className="border-b border-line px-5 py-3.5 text-base font-bold">
        {title} {note && <span className="text-xs font-medium text-muted">{note}</span>}
      </h2>
      <ul className="divide-y divide-line">
        {items.map((c) => {
          const m = c.price ? mainPrice(c.price, fx, lang) : null;
          return (
            <li key={c.key}>
              <Link
                href={`${base}/${c.key}`}
                scroll={false}
                className="flex min-h-14 items-center justify-between gap-3 px-5 py-2.5 no-underline hover:bg-surface-hi"
              >
                <div className="min-w-0">
                  <div className="truncate text-[15px] font-semibold text-ink">{c.name}</div>
                  {c.price && (
                    <div className="num text-xs text-muted">
                      {t.listings(c.price.listingCount)}
                      {few(c.price) && <span className="text-warn"> · {t.fewListings}</span>}
                    </div>
                  )}
                </div>
                {m ? (
                  <div className="num text-right">
                    <div className="text-[15px] font-bold text-ink">{m.big}</div>
                    <div
                      className="text-xs"
                      style={{ color: !c.change || c.change.pct === 0 ? "#8e978f" : c.change.pct > 0 ? colors.up : colors.down }}
                    >
                      {c.change ? pct(c.change.pct) : m.small}
                    </div>
                  </div>
                ) : (
                  <span className="rounded-md bg-surface-hi px-2 py-1 text-[13px] text-muted">{t.tooFew}</span>
                )}
              </Link>
            </li>
          );
        })}
      </ul>
    </section>
  );
}
