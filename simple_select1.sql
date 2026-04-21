select * from customers c;

select contact_name, city from customers c;

select o.order_id, o.shipped_date - o.order_date as ship_time from orders o;

select distinct c.city from customers c;

select distinct c.city, c.country from customers c;

select count(c.customer_id) from customers c;

select count(*) from customers;

select count(distinct country) from customers;