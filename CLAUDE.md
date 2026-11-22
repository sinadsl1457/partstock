# partstock — GPU·RAM 시세판 (Spring Boot 서버 + Next.js 웹 + Flutter 앱)

eBay 판매 가격으로 그래픽카드·램 시세를 증권 시세판처럼 보여 주는 서비스.
칩셋(지수) → 제조사 → 모델 단위로 일·주·월·년 차트를 보고, eBay(기본) 또는 다나와로 넘어가 실제 상품을 본다.
개인 포트폴리오. NowStation(실시간 데이터·센서)과 겹치지 않게 "수집 → 정제 → 시계열 집계 → 시세판"을 보여 준다.

## 진행 방식
- 단계: 1 수집 서버(eBay → 하루 시세 저장) → 수집 서버 먼저 배포(차트는 쌓인 날부터라서, 11/22 결정) → 2 시세 API + 웹 → 3 Flutter 앱 → 4 웹·앱 배포.
- 단계가 끝나면 멈추고 결과 요약 + 확인 방법을 보고한다. 승인 후 다음 단계.
- 1단계에서 데이터 품질(칩셋·제조사·모델별 하루 판매 글 수, 가격 흩어짐)을 먼저 숫자로 확인한다. 쓸 만하지 않으면 데이터 출처를 바꾼다.
- 유료 서비스·결제, 스택 변경은 먼저 묻는다. 데이터 비용 상한은 월 1만 원.
- 커밋은 기능 단위로 작게, 자연스러운 한국어로. AI 흔적이 드러나는 표현·`Co-Authored-By` 줄은 쓰지 않는다. squash·amend·force push 금지.
- 키·비밀값은 커밋하지 않는다(`.env`, `application-local.properties`).
- AI가 틀렸거나 방향을 바꾼 지점은 `docs/AI_LOG.md`에 바로 적는다.

## 구조
```
server/   Spring Boot 4.2, Java 25, Gradle(Kotlin DSL), PostgreSQL 18
web/      Next.js 16 + Tailwind + Lightweight Charts
app/      Flutter (3단계)
docs/     AI_LOG.md
```

## 데이터 규칙 (eBay 약관)
- eBay Browse API(EBAY_US)만 쓴다. 다나와·PCPartPicker 등은 긁어 오지 않는다(다나와 robots.txt가 가격 경로를 막음).
- **저장하는 것은 종목별 하루 시세 숫자(중앙값·최저·최고·판매 글 수)뿐.** 판매 글 제목·사진·글 번호·판매자 등 원본과 개인정보는 계산 뒤 버리고 저장하지 않는다.
- 화면에는 출처(eBay)를 밝히고 eBay로 가는 링크를 둔다.
- 새 상품·즉시 구매(FIXED_PRICE)만 센다. 같은 제목·같은 가격 글은 한 번만 센다(한 판매자의 중복 등록). 이상값(IQR 1.5배 밖)은 버린다.
- **대표 가격은 하위 25%(p25)**, 중앙값은 보조로 보여 준다. 시세보다 몇 배 비싸게 걸어 두고 안 팔리는 글이 중앙값을 끌어올리기 때문(11/21 실측, 램에서 심함). 둘 다 저장한다.
- 판매 글이 5개 미만인 종목·날은 시세를 비우고 화면에 "글 부족"으로 표시한다. 칩셋·제조사는 대부분 넘고, 모델은 일부만 넘는다(11/21 실측: 칩셋 14~755개, 모델은 칩셋당 0~10개 종목만 5개 이상).
- 램은 같은 용량에 속도(4800~8000MHz)가 섞여 흔들림이 크다(p25~p75 폭 40~80%). 지금은 추세용으로 그대로 두고, 필요하면 속도 구간을 한 단계 더 둔다.
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

## 시세 API (server/api)
- `GET /api/board?category=GPU|RAM`, `GET /api/ticker?key=<칩셋/제조사/모델>&period=day|week|month|year`. 종목 키에 `/`가 들어가 경로 대신 파라미터.
- 가격은 USD 센트 정수만 준다. 원화는 화면이 `fx.usdKrw`(그날 또는 그 전 가장 가까운 고시)를 곱한다.
- 화면 글자는 주지 않는다(vendor도 `NVIDIA|AMD|DESKTOP` 코드). 번역은 웹·앱이 한다.
- eBay·다나와 링크는 서버에서 만든다(웹·앱이 같은 주소를 쓰게).
- 봉 = 그 기간 하루 대표가(p25)의 처음·최고·최저·마지막(`date_trunc`, 주는 월요일 시작). 일은 봉 대신 최근 30일 점.

## 웹 (web/)
- Next.js 16(App Router, `cacheComponents` 켜짐) + Tailwind + Lightweight Charts(TradingView, 로고는 라이선스 표시라 끄지 않음).
- 코드를 쓰기 전에 `web/node_modules/next/dist/docs/`의 해당 문서를 본다(AGENTS.md).
- 주소: `/[lang]/[category]` 시세판, `/[lang]/t/[...key]` 상세. 언어 없는 주소는 `proxy.ts`가 브라우저 언어로 보낸다.
- 주소(params)·`usePathname`을 읽는 부분은 `<Suspense>` 안에. 서버 → 클라이언트 컴포넌트로 함수를 넘기지 않는다(글자를 만들어 넘김).
- API 호출은 `lib/api.ts`에서만(`use cache` + `cacheLife('hours')`, 시세는 하루 한 번 바뀜). 상세는 네 기간을 한 번에 받아 기간 버튼이 기다리지 않게.
- 차트는 점이 2개 미만이면 그리지 않고 "쌓이는 중" 안내. 원화 차트는 지금 환율 하나로 바꿔 그린다(환율 변동이 섞이지 않게).
- 바로가기 기본값은 브라우저 localStorage(실패해도 eBay 기본). 상승·하락 색은 언어별(한국 빨강↑파랑↓, 영어 초록↑빨강↓).
- 커밋 전: `npm run lint`, `npx tsc --noEmit`, `npm run build`. 화면을 바꾸면 브라우저 콘솔·개발 서버 로그 에러까지 확인.

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

## 배포 (수집 서버)
- AWS EC2 새 t3.micro 한 대(NowStation과 분리, 11/22 결정). Docker compose로 PostgreSQL + 서버(`deploy/compose.prod.yaml`), 값은 EC2 `~/partstock/.env`.
- 지금은 맥에서 `deploy/deploy.sh <IP>`로 이미지를 만들어 보낸다(CI 전 임시).
- 밖에서는 Caddy(80·443)만 보인다: `https://<IP를 -로 이은>.sslip.io/api/*`만 서버로 넘김(`deploy/Caddyfile`). 서버·DB 포트는 compose 안 네트워크에만.
- EC2는 시드니(ap-southeast-2). 웹(Vercel)도 `syd1`에서 돌려 API와 가깝게(`web/vercel.json`).
- 메모리: JVM `-Xmx256m`(실측 약 370MB), PostgreSQL `shared_buffers=32MB`(약 26MB), 스왑 2GB.
- **시세 기록은 다시 받을 수 없다**(eBay는 지금 올라온 글만 줌). 매일 04:00 UTC `pg_dump` 14일치(`deploy/backup.sh` + systemd 타이머). 하루 약 17KB.
- 켜질 때 그날 수집 기록이 없으면 바로 수집한다(`partstock.collect.on-start`).
