# partstock — GPU·RAM 시세판 (Spring Boot 서버 + Next.js 웹 + Flutter 앱)

eBay 판매 가격으로 그래픽카드·램 시세를 증권 시세판처럼 보여 주는 서비스.
칩셋(지수) → 제조사 → 모델 단위로 일·주·월·년 차트를 보고, eBay(기본) 또는 다나와로 넘어가 실제 상품을 본다.
개인 포트폴리오. NowStation(실시간 데이터·센서)과 겹치지 않게 "수집 → 정제 → 시계열 집계 → 시세판"을 보여 준다.

## 진행 방식
- 단계: 1 수집 서버(eBay → 하루 시세 저장) → 2 시세 API + 웹 → 3 Flutter 앱 → 4 AWS 배포.
- 단계가 끝나면 멈추고 결과 요약 + 확인 방법을 보고한다. 승인 후 다음 단계.
- 1단계에서 데이터 품질(칩셋·제조사·모델별 하루 판매 글 수, 가격 흩어짐)을 먼저 숫자로 확인한다. 쓸 만하지 않으면 데이터 출처를 바꾼다.
- 유료 서비스·결제, 스택 변경은 먼저 묻는다. 데이터 비용 상한은 월 1만 원.
- 커밋은 기능 단위로 작게, 자연스러운 한국어로. AI 흔적이 드러나는 표현·`Co-Authored-By` 줄은 쓰지 않는다. squash·amend·force push 금지.
- 키·비밀값은 커밋하지 않는다(`.env`, `application-local.properties`).
- AI가 틀렸거나 방향을 바꾼 지점은 `docs/AI_LOG.md`에 바로 적는다.

## 구조
```
server/   Spring Boot 4.2, Java 25, Gradle(Kotlin DSL), PostgreSQL 18
web/      Next.js (2단계)
app/      Flutter (3단계)
docs/     AI_LOG.md
```

## 데이터 규칙 (eBay 약관)
- eBay Browse API(EBAY_US)만 쓴다. 다나와·PCPartPicker 등은 긁어 오지 않는다(다나와 robots.txt가 가격 경로를 막음).
- **저장하는 것은 종목별 하루 시세 숫자(중앙값·최저·최고·판매 글 수)뿐.** 판매 글 제목·사진·글 번호·판매자 등 원본과 개인정보는 계산 뒤 버리고 저장하지 않는다.
- 화면에는 출처(eBay)를 밝히고 eBay로 가는 링크를 둔다.
- 새 상품·즉시 구매(FIXED_PRICE)만 센다. 이상값은 버리고 중앙값을 시세로 쓴다. 판매 글이 너무 적은 날은 시세를 비워 둔다(기준은 1단계 실측으로 정함).
- 시세는 하루 1번 수집(부품 가격은 하루 단위면 충분). "실시간"처럼 꾸미지 않는다.
- 원화 환산은 유럽중앙은행 기준 환율(Frankfurter API, 키 없음)을 `fx_rate`에 날마다 쌓아 쓴다. 주말·휴일은 직전 고시값.

## 종목 구조
- 칩셋(예: RTX 5070 Ti, DDR5 32GB) → 제조사(MSI, ASUS…) → 모델(Gaming Trio OC…).
- 칩셋·제조사 시세는 아래 단계 판매 글을 합쳐서 계산한다(모델 시세의 평균이 아님).
- 수집: eBay 검색은 **칩셋마다 한 번**. 받은 글 제목으로 제조사·모델을 가른다(`catalog/ListingClassifier`). 호출이 적고, 세 단계 시세가 같은 글 묶음에서 나와 어긋나지 않는다.
  - 종목 정의(칩셋·제조사·시리즈·제외어)는 코드(`catalog/Catalog`)에 둔다. 사람이 고치는 값(다나와 pcode)만 DB.
  - 제목이 검색한 칩셋 하나만 가리킬 때만 센다. 제조사가 둘 이상 걸리거나 못 찾으면 칩셋에만 센다.
  - 램 종목은 세대 + 2개 묶음 구성(2×16GB 등). 1개·4개 묶음, 노트북용(SODIMM), 서버용(ECC)은 뺀다.
  - 제목 판정 규칙을 고치면 `ListingClassifierTest`에 실제 제목 사례를 추가한다.
- 다나와 연결: 모델 이름 검색 링크. 인기 모델은 다나와 상품 번호(pcode)를 사람이 손으로 적어 상품 페이지로 보낸다.

## 화면 (2·3단계)
- 영어·한국어. 영어는 달러, 한국어는 원화(공식 환율 환산) 크게 + 달러 작게.
- 바로가기 기본값 eBay, 설정에서 다나와로 바꿀 수 있다.

## 서버 (server/)
- 실행: `./gradlew bootRun`(Docker로 로컬 PostgreSQL이 자동으로 켜짐). 테스트: `./gradlew test`(Testcontainers).
- DB 테이블은 Flyway 마이그레이션 파일로만 바꾼다. 이미 커밋한 마이그레이션은 고치지 않는다.
- 시간은 `Clock` 빈을 주입받는다(`LocalDate.now()` 직접 호출 금지). 하루의 기준은 UTC.
- eBay 키는 `server/src/main/resources/application-local.properties`(커밋 안 함), `local` 프로필로 실행.
- 패키지: `catalog`(종목 정의·제목 가르기, 순수 Java), `price`(시세 계산·저장), `collect`(매일 수집·점검 도구), `ebay`(판매 글 출처), `fx`(환율), `ticker`(종목 표).
  - 판매 글 출처는 `collect.ListingSource` 인터페이스 뒤에 둔다(eBay 데이터가 나쁘면 바꿔 끼우려고).
- 데이터 품질 점검(저장 안 함): `./gradlew bootRun --args='--spring.profiles.active=local,probe --partstock.probe.chipsets=rtx-5070-ti'`
- eBay 응답 예시(`src/test/resources/ebay`)는 지금 문서 기준 가짜다. 키를 받으면 실제 응답으로 바꾸고 파서를 맞춘다.
