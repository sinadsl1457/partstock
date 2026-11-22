// 모든 화면 위 머리: 이름, 설명, 바로가기 기본값, 언어 바꾸기.
import Link from "next/link";
import { Suspense } from "react";
import { dict, type Locale } from "@/lib/i18n";
import { JumpSelect } from "./jump";
import { LangSwitch } from "./lang-switch";

/** 칩 로고(앱 아이콘과 같은 모양) */
function ChipLogo() {
  return (
    <svg width="26" height="26" viewBox="0 0 28 28" aria-hidden="true" className="self-center">
      <rect x="6" y="6" width="16" height="16" rx="3" fill="none" stroke="#7ee04b" strokeWidth="1.8" />
      <rect x="10.5" y="10.5" width="7" height="7" rx="1" fill="#7ee04b" />
      <path
        d="M10 1.5v4.5M14 1.5v4.5M18 1.5v4.5M10 22v4.5M14 22v4.5M18 22v4.5M1.5 10h4.5M1.5 14h4.5M1.5 18h4.5M22 10h4.5M22 14h4.5M22 18h4.5"
        stroke="#7ee04b"
        strokeWidth="1.6"
        strokeLinecap="round"
      />
    </svg>
  );
}

export function Header({ locale }: { locale: Locale }) {
  const t = dict(locale);
  return (
    <header className="border-b border-line bg-bg">
      <div className="mx-auto flex max-w-[1200px] flex-wrap items-center justify-between gap-4 px-6 py-4">
        <div className="flex flex-wrap items-baseline gap-3">
          <Link href={`/${locale}/gpu`} className="flex items-center gap-2 text-[22px] font-bold tracking-tight text-ink no-underline">
            <ChipLogo />
            <span>
              part<span className="text-accent">stock</span>
            </span>
          </Link>
          <span className="text-sm text-sub">{t.tagline}</span>
        </div>
        <div className="flex flex-wrap items-center gap-2">
          <JumpSelect label={t.jumpDefault} ebay={t.ebay} danawa={t.danawa} />
          {/* 지금 주소를 읽는 부분이라 화면 틀이 먼저 나가고 뒤에 채워지게 */}
          <Suspense fallback={<span className="inline-block h-10 w-[104px] rounded-lg border border-line-hi" />}>
            <LangSwitch locale={locale} />
          </Suspense>
        </div>
      </div>
    </header>
  );
}
