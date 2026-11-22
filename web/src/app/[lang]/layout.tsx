// 맨 바깥 틀. 언어(/ko, /en)마다 html lang과 머리가 바뀐다.
import type { Metadata } from "next";
import { Inter, Noto_Sans_KR } from "next/font/google";
import { notFound } from "next/navigation";
import { Header } from "@/components/header";
import { isLocale, locales } from "@/lib/i18n";
import "../globals.css";

const inter = Inter({ subsets: ["latin"], variable: "--font-inter" });
const notoKr = Noto_Sans_KR({ subsets: ["latin"], weight: ["400", "500", "700"], variable: "--font-noto-kr" });

export const metadata: Metadata = {
  title: "partstock",
  description: "그래픽카드·램 시세판 (eBay 새 상품 기준)",
};

export function generateStaticParams() {
  return locales.map((lang) => ({ lang }));
}

export default async function LangLayout({ children, params }: LayoutProps<"/[lang]">) {
  const { lang } = await params;
  if (!isLocale(lang)) notFound();
  return (
    <html lang={lang} className={`${inter.variable} ${notoKr.variable}`}>
      <body className="min-h-screen font-sans antialiased">
        <Header locale={lang} />
        {children}
      </body>
    </html>
  );
}
