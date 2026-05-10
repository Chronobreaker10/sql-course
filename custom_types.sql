create type salary_boundaries as (
	min_salary numeric,
	max_salary numeric
);

CREATE OR REPLACE FUNCTION get_salary_boundaries_by_city(emp_city varchar)
returns salary_boundaries AS 
$$
	SELECT MIN(salary) AS min_salary,
	   	   MAX(salary) AS max_salary
  	FROM employees
	WHERE city = emp_city
$$ LANGUAGE SQL;

select * from get_salary_boundaries_by_city('London');

create type army_ranks as enum ('Private', 'Corporal', 'Sergeant');

alter type army_ranks add value 'Major' after 'Sergeant';

select enum_range(null::army_ranks);

create table army_staff (
	person_id int primary key generated always as identity,
	first_name varchar(50) not null,
	last_name varchar(50) not null,
	person_rank army_ranks default 'Private'
);

insert into army_staff(first_name, last_name, person_rank) values
('Иван', 'Петров', 'Corporal'),
('Сергей', 'Быков', 'Sergeant'),
('Петр', 'Кругов', 'Major');

insert into army_staff(first_name, last_name) values ('Денис', 'Герасимов');

select * from army_staff;