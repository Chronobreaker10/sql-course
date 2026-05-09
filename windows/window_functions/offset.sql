select *, round((salary - lag(salary, 1) over (order by salary)) * 100.0 / salary) as diff from employees order by salary, id;

select id, name, city, department
	, lag(salary, 1) over salary_window as prev
	, salary
	, lead(salary, 1) over salary_window as next
from employees
window salary_window as (order by salary)
order by salary, id;

select *, first_value(salary) over dep_salary_window as min_salary, last_value(salary) over dep_salary_window as max_salary 
from employees
window dep_salary_window as (partition by department order by salary rows between unbounded preceding and unbounded following)
order by department, salary, id;

select *, round(salary * 100.0 / last_value(salary) over city_salary_window) as percent
from employees
window city_salary_window as (partition by city order by salary rows between unbounded preceding and unbounded following)
order by city, salary;