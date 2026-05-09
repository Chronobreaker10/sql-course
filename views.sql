create view orders_customers_employees_view as 
select order_date, required_date, shipped_date, ship_postal_code, company_name, contact_name, phone, last_name, first_name, title
from orders join customers using(customer_id) join employees using(employee_id);

select * from orders_customers_employees_view ocev where ocev.order_date > '1997-01-01';

create view orders_customers_employees_view2 as
select order_date, required_date, shipped_date, ship_postal_code, ship_country, company_name, contact_name, phone, last_name, first_name, title
from orders join customers using(customer_id) join employees using(employee_id);

alter view orders_customers_employees_view2 rename to orders_customers_employees_view3;

create view orders_customers_employees_view2 as
select order_date, required_date, shipped_date, ship_postal_code, ship_country, customers.postal_code, reports_to,
company_name, contact_name, phone, last_name, first_name, title
from orders join customers using(customer_id) join employees using(employee_id);

select * from orders_customers_employees_view2 order by ship_country;

drop view if exists orders_customers_employees_view3;

create or replace view active_products as
select * from products p
where p.discontinued = 0
with local check option;

select * from active_products order by unit_price;

insert into active_products(product_id, product_name, supplier_id, category_id, quantity_per_unit, unit_price, units_in_stock, units_on_order, reorder_level, discontinued)
values (1000, 'test', 15, 5, '12 - 8 oz jars', 25, 120, 0, 10, 1);


create or replace view orders_with_revenue as (
	select 
		ord.order_id, ord.customer_id, ord.employee_id, ord.order_date, od.revenue
	from orders ord
	join (select order_id, sum(round(unit_price * quantity * (1 - discount))) as revenue from order_details group by order_id) as od 
	using(order_id)
	order by revenue desc
)

select * from orders_with_revenue;

create or replace view categories_with_now as (
	select *, now() as now from categories
);

select * from categories_with_now;

create materialized view mat_categories_with_now as (
	select *, now() as now from categories
);

select * from mat_categories_with_now;

refresh materialized view mat_categories_with_now;

select * from mat_categories_with_now;

