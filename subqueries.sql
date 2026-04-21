select p.product_name, p.units_in_stock from products p 
where p.units_in_stock < all (select avg(od.quantity) as avg_q
from order_details od 
group by od.product_id)
order by p.units_in_stock desc;

select o.customer_id, sum(o.freight) as freight_sum
from orders o
join (select customer_id, avg(freight) as freight_avg from orders group by customer_id) o2 using(customer_id)
where o.freight > o2.freight_avg
and o.shipped_date between '1996-07-16' and '1996-07-31'
group by o.customer_id
order by freight_sum;

select o.customer_id, o.ship_country,
(select sum(od.quantity * od.unit_price * (1 - od.discount)) from order_details od where od.order_id = o.order_id) as order_price 
from orders o
where o.order_date >= '1997-09-01' and o.ship_country in ('Argentina' , 'Bolivia', 'Brazil', 'Chile', 'Colombia', 'Ecuador', 'Guyana', 'Paraguay', 
						'Peru', 'Suriname', 'Uruguay', 'Venezuela')
order by order_price desc
limit 3;

select o.customer_id, o.ship_country, od.order_price
from orders o
join (select order_id, sum(od.quantity * od.unit_price * (1 - od.discount)) as order_price from order_details od group by order_id) as od
using (order_id)
where o.order_date >= '1997-09-01' and o.ship_country in ('Argentina' , 'Bolivia', 'Brazil', 'Chile', 'Colombia', 'Ecuador', 'Guyana', 'Paraguay', 
						'Peru', 'Suriname', 'Uruguay', 'Venezuela')
order by order_price desc
limit 3;

select distinct p.product_name from products p
where p.product_id  = ANY (select od.product_id from order_details od where od.quantity = 10);

SELECT distinct product_name, quantity
FROM products
join order_details using(product_id)
where order_details.quantity = 10;