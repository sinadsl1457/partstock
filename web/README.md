# partstock 웹 (Next.js)

시세판(`/ko/gpu`, `/ko/ram`)과 종목 상세(`/ko/t/rtx-5070-ti`). 데이터는 server의 시세 API에서 받는다.

```bash
cp .env.example .env.local      # PARTSTOCK_API_URL (기본 http://localhost:8080)
npm install
npm run dev                     # http://localhost:3000 → /ko 또는 /en
npm run lint && npx tsc --noEmit && npm run build
```
