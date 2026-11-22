// 맨 바깥 틀. 언어(/ko, /en)마다 html lang과 머리가 바뀐다.
import type { Metadata } from "next";
import { Noto_Sans_KR, Space_Grotesk } from "next/font/google";
import { notFound } from "next/navigation";
import { Header } from "@/components/header";
import { isLocale, locales } from "@/lib/i18n";
import "../globals.css";

const grotesk = Space_Grotesk({ subsets: ["latin"], variable: "--font-grotesk" });
const notoKr = Noto_Sans_KR({ subsets: ["latin"], weight: ["400", "500", "700"], variable: "--font-noto-kr" });

// 한국어 이름 파츠스톡(11/22 사용자 결정), 영어 partstock
export async function generateMetadata({ params }: LayoutProps<"/[lang]">): Promise<Metadata> {
  const { lang } = await params;
  return lang === "ko"
    ? { title: "파츠스톡 · PC 부품 시세", description: "VGA·RAM·CPU·SSD 시세를 주식처럼. 미국 eBay 새 상품 기준, 매시간 갱신." }
    : { title: "partstock · PC part prices", description: "GPU, RAM, CPU and SSD prices like a stock ticker. New eBay US listings, updated hourly." };
}

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
