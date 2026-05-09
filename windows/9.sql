with 
	incomes_in_2020 as (select month, income from revenues where year = 2020)
	, incomes_in_2021 as (select month, income from revenues where year = 2021)

select 
	coalesce(i2020.month, i2021.month) as month
	, i2020.income as in2020
	, i2021.income as in2021
	, i2021.income - i2020.income as diff
from incomes_in_2020 i2020
full join incomes_in_2021 i2021 on i2020.month = i2021.month
order by month;

with incomes_by_month as (
	SELECT 
    	month,
        year,
        income,
        LAG(income) OVER (PARTITION BY month order by year) AS prev_year_income,
        ntile(4) over() as quarter
	FROM revenues
)

select 
	month,
	coalesce(prev_year_income, 0) as in2020,
	income as in2021, 
	income - coalesce(prev_year_income, 0) as diff
from incomes_by_month 
where year = 2021
order by month;

with incomes_with_quarters as (
	SELECT 
    	month,
        year,
        income,
        LAG(income) OVER (PARTITION BY month order by year) AS prev_year_income,
        ceiling(month / 3.0) AS quarter
	FROM revenues
)


select 
	quarter,
	sum(coalesce(prev_year_income, 0)) as in2020,
	sum(income) as in2021, 
	sum(income) - sum(coalesce(prev_year_income, 0)) as diff
from incomes_with_quarters 
where year = 2021
group by quarter
order by quarter;

select * from revenues;

with incomes_with_prev as (
	SELECT 
    	month,
        year,
        income,
        LAG(income) OVER (PARTITION BY month order by year) AS prev_year_income
	FROM revenues
)


select month, round(income / prev_year_income::float * income) as plan from incomes_with_prev where year = 2021;


select
	dense_rank() over(order by end_time - start_time) as place
	, first_name
	, last_name
	, end_time - start_time as time
	, end_time - start_time - first_value(end_time - start_time) over(order by end_time - start_time) as champion_lag
from runners
order by place;