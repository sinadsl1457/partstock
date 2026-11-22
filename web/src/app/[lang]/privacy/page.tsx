// 개인정보 처리방침(Play 스토어 제출에 필요). 앱·서버가 실제로 저장하는 것만 적는다(server V4 마이그레이션 기준).
// /ko/privacy, /en/privacy. [category]보다 이 고정 경로가 먼저 맞는다.
import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { isLocale } from "@/lib/i18n";

export const metadata: Metadata = { title: "partstock · 개인정보 처리방침 / Privacy" };

const ko = {
  title: "개인정보 처리방침",
  updated: "시행일 2026년 11월 22일",
  sections: [
    ["모으지 않는 것", "partstock은 회원 가입이 없고 이름·이메일·전화번호·위치·연락처를 모으지 않습니다. 광고·분석 도구도 쓰지 않습니다."],
    [
      "목표가 알림을 켤 때 서버에 저장하는 것",
      "알림을 보내기 위한 기기 알림 토큰(Firebase Cloud Messaging), 기기 종류(Android/iOS), 알림 글자 언어, 그리고 사용자가 건 목표가 조건(종목, 이하/이상, 목표 가격, 울린 시각). 이 정보는 알림을 보내는 데만 씁니다.",
    ],
    [
      "지우는 방법",
      "앱에서 알림을 지우면 그 조건이 서버에서 지워집니다. 앱을 지우면 토큰이 무효가 되고, 다음 알림 확인 때 서버가 그 기기와 조건을 지웁니다.",
    ],
    ["기기에만 저장하는 것", "관심 종목, 바로가기 기본값(eBay/다나와), 시세판 필터, 마지막으로 받은 시세는 휴대폰 안에만 저장하며 서버로 보내지 않습니다."],
    ["다른 곳에 주는 것", "알림을 보내려고 Google의 Firebase Cloud Messaging에 토큰과 알림 내용을 전달합니다. 그 밖에 제3자에게 주거나 팔지 않습니다."],
    ["가격 정보", "시세는 eBay 공개 판매 글을 모아 계산한 통계이며, 판매 글 원본이나 판매자 정보는 저장하지 않습니다."],
    ["문의", "Google Play 스토어의 개발자 연락처로 문의해 주세요."],
  ],
};

const en: typeof ko = {
  title: "Privacy Policy",
  updated: "Effective November 22, 2026",
  sections: [
    ["What we don't collect", "partstock has no accounts and does not collect names, emails, phone numbers, location, or contacts. No ads or analytics SDKs."],
    [
      "What the server stores when you turn on price alerts",
      "Your device's push token (Firebase Cloud Messaging), device type (Android/iOS), notification language, and the alert you set (item, below/above, target price, when it fired). Used only to send that alert.",
    ],
    [
      "Deleting it",
      "Deleting an alert in the app removes it from the server. If you uninstall the app the token becomes invalid and the server deletes the device and its alerts at the next check.",
    ],
    ["Stored only on your device", "Your watchlist, default store link (eBay/Danawa), board filters and the last loaded prices stay on your phone and are not sent to the server."],
    ["Sharing", "To deliver notifications, the token and alert text are passed to Google Firebase Cloud Messaging. Nothing is shared with or sold to anyone else."],
    ["Price data", "Prices are statistics computed from public eBay listings. Listing details and seller information are not stored."],
    ["Contact", "Please use the developer contact on the Google Play listing."],
  ],
};

export default async function PrivacyPage({ params }: PageProps<"/[lang]/privacy">) {
  const { lang } = await params;
  if (!isLocale(lang)) notFound();
  const t = lang === "ko" ? ko : en;
  return (
    <main className="mx-auto flex max-w-[760px] flex-col gap-6 px-4 py-8 lg:px-6">
      <div>
        <h1 className="text-2xl font-bold tracking-tight">{t.title}</h1>
        <p className="mt-1 text-sm text-muted">{t.updated}</p>
      </div>
      {t.sections.map(([h, body]) => (
        <section key={h} className="rounded-xl border border-line bg-surface p-5">
          <h2 className="mb-2 text-base font-bold">{h}</h2>
          <p className="text-[15px] leading-relaxed text-sub">{body}</p>
        </section>
      ))}
    </main>
  );
}
