select *
	, sum(salary) over(partition by department) as fund
	, round(salary * 100.0 / sum(salary) over(partition by department)) as percent
from employees order by department, salary, id;

select *
	, sum(salary) over(partition by city) as fund
	, round(salary * 100.0 / sum(salary) over(partition by city)) as percent
from employees order by city, salary;


select *
	, count(id) over(partition by department) as emp_cnt
	, round(avg(salary) over(partition by department)) as sal_avg
	, round((salary / avg(salary) over(partition by department) - 1) * 100.0) as diff
from employees order by department, salary;

with emp as (
select *
	, sum(salary) over(partition by department) as fund
from employees order by department, salary, id)

select name, salary, fund from emp where city = 'Самара';

select
  city,
  department,
  sum(salary) as dep_salary,
  sum(sum(salary)) over (partition by city) as x,
  sum(sum(salary)) over () as y
from employees
group by city, department
order by city, department;
