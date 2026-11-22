-- 분류에 CPU(11/22)와 다음 단계의 SSD를 허용한다.
alter table ticker drop constraint ticker_category_check;
alter table ticker add constraint ticker_category_check check (category in ('GPU', 'RAM', 'CPU', 'SSD'));
