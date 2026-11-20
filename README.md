# partstock

eBay 판매 가격으로 그래픽카드·램 시세를 증권 시세판처럼 보여 주는 서비스(개발 중).

- 1단계: 수집 서버 (진행 중) — eBay 판매 글 → 칩셋·제조사·모델 종목 가르기 → 하루 시세(이상값 제외 중앙값) 저장, 원/달러 환율 수집

## 실행 (서버)
```bash
cd server
./gradlew test       # Docker 필요(테스트용 PostgreSQL)
cp src/main/resources/application-local.properties.example src/main/resources/application-local.properties  # eBay 키 입력
./gradlew bootRun --args='--spring.profiles.active=local'
```
