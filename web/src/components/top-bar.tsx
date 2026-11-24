// 시세판 위 줄: 분류 탭(VGA·RAM·CPU·SSD) + 급등락 탭, 오른쪽에 기준 시각·환율. 분류 화면과 급등락 화면이 같이 쓴다.
import Link from "next/link";
import type { Fx } from "@/lib/api";
import { rate, time } from "@/lib/format";
import { dict, type Locale } from "@/lib/i18n";
import { categories, type Cat } from "@/lib/route";

export function TopBar({ lang, active, updatedAt, fx }: { lang: Locale; active: Cat | "movers"; updatedAt: string | null; fx: Fx | null }) {
  const t = dict(lang);
  const tab = (id: Cat | "movers", label: string) => (
    <Link
      key={id}
      href={`/${lang}/${id}`}
      aria-current={id === active ? "page" : undefined}
      className={`-mb-px inline-flex min-h-11 items-center border-b-2 px-1 text-[17px] no-underline ${
        id === active ? "border-accent font-bold text-ink" : "border-transparent font-medium text-muted hover:text-ink"
      }`}
    >
      {label}
    </Link>
  );
  return (
    <div className="flex flex-wrap items-center justify-between gap-3">
      <nav className="flex gap-6 border-b border-line">
        {categories.map((c) => tab(c, t.cat[c]))}
        {tab("movers", t.tabMovers)}
      </nav>
      {updatedAt ? (
        <p className="num inline-flex items-center gap-2 rounded-full border border-line-hi px-3 py-1.5 text-[13px] text-sub">
          <span className="size-1.5 rounded-full bg-accent shadow-[0_0_8px_#7ee04b]" aria-hidden="true" />
          {t.updatedAt(time(updatedAt, lang))}
          {lang === "ko" && fx && ` · ${t.fx(rate(fx), fx.day)}`}
        </p>
      ) : (
        <p className="text-[13px] text-sub">{t.noData}</p>
      )}
    </div>
  );
}
