# Play 스토어 자료 (파츠스톡 / partstock)

앱 ID `com.taektoy.partstock` · 기업 개발자 계정 · 무료 · 광고 없음 · 인앱 결제 없음
이미지: `icon-512.png`, `ko/feature-graphic.png`·`en/feature-graphic.png`(1024×500), `ko/screenshot-1~5.png`·`en/…`(1080×1920).
다시 그리기: `node store/make.js`(원본 화면 `store/raw`는 에뮬레이터에서 찍음).

## 기본 정보

| 칸 | 한국어 | English |
|---|---|---|
| 앱 이름 (30자) | 파츠스톡 - PC 부품 시세 | partstock - PC Part Prices |
| 카테고리 | 쇼핑 | Shopping |
| 태그 | 가격 비교, 쇼핑 | Price comparison, Shopping |
| 개인정보 처리방침 | https://partstock-two.vercel.app/ko/privacy | https://partstock-two.vercel.app/en/privacy |
| 웹사이트 | https://partstock-two.vercel.app | https://partstock-two.vercel.app/en |

카테고리를 "금융"으로 하지 않는다: 주식·투자 앱으로 오해받을 수 있고, 금융 앱은 추가 신고 항목이 있다.

## 간단한 설명 (80자)

- 한국어: `그래픽카드·램·CPU·SSD 시세를 주식처럼. 매시간 갱신, 원하는 가격이 되면 알림.`
- English: `GPU, RAM, CPU & SSD prices like a stock ticker. Hourly updates, price alerts.`

## 자세한 설명

### 한국어

```
PC 부품 값, 요즘 얼마인지 한눈에 보세요.

파츠스톡은 그래픽카드·램·CPU·SSD 시세를 주식 앱처럼 보여 줍니다. 미국 eBay에 올라온 새 상품 판매가를 매시간 모아 정리하고, 원화로 바꿔 보여 줍니다.

■ 101개 종목
· VGA: RTX 50·40 시리즈, RX 9000·7000 시리즈
· RAM: DDR5·DDR4, 1개·2개 묶음
· CPU: Ryzen 9000·7000, Core Ultra 200S, Core 14·13세대
· SSD: 인기 모델 × 1·2·4TB

■ 누르면 바로 차트
· 1일·1주·1달·3달·1년·전체 차트, 선과 봉
· 칩셋 → 제조사 → 모델 단계로 내려가며 비교 (예: RTX 5070 Ti → MSI → Gaming Trio)
· 기간 등락·최고·최저

■ 목표가 알림
· 원하는 가격을 걸어 두면 매시간 확인해서 닿는 순간 푸시로 알려 드립니다.
· 회원 가입이 필요 없습니다.

■ 보고 싶은 것만
· 분류마다 필터: 시리즈, 세대, 1개·2개 묶음, 브랜드, 용량, 규격
· 관심 종목은 별표 한 번으로

■ 바로 사러 가기
· eBay 상품이나 다나와 검색으로 바로 이동 (기본값은 설정에서)

■ 가격은 이렇게 계산합니다
· 미국 eBay 새 상품·즉시 구매 글만 셉니다.
· 같은 판매자가 같은 가격에 여러 번 올린 글은 한 번만 세고, 터무니없는 가격은 뺍니다.
· 대표가는 하위 25% 가격입니다. 안 팔리는 비싼 글에 시세가 끌려가지 않게 하려는 것입니다.
· 원화는 유럽중앙은행 기준 환율로 바꾼 값이며 배송비·관세는 들어 있지 않습니다.
· 판매 글이 적은 종목은 값을 지어내지 않고 "데이터 없음"으로 표시합니다.

파츠스톡은 eBay·다나와와 관계없는 개인 프로젝트이며, 상품을 직접 팔지 않습니다.
```

### English

