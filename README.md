# partstock

eBay 판매 가격으로 그래픽카드·램 시세를 증권 시세판처럼 보여 주는 서비스(개발 중).

- 웹: https://partstock-two.vercel.app (한국어 /ko, 영어 /en)
- API: https://32-236-106-139.sslip.io/api/board?category=GPU
- 수집 시작 2026-11-22, 매일 한국 시간 낮 12시 갱신

- 1단계: 수집 서버 (완료) — eBay 판매 글 → 칩셋·제조사·모델 종목 가르기 → 하루 시세(이상값 제외, 대표가 = 하위 25%) 저장, 원/달러 환율 수집
- 2단계: 시세 API + 웹 (완료) — 시세판, 종목 상세(일·주·월·년 차트, 제조사·모델), eBay/다나와 바로가기, 한국어/영어

## 실행 (서버)
```bash
cd server
./gradlew test       # Docker 필요(테스트용 PostgreSQL)
cp src/main/resources/application-local.properties.example src/main/resources/application-local.properties  # eBay 키 입력
./gradlew bootRun --args='--spring.profiles.active=local'
```
