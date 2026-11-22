-- 램 2개 묶음 종목 키를 옮긴다: ddr5-32gb(2×16GB) → ddr5-2x16gb.
-- 11/22 사용자 결정으로 1개짜리를 기본 종목으로 넣는데, 1개짜리가 ddr5-32gb 같은 이름을 쓰게 하려고.
-- 제조사·모델 종목(ddr5-32gb/corsair/...)과 시세 기록·목표가 알림도 같이 옮긴다(기록은 다시 받을 수 없어서 지우지 않음).
create temporary table key_map (old_key varchar(60) primary key, new_key varchar(60) not null);
insert into key_map values
    ('ddr5-16gb', 'ddr5-2x8gb'),
    ('ddr5-32gb', 'ddr5-2x16gb'),
    ('ddr5-64gb', 'ddr5-2x32gb'),
    ('ddr5-96gb', 'ddr5-2x48gb'),
    ('ddr4-16gb', 'ddr4-2x8gb'),
    ('ddr4-32gb', 'ddr4-2x16gb'),
    ('ddr4-64gb', 'ddr4-2x32gb');

create temporary table key_rows as
select t.key as old_key, m.new_key || substr(t.key, length(m.old_key) + 1) as new_key, m.new_key as new_chipset
from ticker t join key_map m on t.key = m.old_key or t.key like m.old_key || '/%';

insert into ticker (key, level, category, chipset_key, maker_key, series_key, display_name, danawa_pcode, created_at)
select r.new_key, t.level, t.category, r.new_chipset, t.maker_key, t.series_key, t.display_name, t.danawa_pcode, t.created_at
from ticker t join key_rows r on t.key = r.old_key;

update daily_price d set ticker_key = r.new_key from key_rows r where d.ticker_key = r.old_key;
update price_snapshot s set ticker_key = r.new_key from key_rows r where s.ticker_key = r.old_key;
update price_alert a set ticker_key = r.new_key from key_rows r where a.ticker_key = r.old_key;
delete from ticker t using key_rows r where t.key = r.old_key;

drop table key_rows;
drop table key_map;
