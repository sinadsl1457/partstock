"use client";
// 같은 화면의 다른 언어 주소로 이동(/ko/... ↔ /en/...).
import Link from "next/link";
import { usePathname } from "next/navigation";
import type { Locale } from "@/lib/i18n";

export function LangSwitch({ locale }: { locale: Locale }) {
  const path = usePathname() ?? `/${locale}`;
  const swap = (to: Locale) => path.replace(/^\/(ko|en)(?=\/|$)/, `/${to}`);
  const item = (to: Locale, label: string) => (
    <Link
      href={swap(to)}
      aria-current={to === locale ? "page" : undefined}
      className={`inline-flex min-h-10 items-center px-3 text-[13px] no-underline ${
        to === locale ? "bg-gray-900 text-white" : "bg-white text-gray-700 hover:bg-gray-50"
      }`}
    >
      {label}
    </Link>
  );
  return (
    <span className="inline-flex overflow-hidden rounded-lg border border-gray-300">
      {item("ko", "한국어")}
      {item("en", "EN")}
    </span>
  );
}
