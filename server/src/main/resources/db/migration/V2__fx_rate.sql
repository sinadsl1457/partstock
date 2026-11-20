-- 원/달러 기준 환율(유럽중앙은행 고시, Frankfurter API). 주말·휴일은 고시가 없어 화면에서 직전 값을 쓴다.
create table fx_rate (
    day      date          primary key,
    usd_krw  numeric(10,2) not null
);
