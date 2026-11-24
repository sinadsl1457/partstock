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
app/      Flutter 3.47 + Cubit
docs/     AI_LOG.md
```

## 데이터 규칙 (eBay 약관)
- eBay Browse API(EBAY_US)만 쓴다. 다나와·PCPartPicker 등은 긁어 오지 않는다(다나와 robots.txt가 가격 경로를 막음).
- **저장하는 것은 종목별 하루 시세 숫자(중앙값·최저·최고·판매 글 수)뿐.** 판매 글 제목·사진·글 번호·판매자 등 원본과 개인정보는 계산 뒤 버리고 저장하지 않는다.
- 화면에는 출처(eBay)를 밝히고 eBay로 가는 링크를 둔다.
- 새 상품·즉시 구매(FIXED_PRICE)만 센다. **같은 판매자 + 같은 가격 글은 한 번만** 센다(11/22: 한 판매자가 DDR4 32GB를 제목만 바꿔 $344.95에 197개 올려 시세가 그 값이 됐음). 판매자 이름은 되돌릴 수 없는 값(SHA-256 앞 12자리)으로만 계산 중에 쓰고 저장·기록하지 않는다. 판매자를 모르면 같은 제목 + 같은 가격만 합친다. 이상값(IQR 1.5배 밖)은 버린다.
- **대표 가격(price_cents)은 글 20개 이상이면 하위 10%, 적으면 하위 25%**(`PriceStats`), 중앙값은 보조. 비싸게 걸어 두고 안 팔리는 글이 위에 쌓여 p25도 실거래보다 높았다(11/23, 9700X 38.6만 vs eBay 최저 29.5·다나와 32). 글이 적으면 p10은 싼 글 한두 개라(4090 -47%) 25%. p25·중앙값·p75도 그대로 저장한다. V7 이전 기록은 p25로 채워져 있어 차트에 한 번 계단이 있다.
- **사용자가 확인했을 때 맞아야 한다.** eBay 바로가기는 우리가 센 것과 같은 조건(미국 상품·미국 배송·새 상품·즉시 구매)에 가격 낮은순(`_sop=15`). 한국에서 열면 eBay가 한국 배송 가능 글(대부분 중국 판매자)만 보여 줘서 고정했다.
- 한국 가격: 네이버 쇼핑 검색 API는 2026-07-31 종료(대체 없음), 그 전에도 약관이 저장·가공을 금지했다. 다나와는 크롤링 금지 → 링크만.
- 판매 글이 5개 미만인 종목·날은 시세를 비우고 화면에 "데이터 없음"(영어 No data)으로 표시한다(11/22 사용자 결정: "글 부족" 말고). 칩셋·제조사는 대부분 넘고, 모델은 일부만 넘는다(11/21 실측: 칩셋 14~755개, 모델은 칩셋당 0~10개 종목만 5개 이상).
- 램은 같은 용량에 속도(4800~8000MHz)가 섞여 흔들림이 크다(p25~p75 폭 40~80%). 지금은 추세용으로 그대로 두고, 필요하면 속도 구간을 한 단계 더 둔다.
- 시세는 **매시간** 수집(11/22 변경: 하루 1번이면 차트가 일주일 넘게 비어 사용자가 원한 "주식·코인처럼 누르면 그래프"가 안 됨). 한 번에 eBay 약 60번 → 하루 약 1,400번(무료 5,000). 실제로 받은 값만 쓰고 꾸미지 않는다.
  - `price_snapshot` = 매시간 시세(차트·24시간 변동), `daily_price` = 그날 가장 최근 값(현재가).
- 원화 환산은 유럽중앙은행 기준 환율(Frankfurter API, 키 없음)을 `fx_rate`에 날마다 쌓아 쓴다. 주말·휴일은 직전 고시값.

## 종목 구조
- 칩셋(예: RTX 5070 Ti, DDR5 32GB) → 제조사(MSI, ASUS…) → 모델(Gaming Trio OC…).
- 칩셋·제조사 시세는 아래 단계 판매 글을 합쳐서 계산한다(모델 시세의 평균이 아님).
- 수집: eBay 검색은 **칩셋마다 한 번**. 받은 글 제목으로 제조사·모델을 가른다(`catalog/ListingClassifier`). 호출이 적고, 세 단계 시세가 같은 글 묶음에서 나와 어긋나지 않는다.
  - 종목 정의(칩셋·제조사·시리즈·제외어)는 코드(`catalog/Catalog`)에 둔다. 사람이 고치는 값(다나와 pcode)만 DB.
  - 제목이 검색한 칩셋 하나만 가리킬 때만 센다. 제조사가 둘 이상 걸리거나 못 찾으면 칩셋에만 센다.
  - CPU(11/22 사용자 결정): Ryzen 9000·7000, Core Ultra 200S, Core 14·13세대 24종목. 칩 = 제품이라 제조사·모델 단계 없음. 메인보드 묶음(COMBO·BUNDLE)·엔지니어링 샘플(ES·QS) 제외. 13세대처럼 새 상품이 드문 종목도 "데이터 없음"으로 둔다(사용자: 인기 없는 매물이라 이해함). 필터: 브랜드·시리즈.
  - SSD(11/22 사용자 결정): 인기 14모델 × 용량 36종목. **종목 = 모델 + 용량**(용량마다 값이 달라 한 종목으로 묶지 않음, 검색도 종목마다). "2000GB"도 2TB, 한 글에 여러 용량을 적은 것·외장·묶음(LOT)은 제외, 브랜드 이름이 없는 제목도 제외. 목록 vendor는 규격(NVMe Gen5·Gen4·SATA). 필터: 용량·규격·브랜드. 목록 이름은 두 줄까지(용량이 잘리지 않게).
  - 배포 순서: 새 분류는 **서버 먼저** 배포한다. 웹은 빌드 때 목록을 미리 받아서, 서버에 없는 분류면 Vercel 빌드가 실패한다.
  - 그래픽카드는 RTX 50·40, RX 9000·7000까지(11/22 사용자 결정: 40 시리즈까지, AMD는 같은 세대). 40 시리즈는 새 상품 글이 적어(11/22 점검: 종목당 1~18개) "데이터 없음"인 시각이 잦다.
  - 램 종목은 세대 + 용량. **1개짜리가 기본**(한국은 1개 단위 판매가 흔함, 11/22 사용자 결정), 2개 묶음(2×16GB 등)은 필터로 본다. 키: 1개 `ddr5-16gb`, 2개 묶음 `ddr5-2x8gb`(V5에서 옛 묶음 키 ddr5-16gb → ddr5-2x8gb로 옮김). 4개 묶음, 노트북용(SODIMM), 서버용(ECC·Registered)은 뺀다. "NON-ECC"는 일반 데스크톱이라 뺄 말로 보지 않는다.
  - 1개짜리 판정: 묶음 표시(2x·x2·KIT·2PCS…)가 없고 다른 용량이 같이 안 적힌 글. "1 x 8GB"는 1개다.
  - 제목 판정 규칙을 고치면 `ListingClassifierTest`에 실제 제목 사례를 추가한다.
- 다나와 연결: 모델 이름 검색 링크. 인기 모델은 다나와 상품 번호(pcode)를 사람이 손으로 적어 상품 페이지로 보낸다.

## 시세 API (server/api)
- `GET /api/board?category=GPU|RAM`(목록·24시간 변동·7일 추이, 종목마다 필터용 `facets`: GPU `series`=RTX50…, RAM `ddr`·`pack`=1|2), `GET /api/ticker?key=`(종목·제조사·모델), `GET /api/chart?key=&range=1d|1w|1m|3m|1y|all`. 종목 키에 `/`가 들어가 경로 대신 파라미터.
- `GET /api/movers`: 급등·급락 TOP 5(11/24 사용자 결정: 시세 탭 옆 "급등락" 탭, 시안 B). 4개 분류 칩셋에서 24시간 변동(목록 24H와 같은 값)이 있고 **판매 글 20개 이상**인 것만(글이 적으면 싼 글 하나에 ±16%씩 튐), 0%는 뺀다. 판매 속도(팔린 개수)로 매기는 "인기 순위"는 측정해 보니 대형 판매자 글 한두 개에 좌우돼 접었다(AI_LOG 11/24).
- 가격은 USD 센트 정수만 준다. 원화는 화면이 `fx.usdKrw`(그날 또는 그 전 가장 가까운 고시)를 곱한다.
- 화면 글자는 주지 않는다(vendor도 `NVIDIA|AMD|DESKTOP` 코드). 번역은 웹·앱이 한다.
- eBay·다나와 링크는 서버에서 만든다(웹·앱이 같은 주소를 쓰게).
- 봉 = 그 구간 매시간 대표가(price_cents)의 처음·최고·최저·마지막(`date_bin`, UTC, 주는 월요일 시작). 1일 1시간 봉, 1주 4시간, 1달·3달 1일, 1년·전체 1주.
- 변동 = 24시간 전(그 이전 가장 가까운) 스냅샷 대비. 없으면 null.

## 웹 (web/)
- Next.js 16(App Router, `cacheComponents` 켜짐) + Tailwind + Lightweight Charts(TradingView, 로고는 라이선스 표시라 끄지 않음).
- 코드를 쓰기 전에 `web/node_modules/next/dist/docs/`의 해당 문서를 본다(AGENTS.md).
- **화면은 코인 거래소 배치**(11/22 사용자 결정: "주식·코인처럼 상품을 누르면 그래프"): 왼쪽 종목 목록(`[category]/layout.tsx`), 오른쪽 고른 종목의 큰 차트(`[category]/[[...key]]/page.tsx`). 주소 `/ko/gpu/rtx-5070-ti/msi`. 휴대폰은 고른 종목 차트가 목록 위.
  - 차트: 기간 1일·1주·1달·3달·1년·전체, 선(기본)·봉. 여섯 기간을 서버에서 한 번에 받아 버튼이 기다리지 않게.
  - 시간축은 한국어 KST(+9), 영어 UTC. 원화 차트는 지금 환율 하나로 바꿔 그린다(환율 변동이 섞이지 않게). 눈금은 원 단위.
  - Next 16은 지나간 화면을 숨겨 둔다(Activity, 최대 3개). 브라우저 시험에서 요소를 셀 때는 `:visible`로.
- 주소는 `[category]/page.tsx`(분류 첫 화면) + `[category]/[...key]/page.tsx`(종목)로 나누고 내용은 `components/ticker-panel.tsx` 하나. 선택형 `[[...key]]` 한 파일로 두면 Vercel이 `/ko/gpu`용으로 미리 만든 화면을 `/ko/gpu/*` 전부에 내보낸다(로컬 `next start`에서는 안 보임, 11/22). 웹 확인은 Vercel 배포본에서 종목 주소를 바로 열어 본다.
- 급등락(11/24): `/ko/movers`(고정 주소라 `[category]`보다 먼저 잡힘). 탭 줄은 `components/top-bar.tsx`를 분류 화면과 같이 쓴다. 왼쪽 순위(`movers-list.tsx`), 오른쪽은 급등 1위(없으면 급락 1위) 차트(`TickerPanel listFirst`: 휴대폰에서도 순위가 먼저). 줄을 누르면 그 종목의 분류 주소로.
- 주소(params)·`usePathname`을 읽는 부분은 `<Suspense>` 안에. 서버 → 클라이언트 컴포넌트로 함수를 넘기지 않는다(글자를 만들어 넘김). layout 파일에서는 컴포넌트·generateStaticParams 외에 내보내지 않는다(`lib/route.ts`).
- API 호출은 `lib/api.ts`에서만(`use cache`, 10분마다 새로 받음: 시세는 매시간 바뀜).
- 목록 필터(11/22 사용자 결정: 분류마다 필터 창, 나중에 필터가 늘어도 한 표만 고치게): 웹 `lib/filters.ts`, 앱 `features/board/data/board_filter.dart`에 같은 규칙. VGA 시리즈(여러 개, 처음 전체), RAM 세대(여러 개)·구성(하나, 처음 1개). 분류마다 기억(웹 localStorage, 앱 SharedPreferences). 주소에 종목이 없는데 첫 종목이 필터로 가려지면 오른쪽도 필터된 첫 종목으로.
- 바로가기 기본값은 브라우저 localStorage(실패해도 eBay 기본). 상승·하락 색은 언어별(한국 빨강↑파랑↓, 영어 청록↑빨강↓), 변동 없으면 회색.
- 디자인은 앱과 같은 블랙 + 그린(색 이름은 `globals.css`의 `@theme`: bg·surface·line·ink·sub·muted·accent). 녹색은 로고·선택·주 버튼·차트 선에만. 글꼴 Space Grotesk + Noto Sans KR.
- 배포: Vercel(main push → 자동), Root `web`, 지역 `syd1`(API가 시드니), 환경 변수 `PARTSTOCK_API_URL`. 주소 https://partstock-two.vercel.app
- 커밋 전: `npm run lint`, `npx tsc --noEmit`, `npm run build`. 화면을 바꾸면 브라우저 콘솔·개발 서버 로그 에러까지 확인. API 응답 칸을 바꾸면 서버를 먼저 배포하고 웹을 올린다.

## 앱 (app/) — 3단계
- Flutter 3.47(Dart 3.13), 개인 프로젝트라 옛 버전 호환 확인은 하지 않는다. Android·iOS 빌드 설정은 템플릿 그대로.
- 구조(사용자 결정 11/22: Riverpod 말고 원래 쓰던 Bloc): flutter_bloc **Cubit만**, State는 `<name>_state.dart`(freezed), get_it + injectable(외부 객체는 `@module`), go_router 한 파일(`core/router/app_router.dart`, 탭은 StatefulShellRoute), 모델은 freezed + `fromMap` 손 매핑.
- 라우트는 `builder` 말고 `pageBuilder`로 `MaterialPage`를 직접 만든다(go_router 18은 material_ui의 MaterialApp만 알아봐서, 맡기면 전환 없는 페이지가 되어 iOS 밀어서 뒤로가기가 안 됨. 11/22).
- `getIt<X>()`는 main과 라우트의 `BlocProvider(create:)`에서만. Cubit은 이동·스낵바를 하지 않는다(상태를 보고 위젯이). 시간은 `Clock` 주입.
- 폴더(상태를 누가 갖고 언제 생기나):
  - `features/market/data`: API 모델·저장소. 시세 목록·차트·관심이 같이 쓰는 읽기 전용 데이터라 한 곳에(화면은 없음).
  - `features/board`: 시세 목록 탭. `BoardCubit`은 탭 화면과 함께 산다.
  - `features/ticker`: 종목 차트. `TickerCubit`은 종목을 열 때 생기고 닫으면 사라진다(종목마다 따로).
  - `features/movers`: 시세 탭의 "급등락" 탭(분류 탭 옆). `MoversCubit`은 시세 탭 화면과 함께 살고 그 탭을 처음 열 때 받는다. 시세 목록과 받는 API·수명이 달라 따로(화면은 BoardScreen이 탭으로 끼워 넣음).
  - `features/watchlist`: 관심 종목. `WatchlistCubit`은 앱 전체 수명(차트 화면의 별과 관심 탭이 같은 상태를 본다), 저장은 SharedPreferences.
  - `features/settings`: 바로가기 기본값(eBay/다나와), 가이드를 봤는지. `SettingsCubit` 앱 전체 수명.
  - `features/onboarding`: 런치 애니메이션·처음 실행 가이드. 앱을 켤 때만 잠깐 있고 사라지는 화면이라 따로(상태는 위젯 안 + SettingsCubit).
  - `features/alerts`: 목표가 알림. `AlertsCubit` 앱 전체 수명(종 버튼·관심 탭·설정이 같이 봄).
- 디자인(11/22 사용자 결정, 시안 "디자인 3차"): 블랙 + 그린 다크 테마(`core/presentation/theme.dart`, 공통 부품 `brand.dart`). 녹색 #7EE04B는 강조(브랜드·선택·주 버튼·차트 선)에만, 오르내림은 한국 빨강↑파랑↓ / 영어 청록↑빨강↓. 글꼴 Space Grotesk(OFL, 앱에 넣음) + 한글은 폰 기본.
- 시작 흐름: 런치 애니메이션(약 1.4초, 누르면 넘김, 움직임 줄이기 켜면 바로 끝) → 처음이면 가이드 → 시세. 알림 권한은 가이드 마지막 장에서 묻는다(건너뛰면 종 버튼 누를 때). iOS는 알림이 없어 가이드 2장.
- 앱 아이콘·알림 아이콘은 칩 로고를 브라우저로 그려 만든다(`assets/icon`, `dart run flutter_launcher_icons`). 시작 전 바탕(Android·iOS)은 검정.
- API 주소는 `--dart-define=API_URL=...`(기본 배포 주소). 연결 실패·시간 초과와 서버 오류를 나눈다. 시세 목록은 마지막 응답을 저장해 먼저 보여 주고 뒤에서 새로 받는다.
- 화면 글자는 한국어·영어(arb, 폰 언어). 상승·하락 색은 웹과 같게 언어별.
- 차트: fl_chart(선·봉). 기간 1일·1주·1달·3달·1년·전체, 웹과 같은 API(`/api/chart`).
- 목표가 알림(FCM, 3-2단계): 회원 가입 없이 FCM 기기 토큰이 사용자(`X-Device-Token` 머리글). 서버 `alert` 패키지가 기기·알림 저장, 매시간 수집 직후 대표가가 목표에 닿으면 한 번 보내고 끈다. 앱을 지운 기기(UNREGISTERED)는 지우고, 잠깐 실패는 다음 시각에 다시.
  - 보내기는 Firebase Admin SDK 대신 구글 인증 라이브러리 + FCM HTTP v1(1GB 서버 메모리). 키 파일이 없으면 보내지 않고 기록만(로컬·테스트).
  - 할 일: firebase_messaging 17.1에서 `getToken`·`onTokenRefresh`가 `register()`·`onRegistered`(설치 ID)로 바뀌는 중. 서버가 그 ID로 보내는 요청 모양을 확인하고 옮긴다(지금은 검증된 FCM 토큰 방식).
  - Firebase 프로젝트 `partstock-prices`(FlutterFire CLI로 설정). iOS 푸시는 Apple 유료 계정(APNs)이 있어야 해서 **Android만**, iOS는 알림 버튼을 숨긴다.
- 테스트: 저장소는 실제 API 응답 예시(`test/fixtures`)로 단위, Cubit은 가짜 저장소, 화면은 흐름 테스트. 그다음 에뮬레이터에서 직접 눌러 확인.
- 커밋 전: `dart format`, `flutter analyze`, `flutter test`. 생성 파일(.g.dart, .freezed.dart, .config.dart)은 커밋한다.

## 화면 (2·3단계)
- 영어·한국어. 영어는 달러, 한국어는 원화(공식 환율 환산) 크게 + 달러 작게.
- 큰 분류 이름: 한국어 **VGA / RAM**, 영어 **GPU / RAM**(11/22 사용자 결정: 한국 PC 시장에서 쓰는 말).
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

## CI/CD (11/22 사용자 결정: 서버·앱 둘 다, NowStation과 같은 방식)
- 서버 `.github/workflows/server.yml`: main에 server·deploy가 바뀐 push → 테스트(Testcontainers) → 이미지(레포 루트에서 `docker build -f server/Dockerfile`, 안에서 jar 빌드)를 GHCR `ghcr.io/sinadsl1457/partstock-server:<커밋>`·`:main`에 올림 → EC2 타이머(`partstock-deploy.timer`, 1분)가 새 이미지를 보고 스스로 교체(`deploy/auto-deploy.sh` → `remote-deploy.sh`, 2분 안에 `/api/version`이 새 커밋이 아니면 되돌리고 그 커밋은 다시 시도 안 함) → Actions가 `https://<PUBLIC_HOST>/api/version`으로 확인. GitHub은 서버에 들어가지 않는다(서버엔 GHCR 읽기 전용 토큰만). 배포 설정 파일은 이미지 안 `/deploy`에서 꺼내 쓴다.
- 앱 `.github/workflows/app.yml`: app이 바뀐 push·PR → 생성 파일 일치·포맷·분석·테스트·APK 빌드.
- 앱 `.github/workflows/app-release.yml`: 태그 `app-v*` 또는 손으로 → 서명된 .aab(versionCode = 커밋 수) → Play 업로드(`PLAY_SERVICE_ACCOUNT_JSON`). Play 첫 .aab는 Console에서 손으로(결과물 artifact 사용).
- Android 앱 ID `com.taektoy.partstock`(Play에 올리면 못 바꿈, NowStation과 같은 꼴). iOS 번들 ID는 `com.partstock.partstock` 그대로(무료 서명 앱 자리 문제, 스토어 출시 계획 없음).
- 업로드 키: 맥 `~/.ssh/partstock-upload.jks` + `.properties`(커밋 금지), GitHub 비밀값 `RELEASE_*`. 로컬 빌드는 키가 없으면 디버그 키로 서명.
- 개인정보 처리방침: 웹 `/ko/privacy`·`/en/privacy`(앱 설정에서도 연결). 저장하는 것이 바뀌면 같이 고친다.
- `deploy/deploy.sh`(맥에서 손 배포)는 자동 배포가 멈췄을 때만.

## 배포 (수집 서버)
- AWS EC2 새 t3.micro 한 대(NowStation과 분리, 11/22 결정). Docker compose로 PostgreSQL + 서버(`deploy/compose.prod.yaml`), 값은 EC2 `~/partstock/.env`.
- 지금은 맥에서 `deploy/deploy.sh <IP>`로 이미지를 만들어 보낸다(CI 전 임시).
- 밖에서는 Caddy(80·443)만 보인다: `https://<IP를 -로 이은>.sslip.io/api/*`만 서버로 넘김(`deploy/Caddyfile`). 서버·DB 포트는 compose 안 네트워크에만.
- EC2는 시드니(ap-southeast-2). 웹(Vercel)도 `syd1`에서 돌려 API와 가깝게(`web/vercel.json`).
- 메모리: JVM `-Xmx256m`(실측 약 370MB), PostgreSQL `shared_buffers=32MB`(약 26MB), 스왑 2GB.
- **시세 기록은 다시 받을 수 없다**(eBay는 지금 올라온 글만 줌). 매일 04:00 UTC `pg_dump`(`deploy/backup.sh` + systemd 타이머): EC2에 14일치 + **S3 `partstock-backup-2611/daily/`에 전부**(11/22). S3는 EC2 역할 `partstock-ec2`(그 버킷에 올리기·목록만, 콘솔에서 만듦)로 올려 서버·맥에 AWS 키가 없다. 버킷 이름은 EC2 `.env`의 `BACKUP_BUCKET`. 되살릴 때는 콘솔에서 내려받아 `pg_restore`.
- 켜질 때 이번 시각 수집 기록이 없으면 바로 수집한다(`partstock.collect.on-start`). 종목 표는 켜질 때도 코드 목록에 맞춘다(새 칩셋이 다음 수집 전에도 열리게).
- eBay 호출: 칩셋 101개(VGA 27·RAM 14·CPU 24·SSD 36), 검색마다 최대 5쪽(`ebay.max-pages`, 11/22 5쪽·10쪽 비교로 정함) → 하루 약 3,300번 예상(VGA·RAM만일 때 실측 약 1,800, 무료 5,000, 유료 요금제는 없고 늘리려면 무료 심사 Application Growth Check). 실제 수는 수집 로그의 "eBay 요청"과 eBay `getRateLimits`(매일 08:00 UTC 초기화)로 본다.
