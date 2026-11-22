"use client";
// 바로가기 기본값(eBay / 다나와). 브라우저에 기억하고, 바꾸면 화면의 모든 바로가기 버튼 순서가 바뀐다.
import { useSyncExternalStore } from "react";
import type { Links } from "@/lib/api";

type Jump = "ebay" | "danawa";
const KEY = "partstock.jump";
const EVENT = "partstock-jump";

function read(): Jump {
  try {
    return localStorage.getItem(KEY) === "danawa" ? "danawa" : "ebay";
  } catch {
    return "ebay"; // 사생활 보호 모드 등에서 저장소를 못 쓰면 기본값
  }
}

function subscribe(onChange: () => void) {
  window.addEventListener(EVENT, onChange);
  window.addEventListener("storage", onChange);
  return () => {
    window.removeEventListener(EVENT, onChange);
    window.removeEventListener("storage", onChange);
  };
}

function useJump(): Jump {
  return useSyncExternalStore(subscribe, read, () => "ebay");
}

export function JumpSelect({ label, ebay, danawa }: { label: string; ebay: string; danawa: string }) {
  const jump = useJump();
  return (
    <label className="flex items-center gap-2 text-sm text-sub">
      {label}
      <select
        value={jump}
        onChange={(e) => {
          try {
            localStorage.setItem(KEY, e.target.value);
          } catch {}
          window.dispatchEvent(new Event(EVENT));
        }}
        className="min-h-10 rounded-lg border border-line-hi bg-surface px-3 text-sm text-ink"
      >
        <option value="ebay">{ebay}</option>
        <option value="danawa">{danawa}</option>
      </select>
    </label>
  );
}

/** 기본으로 고른 쪽이 앞(진한 버튼). size: 표 안은 작게, 상세 머리는 크게 */
export function JumpButtons({
  links,
  ebay,
  danawa,
  size = "sm",
}: {
  links: Links;
  ebay: string;
  danawa: string;
  size?: "sm" | "lg";
}) {
  const jump = useJump();
  const items = [
    { id: "ebay" as const, href: links.ebay, label: ebay },
    { id: "danawa" as const, href: links.danawa, label: danawa },
  ].sort((a) => (a.id === jump ? -1 : 1));
  const base = size === "lg" ? "min-h-11 px-5 text-[15px] font-semibold rounded-xl" : "px-3 py-2 text-[13px] rounded-lg";
  return (
    <span className="inline-flex flex-wrap gap-1.5">
      {items.map((it, i) => (
        <a
          key={it.id}
          href={it.href}
          target="_blank"
          rel="noopener noreferrer"
          className={`${base} inline-flex items-center whitespace-nowrap no-underline ${
            i === 0 ? "bg-accent font-semibold text-on-accent hover:brightness-110" : "border border-line-hi text-ink hover:bg-surface-hi"
          }`}
        >
          {it.label}
        </a>
      ))}
    </span>
  );
}
