select * from products;
update products set name = trim(name);
select name, price from products where char_length(name) between 5 and 10 order by name;

select * from passports;
select user_id, concat(TO_CHAR(series, 'FM0000'), ' ', TO_CHAR(number, 'FM000000')) from passports order by series, number;

select * from domains;
update domains set domain = rtrim(domain, '.');

select * from users where age >= 18 and last_name like '%ова' order by age, last_name;

select id, last_name || ' ' || first_name || ' ' || patronymic as name from users where length(patronymic) > 0 order by last_name, first_name, patronymic;

select id, left(passport, 4) as series, right(passport, 6) as number from users where passport is not null;

alter table users add column first_name varchar(50) default '';
alter table users add column last_name varchar(50) default '';
update users set first_name = split_part(name, ' ', 1);
update users set last_name = split_part(name, ' ', 2);
alter table users drop column name; 
select * from users;