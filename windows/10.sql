select 
	month
	, income
	, income - nth_value(income, 4) over full_frame as diff 
	, round(
		(income - nth_value(income, 4) over full_frame) * 100.0 / nth_value(income, 4) over full_frame, 1
	) as diff_percent
from revenues 
where year = 2021
window full_frame as (order by month rows between unbounded preceding and unbounded following)
order by month;

select
	year
	, month
	, income
	, income - nth_value(income, 4) over full_frame as diff 
	, round(
		(income - nth_value(income, 4) over full_frame) * 100.0 / nth_value(income, 4) over full_frame, 1
	) as diff_percent
from revenues
window full_frame as (partition by year order by month rows between unbounded preceding and unbounded following)
order by year, month;

with full_plan as (
	select
		year,
		month,
		income,
		avg(income) over move_avg,
		round(income * avg(income) over move_avg / avg(income) over prev_year) as plan
	from revenues
	window 
		move_avg as (partition by year order by month rows between 2 preceding and current row)
		, prev_year as (order by year, month rows between 14 preceding and 12 preceding)
	order by year, month
)
select month, plan from full_plan where year = 2021;