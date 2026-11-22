// 맨 바깥 틀. 언어(/ko, /en)마다 html lang과 머리가 바뀐다.
import type { Metadata } from "next";
import { Noto_Sans_KR, Space_Grotesk } from "next/font/google";
import { notFound } from "next/navigation";
import { Header } from "@/components/header";
import { isLocale, locales } from "@/lib/i18n";
import "../globals.css";

const grotesk = Space_Grotesk({ subsets: ["latin"], variable: "--font-grotesk" });
const notoKr = Noto_Sans_KR({ subsets: ["latin"], weight: ["400", "500", "700"], variable: "--font-noto-kr" });

export const metadata: Metadata = {
  title: "partstock",
  description: "VGA·RAM·CPU 시세판 (eBay 새 상품 기준)",
};

export function generateStaticParams() {
  return locales.map((lang) => ({ lang }));
}

export default async function LangLayout({ children, params }: LayoutProps<"/[lang]">) {
  const { lang } = await params;
  if (!isLocale(lang)) notFound();
  return (
    <html lang={lang} className={`${grotesk.variable} ${notoKr.variable}`}>
      <body className="min-h-screen font-sans antialiased">
        <Header locale={lang} />
        {children}
      </body>
    </html>
  );
}
