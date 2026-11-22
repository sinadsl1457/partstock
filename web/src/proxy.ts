// 언어가 없는 주소(/, /gpu …)로 오면 브라우저 언어를 보고 /ko 또는 /en을 붙여 보낸다.
import { NextResponse, type NextRequest } from "next/server";

const locales = ["ko", "en"];

function pick(request: NextRequest): string {
  const accept = request.headers.get("accept-language") ?? "";
  return accept.toLowerCase().startsWith("ko") || /(^|,)\s*ko/.test(accept.toLowerCase()) ? "ko" : "en";
}

export function proxy(request: NextRequest) {
  const { pathname } = request.nextUrl;
  if (locales.some((l) => pathname === `/${l}` || pathname.startsWith(`/${l}/`))) return;
  request.nextUrl.pathname = `/${pick(request)}${pathname === "/" ? "" : pathname}`;
  return NextResponse.redirect(request.nextUrl);
}

export const config = {
  matcher: ["/((?!_next|favicon.ico|.*\\..*).*)"],
};
