select c.company_name, concat(e.first_name, ' ', e.last_name) as full_name
from customers c 
join orders o using(customer_id) join employees e using(employee_id)
join shippers s on o.ship_via = s.shipper_id
where c.city = 'London' and e.city = 'London' and s.company_name = 'Speedy Express'

select p.product_name, p.units_in_stock, s.contact_name, s.phone 
from products p
join categories c using(category_id)
join suppliers s using(supplier_id)
where c.category_name in ('Beverages', 'Seafood') and p.units_in_stock < 20 and p.discontinued = 0
order by p.units_in_stock;

select c.contact_name, o.order_id
from customers c
left join orders o using(customer_id)
where o.order_id is null
order by c.contact_name;

select c.contact_name, o.order_id
from orders o
right join customers c using(customer_id)
where o.order_id is null
order by c.contact_name;

select
	o.customer_id
	, c.contact_name 
	, c.country 
	, c.city 
	, round(sum(od.unit_price * od.quantity * (1 - od.discount))) as total
from order_details od
join orders o using(order_id)
join customers c using(customer_id)
group by o.customer_id, c.contact_name, c.phone, c.country, c.city
order by total desc