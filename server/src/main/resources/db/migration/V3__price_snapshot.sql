-- 매시간 시세(2026-11-22 결정: 하루 한 번으로는 차트가 일주일 넘게 비어 있어서).
-- daily_price는 "그날 가장 최근 시세"로 계속 쓰고, 차트·24시간 변동은 이 표로 그린다.
create table price_snapshot (
    ticker_key     varchar(120) not null references ticker (key),
    ts             timestamptz  not null,
    p25_cents      bigint       not null,
    median_cents   bigint       not null,
    p75_cents      bigint       not null,
    min_cents      bigint       not null,
    max_cents      bigint       not null,
    listing_count  int          not null,
    raw_count      int          not null,
    primary key (ticker_key, ts)
);

-- 지금까지의 하루 시세(그날 00시대 UTC에 수집)를 그날 0시 스냅샷으로 옮겨 차트가 이어지게
insert into price_snapshot (ticker_key, ts, p25_cents, median_cents, p75_cents, min_cents, max_cents,
                            listing_count, raw_count)
select ticker_key, cast(day as timestamp) at time zone 'UTC', p25_cents, median_cents, p75_cents, min_cents,
       max_cents, listing_count, raw_count
from daily_price;
