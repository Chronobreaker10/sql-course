select * from orders o where o.ship_country in ('France', 'Austria', 'Spain');

select * from orders o order by o.required_date desc, o.shipped_date;

select min(p.unit_price) from products p where p.units_in_stock > 30;

select max(p.units_in_stock) from products p where p.unit_price > 30;

select avg(o.shipped_date - o.order_date) :: int from orders o where o.ship_country = 'USA';

select sum(p.unit_price * p.units_in_stock) :: int from products p where p.discontinued != 1;