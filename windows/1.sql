select month, year, sum(revenue) over() as total_revenue from revenues order by year, month;

select month, year, sum(revenue) over(partition by year) as year_revenue from revenues order by year, month;

select month, year, revenue, round(revenue::numeric * 100 / sum(revenue) over (partition by year), 1) as month_percent from revenues order by year, month;

select id, name, count, price, sum(count * price) over () as total from products;

select id, name, count, price, round((count * price) * 100.0 / sum(count * price) over (), 1) as percent from products order by percent desc, id;

select 
	id
	, name
	, country
	, population
	, sum(population) over (partition by country) as country_population
	, round(population * 100.0 / sum(population) over (partition by country), 2) as percent
from cities order by country_population, population;

select 
	id
	, name
	, country
	, population
	, round(population * 100.0 / sum(population) over (), 2) as world_percent
from cities order by world_percent desc;