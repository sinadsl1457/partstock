// /ko/gpu: 오른쪽에 목록 첫 종목(종목 주소는 [...key]/page.tsx).
import { Suspense } from "react";
import { TickerPanel } from "@/components/ticker-panel";

export default function CategoryPage({ params }: PageProps<"/[lang]/[category]">) {
  return (
    <Suspense fallback={<section className="h-[720px] rounded-xl border border-line bg-surface" />}>
      <TickerPanel params={params} />
    </Suspense>
  );
}
