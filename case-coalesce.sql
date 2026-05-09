insert into customers(customer_id, contact_name, city, country, company_name)
values 
('AAAAA', 'Alfred Mann', NULL, 'USA', 'fake_company'),
('BBBBB', 'Alfred Mann', NULL, 'Austria','fake_company');

select c.contact_name, c.city, c.country
from customers c
order by c.contact_name, coalesce(c.city, c.country);

select p.product_name
, case
	when p.unit_price >= 100 then 'too expensive'
	when p.unit_price < 50 then 'low price'
	else 'average'
  end as price
from products p
order by p.unit_price desc;

select c.contact_name
, coalesce(sum(o.order_id) :: char, 'no orders') as orders_count
from customers c 
left join orders o on o.customer_id = c.customer_id
group by c.contact_name
order by orders_count desc;

select concat(e.last_name, ' ', e.first_name) as name
, coalesce(nullif(e.title, 'Sales Representative'), 'Sales Stuff')
from employees e;