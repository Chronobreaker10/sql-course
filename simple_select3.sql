select * from orders where ship_country like 'U%';

select o.order_id, o.customer_id, o.freight, o.ship_country from orders o where o.ship_country like 'N%' order by o.freight desc limit 5;

select e.first_name, e.last_name, e.home_phone from employees e where e.region is null;

begin transaction;
select COUNT(*) from customers where region is not null;
end;

select s.country, count(*) as suppliers_count from suppliers s group by s.country order by suppliers_count desc;

select o.ship_country, sum(o.freight) as sum_freight from orders o where o.ship_region is not null group by o.ship_country having sum(o.freight) > 2750 order by sum_freight desc;

select c.country from customers c union select s.country from suppliers s order by country;

select c.country from customers c intersect select s.country from suppliers s intersect select e.country from employees e;

select c.country from customers c intersect select s.country from suppliers s except select e.country from employees e;