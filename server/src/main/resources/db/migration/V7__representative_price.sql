-- 대표가(price_cents)를 p25와 따로 둔다. 글 20개 이상이면 하위 10%, 적으면 하위 25%(PriceStats).
-- 지난 기록은 그때 대표가였던 p25로 채운다(원본 글을 저장하지 않아 다시 계산할 수 없다).
alter table price_snapshot add column price_cents bigint;
update price_snapshot set price_cents = p25_cents;
alter table price_snapshot alter column price_cents set not null;

alter table daily_price add column price_cents bigint;
update daily_price set price_cents = p25_cents;
alter table daily_price alter column price_cents set not null;
