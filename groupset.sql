select 
	o.employee_id, sum(unit_price * quantity) as revenue 
from order_details od 
left join orders o using(order_id)
group by rollup(o.employee_id)
order by revenue desc;

select 
	o.employee_id, o.ship_country, sum(unit_price * quantity) as revenue 
from order_details od 
left join orders o using(order_id)
group by rollup(o.employee_id, o.ship_country)
order by revenue desc;

select 
	o.employee_id, o.ship_country, sum(unit_price * quantity) as revenue 
from order_details od 
left join orders o using(order_id)
group by cube(o.employee_id, o.ship_country)
order by revenue desc;

select 
	e1.employee_id
	, concat(e1.first_name, ' ', e1.last_name) as name
	, e1.title, e1.address
	, e1.reports_to
	, concat(e2.first_name, ' ', e2.last_name) as reports_name
from employees e1
left join employees e2 on e1.reports_to = e2.employee_id;

with recursive employees_with_reports as (
	select 
		employee_id
		, concat(first_name, ' ', last_name) as name
		, title, address
		, reports_to
		, 1 as level
	from employees
	union
	select 
		e.employee_id
		, concat(e.first_name, ' ', e.last_name) as name
		, e.title, e.address
		, e.reports_to
		, er.level + 1
	from employees e
	join employees_with_reports er on er.reports_to = e.employee_id
)

select * from employees_with_reports order by level, employee_id;