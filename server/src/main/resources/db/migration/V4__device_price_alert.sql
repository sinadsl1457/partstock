-- 목표가 알림. 회원 가입 없이 기기 토큰(FCM)이 곧 사용자다.
create table device (
    token       varchar(512) primary key,
    platform    varchar(10)  not null check (platform in ('ANDROID', 'IOS')),
    -- 알림 글자 언어(ko|en)
    locale      varchar(10)  not null default 'ko',
    created_at  timestamptz  not null default now(),
    seen_at     timestamptz  not null default now()
);

-- 대표가(p25)가 목표 이하(BELOW)·이상(ABOVE)이 되면 한 번 보내고 끝(fired_at).
create table price_alert (
    id            bigserial    primary key,
    token         varchar(512) not null references device (token) on delete cascade,
    ticker_key    varchar(120) not null references ticker (key),
    direction     varchar(5)   not null check (direction in ('BELOW', 'ABOVE')),
    target_cents  bigint       not null check (target_cents > 0),
    created_at    timestamptz  not null default now(),
    fired_at      timestamptz,
    fired_cents   bigint
);
create index price_alert_waiting on price_alert (ticker_key) where fired_at is null;
create index price_alert_token on price_alert (token);
