select 
	id
	, name
	, salary
	, count(*) over (order by salary range between current row and 10 following) as p10_cnt 
from employees 
order by salary, id;

select 
	id
	, name
	, salary
	, max(salary) over (order by salary range between 30 preceding and 10 preceding) as lower_sal 
from employees 
order by salary, id;

select
	id
	, name
	, salary
	, round(avg(salary) 
	over (
		order by salary 
		range between current row and 20 following
		exclude current row
	)) as p20_sal
from employees
order by salary, id

select e.id, name, e.department, e.salary
	, sum(e.salary) over () as sum_salaries_exclude_current
	, sum(e.salary * 1.1) over salaries_exclude_current as sum_increased_salaries_exclude_current
	, sum(nt.salary * 1.5) over salaries_exclude_current as sum_increased_salaries_exclude_it
from employees e
left join (
	select id, salary, department
	from employees
	where department != 'it'
) as nt on nt.id = e.id
window salaries_exclude_current as (order by e.salary rows between unbounded preceding and unbounded following exclude current row)
order by e.department, e.salary, e.id

select id, name, department, salary
	, sum(salary) over () as sum_salaries_exclude_current
	, sum(salary * 1.1) over salaries_exclude_current as sum_increased_salaries_exclude_current
	, sum(salary * 1.5) filter (where department != 'it') over salaries_exclude_current as sum_increased_salaries_exclude_it
	, sum(case when department = 'it' then salary else salary * 1.1 end) over salaries_exclude_current as sum_increased_salaries_without_it
from employees
window salaries_exclude_current as (order by salary rows between unbounded preceding and unbounded following exclude current row)
order by department, salary, id

select 
	id
	, name
	, salary
	, round(salary * 100 / avg(salary) over ()) as perc
	, round(salary * 100 / avg(salary) filter (where city = 'Москва') over ()) as msk 
	, round(salary * 100 / avg(salary) filter (where city = 'Самара') over ()) as sam 
from employees 
order by id;
