drop table if exists appstore_games

create table appstore_games (
	URL text,
	ID bigint,
	app_name text,
	subtitle text,
	Icon_URL text,
	Average_user_rating int,
	User_rating_count int,
	price int,
	In_app_purchases int,
	Description text,
	Developer text,
	Age_rating int,
	Languages text,
	App_size bigint,
	Primary_genre text,
	Genres text,
	Original_release_date date,
	Current_version_release_date date
);


select *
from appstore_games

--top 10 most popular games by rating_count
select app_name, user_rating_count, primary_genre, genres, languages
from appstore_games
where user_rating_count is not null
order by user_rating_count desc
limit 10

--top 10 most popular languages used including English
select languages, count(languages)
from appstore_games
where languages like '%EN%'
group by languages 
order by count desc

--top 10 game developer who released the most games
select developer, count(*)
from appstore_games
group by developer 
order by count desc
limit 10

--average price of apps by age rating
select distinct(age_rating), count(*), round(avg(price),2) as avg_price
from appstore_games ag
where price is not null and price != '0' and price < '100'
group by age_rating
order by count desc

--app size and release_date relation
select extract(year from original_release_date) as release_year, count(*), round(avg(app_size)) as avg_app_size
from appstore_games
where app_size is not null
group by release_year
order by release_year