// 모든 화면 위 머리: 이름, 설명, 바로가기 기본값, 언어 바꾸기.
import Link from "next/link";
import { Suspense } from "react";
import { dict, type Locale } from "@/lib/i18n";
import { JumpSelect } from "./jump";
import { LangSwitch } from "./lang-switch";

export function Header({ locale }: { locale: Locale }) {
  const t = dict(locale);
  return (
    <header className="border-b border-gray-200 bg-white">
      <div className="mx-auto flex max-w-[1200px] flex-wrap items-center justify-between gap-4 px-6 py-4">
        <div className="flex flex-wrap items-baseline gap-3">
          <Link href={`/${locale}/gpu`} className="text-[22px] font-bold tracking-tight text-gray-900 no-underline">
            partstock
          </Link>
          <span className="text-sm text-gray-600">{t.tagline}</span>
        </div>
        <div className="flex flex-wrap items-center gap-2">
          <JumpSelect label={t.jumpDefault} ebay={t.ebay} danawa={t.danawa} />
          {/* 지금 주소를 읽는 부분이라 화면 틀이 먼저 나가고 뒤에 채워지게 */}
          <Suspense fallback={<span className="inline-block h-10 w-[104px] rounded-lg border border-gray-300" />}>
            <LangSwitch locale={locale} />
          </Suspense>
        </div>
      </div>
    </header>
  );
}
