with flats_with_rn as (
	select *, row_number() over (order by price) as rn from flats where rooms > 1
)

select street, house, price, rooms from flats_with_rn where rn <= 3 order by rooms desc, price;

select * from flats;

with flats_with_dr as (
	select *, dense_rank() over (partition by rooms order by price) as dr from flats where rooms > 1
)

select street, house, price, rooms from flats_with_dr where dr <= 3 order by rooms, price;

with flats_with_dr as (
	select *, dense_rank() over (order by price) as dr from flats where rooms > 1
)

select street, house, price, rooms from flats_with_dr where dr <= 3 order by rooms desc, price;

select * from cyber_results where team_id = 6;
select * from cyber_teams;
select * from cyber_games;

with results_with_points as (
	select 
		ct.team
		, sum((cr.kills - cr.deaths) * 3) as points from cyber_results cr
	join cyber_teams ct on cr.team_id = ct.id 
	group by ct.team
)

select *, dense_rank() over (order by points desc) as place from results_with_points order by place, team;