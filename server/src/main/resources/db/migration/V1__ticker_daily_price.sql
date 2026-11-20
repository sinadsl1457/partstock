-- 종목. 칩셋은 시작할 때 코드 목록(Catalog)에서 만들고, 제조사·모델은 판매 글에서 처음 보일 때 만든다.
-- key 예: rtx-5070-ti / rtx-5070-ti/msi / rtx-5070-ti/msi/gaming-trio
create table ticker (
    key           varchar(120) primary key,
    level         varchar(10)  not null check (level in ('CHIPSET', 'MAKER', 'MODEL')),
    category      varchar(10)  not null check (category in ('GPU', 'RAM')),
    chipset_key   varchar(60)  not null,
    maker_key     varchar(30),
    series_key    varchar(30),
    display_name  varchar(80)  not null,
    -- 다나와 상품 번호. 사람이 찾아서 넣는다(다나와는 긁어 오지 않음)
    danawa_pcode  varchar(20),
    created_at    timestamptz  not null default now()
);
create index ticker_chipset on ticker (chipset_key);

-- 종목별 하루 시세. eBay 원본(제목·글 번호·판매자)은 저장하지 않고 이 숫자만 남긴다(eBay 약관).
-- 같은 날 다시 수집하면 덮어쓴다.
create table daily_price (
    ticker_key     varchar(120) not null references ticker (key),
    day            date         not null,
    median_cents   bigint       not null,
    p25_cents      bigint       not null,
    p75_cents      bigint       not null,
    min_cents      bigint       not null,
    max_cents      bigint       not null,
    listing_count  int          not null,
    raw_count      int          not null,
    primary key (ticker_key, day)
);

-- 수집 기록. 하루치가 비었을 때 "판매 글이 적었나 / 수집이 실패했나"를 구분하려고.
create table collection_run (
    id             bigserial    primary key,
    day            date         not null,
    started_at     timestamptz  not null,
    finished_at    timestamptz,
    status         varchar(10)  not null check (status in ('RUNNING', 'OK', 'PARTIAL', 'FAILED')),
    api_calls      int          not null default 0,
    listings_seen  int          not null default 0,
    listings_used  int          not null default 0,
    error          text
);
