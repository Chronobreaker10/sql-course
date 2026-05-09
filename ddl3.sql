drop table if exists order_details_with_discount_sum;

create table order_details_with_discount_sum as (
	select *, unit_price * quantity * discount as discount_sum from order_details
)

drop table if exists orders_with_discount_sum;

create table orders_with_discount_sum as (
	select o.*, od.discount_sum from orders o
	join (
		select order_id, sum(discount_sum) as discount_sum
		from order_details_with_discount_sum
		group by order_id
	) as od using(order_id)
);

select * from orders_with_discount_sum order by order_date;

alter table orders_with_discount_sum add column revenue double precision;

update orders_with_discount_sum as ods
set revenue = od.revenue
from (
	select 
		order_id
		, sum(unit_price * quantity * (1 - discount)) as revenue
	from order_details
	group by order_id
) as od
where od.order_id = ods.order_id;

select count(*) from customers_backup;

delete from customers_backup where customer_id in ('BOLID', 'ANATR');

insert into customers_backup select * from customers where customer_id in ('BOLID', 'ANATR');