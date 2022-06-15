-- entire table
select *
from k_income ki 

--job_code table
select *
from job_code

-- entire income above $0
select income
from k_income ki 
where income < 0

-- total case
select count(income)
from k_income ki 

-- excluding negative income
select count(income)
from k_income ki 
where income >= 0

--grouping ages and selecting average income by age_group
select case when year_born between 1910 and 1920 then '10/20'
	when year_born between 1920 and 1930 then '20/30'
	when year_born between 1930 and 1940 then '30/40'
	when year_born between 1940 and 1950 then '40/50'
	when year_born between 1950 and 1960 then '50/60'
	when year_born between 1960 and 1970 then '60/70'
	when year_born between 1970 and 1980 then '70/80'
	when year_born between 1980 and 1990 then '80/90'
	when year_born between 1990 and 2000 then '90/00'
	when year_born between 2000 and 2010 then '00/10'
	else 'n/a' end as age_group,
	round(avg(income)) as average_income, count(income) as number_worker, round(count(income) * 100.0 / (select count(*) from k_income)) as percentage
from k_income as k
where income > 0
group by age_group
order by age_group asc

-- average income based on education level
select education_level, round(avg(income))
from k_income
where income > 0
group by education_level
order by education_level

--joining income_table and job_code table
select *
from k_income as ki
join job_code as jc
on ki.occupation = jc.job_code

--test query
select jc.job_code, 
	case when jc.id is null then job_code/10 
	when jc.id is not null then jc.id end as filled_id
from k_income as ki
join job_code as jc
on ki.occupation = jc.job_code


--average income by occupation
select case when jc.id is null then job_code/10 
	when jc.id is not null then jc.id end as filled_id,
	round(avg(income)) as avg_income
from k_income as ki
join job_code as jc
on ki.occupation = jc.job_code
group by filled_id
order by filled_id

--Top 10 income occupation
select round(avg(income)) *10.0 as avg_income, job_title
from k_income as ki
join job_code as jc
on ki.occupation = jc.job_code
group by job_title
order by avg_income desc
limit 10


--Low 10 income occupation
select case when jc.id is null then job_code/10 
	when jc.id is not null then jc.id end as filled_id,
	round(avg(income)) as avg_income, job_title
from k_income as ki
join job_code as jc
on ki.occupation = jc.job_code
group by filled_id, job_title
order by avg_income asc
limit 10

-- average income by gender and age_group
select case when year_born between 1910 and 1920 then '10/20'
	when year_born between 1920 and 1930 then '20/30'
	when year_born between 1930 and 1940 then '30/40'
	when year_born between 1940 and 1950 then '40/50'
	when year_born between 1950 and 1960 then '50/60'
	when year_born between 1960 and 1970 then '60/70'
	when year_born between 1970 and 1980 then '70/80'
	when year_born between 1980 and 1990 then '80/90'
	when year_born between 1990 and 2000 then '90/00'
	when year_born between 2000 and 2010 then '00/10'
	else 'n/a' end as age_group, round(avg(income)) as avg_income, 
	case when gender = '1' then 'male'
	when gender = '2' then 'female' end as gender
from k_income
group by age_group, gender
order by age_group, gender


--region distribution and avg_income by region
select region, count(*), count(*) * 100.0 / (select count(region) from k_income) as percentage, avg(income) as avg_income
from k_income
group by region
order by regioner


--Occupation distribution
select job_title, count(*), count(*) * 100.0 / (select count(occupation) from k_income as ki inner join job_code as jc on ki.occupation = jc.job_code) as percentage
from k_income as ki
inner join job_code as jc 
on ki.occupation = jc.job_code 
group by occupation, job_title
order by percentage desc

--Occupation distribution by gender
select job_title, count(*) as num
from k_income as ki
inner join job_code as jc 
on ki.occupation = jc.job_code
where gender = '2'
group by job_title
order by num desc

-- number of workers by gender
select count(*)
from k_income ki
inner join job_code as jc 
on ki.occupation = jc.job_code 
where gender = '2' and occupation is not null


--religion and occupation distribution relation
select job_title, count(*) as num
from k_income ki 
inner join job_code as jc 
on ki.occupation = jc.job_code 
where religion = '1'
group by job_title
order by num desc

-- education level and occupation relation
select job_title, count(*), education_level
from k_income as ki
inner join job_code as jc 
on ki.occupation = jc.job_code 
where education_level = '9'
group by job_title, education_level
order by count desc
limit 5
