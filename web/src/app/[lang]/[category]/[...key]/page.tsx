// /ko/gpu/rtx-5070-ti, /ko/gpu/rtx-5070-ti/msi/gaming-trio: 주소의 종목.
import { Suspense } from "react";
import { TickerPanel } from "@/components/ticker-panel";

export default function TickerPage({ params }: PageProps<"/[lang]/[category]/[...key]">) {
  return (
    <Suspense fallback={<section className="h-[720px] rounded-xl border border-line bg-surface" />}>
      <TickerPanel params={params} />
    </Suspense>
  );
}
