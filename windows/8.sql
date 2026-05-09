select 
	id
	, email
	, concat(first_name, ' ', last_name) as name
	, ntile(3) over(order by id) as mail_variant 
from users order by id;

select 
	id
	, email
	, concat(first_name, ' ', last_name) as name
	, ntile(4) over(order by md5(email)) as mail_variant
	--random()
from users order by id;

select 
	s.name
	, u.first_name
	, u.last_name
	, sum(amount) as amount
	, ntile(4) over (partition by s.name order by sum(amount) desc) as c_level
from orders o
join users u on u.id = o.user_id 
join shops s on s.id = o.shop_id
where o.status = 'success'
group by s.name, u.first_name, u.last_name
order by s.name, c_level;

select * from orders;

with ntile_orders as (
	select 
		extract(month from o.date) as month
		, u.first_name
		, u.last_name
		, sum(o.amount) as amount
		, ntile(4) over (partition by extract(month from o.date) order by sum(o.amount) desc) as c_level
	from orders o
	join users u on u.id = o.user_id 
	join shops s on s.id = o.shop_id
	where o.status = 'success'
	group by month, u.first_name, u.last_name
	order by month, amount
)

select * from ntile_orders where c_level = 1;

