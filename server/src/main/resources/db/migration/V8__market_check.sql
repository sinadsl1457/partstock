-- 하루 한 번 칩셋마다 새 상품 글 수와 중고 글 수를 센다. 새 글이 중고보다 적으면 단종돼 시장이 중고로 넘어간 제품이라
-- 새 상품 시세가 남은 비싼 재고 값이 된다(11/25: Ryzen 5 7600 새 9개 $236 / 중고 28개 $142) → 시세판에서 뺀다.
-- 원본 글은 저장하지 않고 개수만 남긴다.
create table market_check (
    ticker_key  varchar(120) not null references ticker (key),
    day         date         not null,
    new_count   int          not null,
    used_count  int          not null,
    primary key (ticker_key, day)
);