```
See what PC parts cost right now, at a glance.

partstock shows GPU, RAM, CPU and SSD prices like a stock app. It collects new eBay US listings every hour and turns them into one clear price per item.

■ 101 items
· GPU: RTX 50 & 40 series, RX 9000 & 7000 series
· RAM: DDR5 & DDR4, single sticks and 2-stick kits
· CPU: Ryzen 9000 & 7000, Core Ultra 200S, Core 14th & 13th Gen
· SSD: popular models in 1, 2 and 4TB

■ Tap for the chart
· 1 day, 1 week, 1 month, 3 months, 1 year and all time, line or candles
· Drill down from chipset to brand to model (e.g. RTX 5070 Ti → MSI → Gaming Trio)
· Change, high and low for any range

■ Price alerts
· Set a target price and get a push notification the hour it's reached.
· No sign-up needed.

■ Only what you care about
· Filters per category: series, generation, single or kit, brand, capacity, interface
· Star items to keep them in your watchlist

■ Go buy it
· Jump straight to the eBay listing (or a Danawa search)

■ How prices are calculated
· Only new, Buy It Now listings on eBay US.
· Repeat listings from the same seller at the same price count once; extreme outliers are removed.
· The price shown is the 25th percentile, so overpriced listings that never sell don't drag it up.
· Shipping and taxes are not included.
· Items with too few listings show "No data" instead of a made-up number.

partstock is an independent project, not affiliated with eBay or Danawa, and does not sell anything.
```

## 출시 노트 (처음 출시)

- 한국어: `첫 출시: VGA·RAM·CPU·SSD 101개 종목 시세, 차트, 목표가 알림, 분류별 필터`
- English: `First release: prices for 101 GPUs, RAM, CPUs and SSDs, charts, price alerts and filters`

## 데이터 보안 양식 답안

앱이 실제로 보내는 것만(서버 V4 마이그레이션, 개인정보 처리방침과 같음).

| 질문 | 답 |
|---|---|
| 사용자 데이터를 수집하거나 공유하나요? | 예(수집) |
| 전송 중 암호화되나요? | 예 (https만 씀) |
| 사용자가 데이터 삭제를 요청할 수 있나요? | 예 (앱에서 알림을 지우면 서버에서 지워짐, 앱 삭제 시 자동 정리) |
| 수집 항목 | **기기 또는 기타 ID**(알림 토큰) 하나 |
| └ 수집/공유 | 수집만 (공유 아님: FCM은 알림을 보내는 서비스 제공자) |
| └ 일시적 처리? | 아니요 (알림을 끌 때까지 저장) |
| └ 필수/선택 | 선택 (목표가 알림을 켤 때만) |
| └ 목적 | 앱 기능 |
| 위치·연락처·개인 정보·금융 정보·앱 활동·기기 이름 등 | 수집 안 함 |

목표가 조건(종목·가격)은 사용자가 고른 앱 설정값이라 개인 정보 항목에 해당하지 않는다. 판단이 애매하면 "앱 활동 > 기타 사용자 생성 콘텐츠"로 넣어도 된다.

## 콘텐츠 등급 설문 답안

- 카테고리: 유틸리티·생산성·커뮤니케이션 등(게임 아님)
- 폭력·성적 내용·욕설·약물·도박: 모두 없음
- 사용자끼리 소통·사용자 생성 콘텐츠 공유: 없음
- 위치 공유: 없음
- 디지털 상품 구매: 없음 (외부 쇼핑몰 링크만)
- 예상 등급: 전체 이용가

## 기타 앱 콘텐츠

- 광고: 없음
- 앱 액세스: 모든 기능을 로그인 없이 쓸 수 있음(심사용 계정 불필요)
- 타겟층: 18세 이상 (어린이 대상 아님)
- 뉴스 앱: 아님 / 정부 앱: 아님 / 금융 기능: 없음 / 건강: 아님
- 알림 권한: 목표가 알림을 켤 때만 요청(가이드 마지막 장 또는 종 버튼)
