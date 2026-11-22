// 주소 조각(/[lang]/[category]) 검사. 틀린 주소면 404.
import { notFound } from "next/navigation";
import { isLocale, type Locale } from "./i18n";

export const categories = ["gpu", "ram"] as const;
export type Cat = (typeof categories)[number];

export function checkParams(lang: string, category: string): { lang: Locale; category: Cat } {
  if (!isLocale(lang) || !(categories as readonly string[]).includes(category)) notFound();
  return { lang, category: category as Cat };
}
