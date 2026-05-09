select sex
	, count(*) as members
	, round(count(*) * 100.0 / sum(count(*)) over()) as percent 
from users
group by sex
order by percent;


select row_number() over(order by age) as age_num
	, age
	, count(*) as clients
	, round(count(*) * 100.0 / sum(count(*)) over()) as percent 
from users
group by age
order by age;

select * from orders;

select 
	extract(year from date) as year
	, status
	, count(*) as orders
	, round(count(*) * 100.0 / sum(count(*)) over(partition by extract(year from date)), 2) as percent
from orders 
group by year, status
order by year, status;

select 
	extract(year from date) as year
	, user_id
	, sum(amount) as amount
	, round(sum(amount) * 100.0 / sum(sum(amount)) over(partition by extract(year from date)), 2) as percent
from orders
where status = 'success'
group by year, user_id
order by year, percent;

select
	extract(year from date) as year
	, extract(quarter from date) as quarter
	, sum(income) as income
	, sum(sum(income)) over(partition by extract(year from date) order by extract(quarter from date)) as income_acc
	, round(sum(sum(income)) over(partition by extract(year from date) order by extract(quarter from date)) * 0.06, 2) as usn6
from transactions
group by extract(year from date), extract(quarter from date);
