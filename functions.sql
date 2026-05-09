drop function if exists customers_backup;

create or replace function customers_backup() returns void as $$
	drop table if exists customers_backup;
	create table customers_backup as select * from customers;
	-- select * into customers_backup from customers;
$$ language sql

select customers_backup();

select * from customers_backup;

drop function if exists get_avg_freight;

create or replace function get_avg_freight() returns float8 as $$
	select avg(o.freight) from orders o;
$$ language sql

select * from get_avg_freight() as avg_freight;

drop function if exists get_random_in_boundaries;

create or replace function get_random_in_boundaries(a int, b int) returns int as $$
begin
	return floor(random() * (b - a + 1) + a) :: int;
end;
$$ language plpgsql

select get_random_in_boundaries(12, 20) from generate_series(1, 10);

alter table employees add column salary numeric default null;
update employees set salary = get_random_in_boundaries(0, 1000);

drop function if exists get_min_max_salary_by_city;

create or replace function get_min_max_salary_by_city(city varchar(15), out min_salary numeric, out max_salary numeric) as $$
	select min(e.salary), max(e.salary) from employees e where e.city = city
$$ language sql

select * from get_min_max_salary_by_city('London');

drop function if exists correct_salary;

create or replace function correct_salary(percent int default 15, level numeric default 70) 
returns table (last_name varchar, first_name varchar, title varchar, salary numeric) as $$
	update employees set salary = salary + (salary * 15 / 100) where salary <= level
	returning last_name, first_name, title, salary;
$$ language sql;

select * from employees e order by salary;

select * from correct_salary(10, 200);

select * from orders;

select * from order_details;

drop function if exists get_orders_by_delivery_method;

create or replace function get_orders_by_delivery_method (delivery_method int) returns setof orders
as $$
declare
	max_freight numeric;
	avg_freight numeric;
	criterion numeric;
begin
	select max(freight), avg(freight) into max_freight, avg_freight from orders o where o.ship_via = delivery_method;
	max_freight := max_freight - (max_freight * 0.3);
	criterion := (max_freight + avg_freight) / 2;
	return query select * from orders o where o.freight < criterion;
end;
$$ language plpgsql;

select count(*) from get_orders_by_delivery_method(1);

drop function if exists should_increase_salary;

create or replace function should_increase_salary(current_salary numeric, max_salary numeric default 80, min_salary numeric default 30, rate numeric default 20)
returns bool as $$
declare
	increased_salary numeric;
begin
	if min_salary >= max_salary then
		raise exception 'Минимальная зп (%) не может быть больше максимальной (%)', min_salary, max_salary using hint = 'Введите корректные значения', errcode = 12882;
	elseif min_salary < 0 then
		raise exception 'Минимальная зп (%) не может быть меньше 0', min_salary using hint = 'Введите значение больше нуля', errcode = 12882;
	elseif max_salary < 0 then
		raise exception 'Максимальная зп (%) не может быть меньше 0', max_salary using hint = 'Введите значение больше нуля', errcode = 12882;
	elseif rate < 5 then
		raise exception 'Коэффициент повышения (%) не может быть меньше 5%%', rate using hint = 'Введите значение больше 5', errcode = 12882;
	end if;
	if current_salary >= min_salary then
		return false;
	else
		increased_salary := current_salary * (1 + rate / 100.0);
		if increased_salary > max_salary then 
			return false;
		else 
			return true;
		end if;
	end if;
end
$$ language plpgsql;

select should_increase_salary(40, 80, 30, 20);
select should_increase_salary(79, 81, 80, 20);
select should_increase_salary(79, 95, 80, 20);

select (order_date + interval '1 week')::date as order_date from orders where order_id = 10248;

select should_increase_salary(79, 95, 150, 20);
select should_increase_salary(79, -19, -100, 20);
select should_increase_salary(79, 95, -100, 20);
select should_increase_salary(79, 95, 70, 1);

drop function if exists get_avg_freight_by_countries;

create or replace function get_avg_freight_by_countries(variadic countries varchar[]) 
returns setof float as $$
begin
	return query select avg(freight) from orders where ship_country = any(countries);
end;
$$ language plpgsql;

select get_avg_freight_by_countries('USA', 'Germany');

drop function if exists filter_phone_numbers;

create or replace function filter_phone_numbers(code char(3), variadic phone_numbers varchar[]) 
returns setof varchar as $$
declare
	phone_number varchar;
begin
	foreach phone_number in array phone_numbers
	loop
		if phone_number like '__(' || code || ')%' then 
			return next phone_number;
		end if;
	end loop;
end;
$$ language plpgsql;

select filter_phone_numbers('903', '+7(903)1901235', '+7(926)8567589', '+7(903)1532476')