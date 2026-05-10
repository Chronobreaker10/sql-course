select 
	year
	, month
	, income
	, avg(income) over roll_frame as roll_avg
from expenses
window roll_frame as (order by year, month rows between 1 preceding and current row)
order by year, month;

select
	id
	, name
	, department
	, salary
	, sum(salary) over (partition by department order by id) as total
from employees
order by department, salary, id;

select
	id
	, name
	, department
	, salary
	, sum(salary) over (partition by department order by salary rows between unbounded preceding and current row) as total
from employees
order by department, salary, id;

select *, string_agg(trim(name), ', ') over (partition by department order by name) as names from employees;

select 
	id
	, name
	, department
	, salary
	, first_value(salary) over prev_dep_frame as prev_salary
	, last_value(salary) over prev_dep_frame as max_salary
from employees
window prev_dep_frame as (partition by department order by salary, id rows between 1 preceding and unbounded following)
order by department, salary, id;

select 
	id
	, name
	, salary
	, count(id) over (order by salary desc groups between unbounded preceding and current row) as ge_cnt 
from employees 
order by ge_cnt desc;

select
	id
	, name
	, salary
	, nullif(last_value(salary) over (order by salary groups between current row and 1 following), salary) as next_salary
from employees;

select
	id
	, name
	, salary
	, last_value(salary) over (order by salary groups between 1 following and 1 following) as next_salary
from employees;