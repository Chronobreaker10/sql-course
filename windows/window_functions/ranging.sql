select dense_rank() over (order by salary desc) as salary_rank, * from employees order by salary desc, id;

select dense_rank() over (order by name) as salary_rank, * from employees order by name;

select dense_rank() over (partition by department order by salary desc) as salary_rank, * from employees order by department, salary desc, id;

select 
	dense_rank() over city_window as salary_rank, * 
from employees
window city_window as (partition by city order by salary desc)
order by city, salary_rank, id;

select ntile(3) over (order by salary desc), * from employees order by department, salary desc, id;

select ntile(2) over (partition by city order by salary) ,* from employees order by city, salary;

select id, name, department, salary
from (select *, dense_rank() over (partition by department order by salary desc) as salary_rank from employees)
where salary_rank = 1 order by department, salary desc;