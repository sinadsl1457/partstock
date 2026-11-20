# AI 작업 기록

AI가 틀렸거나 방향을 바꾼 지점. 경과 시간 / 한 일 / 틀린 것 → 고친 것.

- 0:00 Spring Initializr로 뼈대 생성: 의존성 이름을 `webmvc`로 넣어 400 에러 → Initializr 목록에서 `web`이 webmvc 스타터임을 확인하고 고침
- 1:20 eBay 검색 호출 작성: 검색 조건 `buyingOptions:{FIXED_PRICE}`를 주소에 그대로 넣어 Spring이 중괄호를 주소 변수로 해석 → 가짜 서버 테스트에서 "Not enough variable values" 에러로 발견, 조건을 변수로 넘기게 고침
