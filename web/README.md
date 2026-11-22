# partstock 웹 (Next.js)

전체 설명·화면·실행 방법은 [루트 README](../README.md).

주소: `/ko/gpu`(분류 첫 화면) · `/ko/gpu/rtx-5070-ti/msi`(종목). 분류는 gpu·ram·cpu·ssd, 언어는 ko·en.

```bash
npm install
PARTSTOCK_API_URL=http://localhost:8080 npm run dev
npm run lint && npx tsc --noEmit && npm run build
```
