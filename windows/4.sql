select * from bloggers;

select row_number() over (order by subs desc, avg_likes desc, avg_comments desc) as num, blogger, subs, avg_likes, avg_comments from bloggers;

with post_popularities as (
	select 
		row_number() over (partition by blogger order by likes desc) as post_popularity
		, blogger
		, post
		, likes
		, sum(likes) over() as sum_likes
	from bloggers_posts 
	order by blogger, likes desc
)


select 
	blogger
	, post
	, likes
	, sum(likes) over() as total_likes
	, round(likes * 100.0 / sum(likes) over(), 2) as percent 
from post_popularities where post_popularity < 2
order by likes desc;


select 
	blogger
	, post
	, likes
	, sum(likes) over() as total_likes
	, round(likes * 100.0 / sum_likes, 2) as percent 
from post_popularities where post_popularity < 2
order by likes desc;