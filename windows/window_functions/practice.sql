select
	year
	, month
	, revenue
	, lag(revenue, 1) over (order by month) as prev
	, round(revenue *  100.0 / lag(revenue, 1) over (order by month)) as perc
from sales
where year = 2020 and plan = 'gold'
order by month;

select
	plan
	, year
	, month
	, revenue
	, sum(revenue) over (partition by plan order by month) as total
from sales
where year = 2020 and month <= 3
order by plan, month;

select
	year
	, month
	, revenue
	, round(avg(revenue) over (order by month rows between 1 preceding and 1 following)) as avg3m
from sales
where year = 2020 and plan = 'platinum'
order by month;

select
	year
	, month
	, revenue
	, nth_value(revenue, 12) over full_frame_by_years as december
	, round(revenue * 100.0 / nth_value(revenue, 12) over full_frame_by_years) as perc
from sales
where plan = 'silver'
window full_frame_by_years as (
	partition by year order by month rows between unbounded preceding and unbounded following
)
order by year, month;

select
	year
	, plan
	, sum(revenue) as revenue
	, sum(sum(revenue)) over (partition by year) as total
	, round(sum(revenue) * 100.0 / sum(sum(revenue)) over (partition by year)) as perc
from sales
group by year, plan
order by year, plan;

select
	year
	, month
	, sum(revenue) as revenue
	, ntile(3) over (order by sum(revenue) desc) as tile 
from sales
where year = 2020
group by year, month
order by revenue desc;

with quarter_revenues_with_prev as (
	select
		year
		, ceil(month / 3.0) as quarter
		, sum(revenue) as revenue
		, lag(sum(revenue)) over(partition by ceil(month / 3.0) order by year) as prev
	from sales
	group by year, (ceil(month / 3.0))
	order by year, quarter
)

select year, quarter, revenue, prev, round(revenue * 100.0 / prev) as perc 
from quarter_revenues_with_prev 
where year = 2020 
order by quarter;

with plan_quantities_2020 as (
	select
		year
		, month
		, sum(quantity) filter (where plan = 'silver') over plan_frame as silver
		, sum(quantity) filter (where plan = 'gold') over plan_frame as gold
		, sum(quantity) filter (where plan = 'platinum') over plan_frame as platinum
	from sales
	where year = 2020
	window plan_frame as (partition by plan order by quantity desc)
)

select 
	year
	, month
	, rank() over (order by sum(silver)) as silver
	, rank() over (order by sum(gold)) as gold
	, rank() over (order by sum(platinum)) as platinum
from plan_quantities_2020
group by year, month
order by month;