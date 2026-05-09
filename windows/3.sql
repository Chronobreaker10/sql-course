select genre, row_number() over (partition by genre order by rating desc) as genre_place, rating, name from films order by genre, genre_place;

select id, last_name, first_name, points, row_number() over (order by points desc) as place from results order by id;

select id, last_name, first_name, points, time, row_number() over (order by points desc, time) as place from results order by place;

select *, row_number() over (partition by genre order by rating desc) as genre_place from films

select 
	name
	, rating
	, genre
	, genre_place
from (select *, row_number() over (partition by genre order by rating desc) as genre_place from films)
where genre_place <= 2
order by rating desc;

select * from films;

select round(year / 10) * 10 as decade, row_number() over(partition by round(year / 10) * 10 order by rating desc) as place, name from films order by decade, place;