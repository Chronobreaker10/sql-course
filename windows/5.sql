
with revenue_ror as (select year, month, income, outcome, sum(income - outcome) over(order by year, month) as ror from revenues)

select *, min(ror) over() as investment, count(*) over() as month from revenue_ror where ror < 0;

select *, sum(money) over(order by date, id) as balance 
from (select * from transactions union select 0 as id, '2022-01-01' as date, 'Начальный баланс' as item, 10000 as money)
order by date, id;

select * from transactions