/*Number of rows in the dataset*/
select count(*) from project.data1;
select count(*) from project.data2;

/*Dataset for Jharkand and Bihar*/
select * from project.data1 where state in ('Jharkhand','Bihar')
order by state;

/*Population of India*/
select sum(REPLACE(population, ',', '')) as population from project.data2;

/*Average population growth*/
select round(avg(growth),2) as growth_avg from project.data1;

/*Average population growth by state*/
select state,round(avg(growth),2) as growth_avg from project.data1 group by state;

/*Top 3 state showing highest growth ratio*/
select state,round(avg(growth),2) as growth_avg 
from project.data1 group by state order by 2 desc limit 3;

/*Average sex ratio*/
select round(avg(sex_ratio),2) as sex_ratio_avg from project.data1;

/*Average sex ratio by state*/
select state,round(avg(sex_ratio),0) as sex_ratio_avg from project.data1 group by state order by 2 desc;

/*Average literacy rate by state*/
select state,round(avg(literacy),0) as literacy_rate_avg from project.data1 group by state order by 2 desc;

/*Average literacy rate of state greater than 90*/
select state,round(avg(literacy),0) as literacy_rate_avg 
from project.data1 group by state 
having round(avg(literacy),0)>90 order by 2 desc;

/*Bottom 3 State in terms of literacy rate */
select state,round(avg(literacy),0) as literacy_rate_avg 
from project.data1 group by state 
 order by 2 limit 3;
 
 /*Bottom 3 State in terms of sex_ratio */
select state,round(avg(sex_ratio),0) as sex_ratio_avg 
from project.data1 group by state order by 2 limit 3;

 /*Top and Bottom 3 State in terms of sex_ratio */
with cte as (select state,round(avg(sex_ratio),0) as sex_ratio_avg
from project.data1 group by state order by 2 desc limit 3),
cme as(
select state,round(avg(sex_ratio),0) as sex_ratio_avg
from project.data1 group by state order by 2 asc limit 3)
select *,CONCAT('Top',' ',row_number() over()) as status from cte 
union 
select *,CONCAT('Bottom',' ',row_number() over()) as status from cme;


 /*Top and Bottom 3 State in terms of literacy rate */
with cte as (select state,round(avg(literacy),0) as literacy_rate_avg 
from project.data1 group by state order by 2 desc limit 3),
cme as(select state,round(avg(literacy),0) as literacy_rate_avg 
from project.data1 group by state order by 2 asc limit 3)
select *,CONCAT('Top',' ',row_number() over()) as status from cte 
union 
select *,CONCAT('Bottom',' ',row_number() over()) as status from cme;


/*States starting with letter a or ending with letter r*/
select distinct(state) from project.data1 
where state like 'a%' or state like '%r';


/*No of Males and Females in Districts*/
with cte as (select a.district,a.state,a.sex_ratio,b.population 
from project.data1 a join project.data2 b on a.district=b.district)

select *,(REPLACE(population, ',', ''))-round(REPLACE(population, ',', '')/(1+(1000/sex_ratio)),0) as males,
round(REPLACE(population, ',', '')/(1+(1000/sex_ratio)),0) as females
 from cte;


/*No of Males and Females in States*/
with cte as (select a.district,a.state,a.sex_ratio,b.population 
from project.data1 a join project.data2 b on a.district=b.district),
cme as(
select *,(REPLACE(population, ',', ''))-round(REPLACE(population, ',', '')/(1+(1000/sex_ratio)),0) as males,
round(REPLACE(population, ',', '')/(1+(1000/sex_ratio)),0) as females
 from cte)
 select state,sum(males) as total_males,sum(females) as total_females
 from cme group by 1;
 
 
/*Total literate and illiterate people in different districts*/
with cte as (select a.district,a.state,a.literacy,(REPLACE(b.population, ',', '')) as population
from project.data1 a join project.data2 b on a.district=b.district),
cme as (
select *,round((literacy*population/100),0) as total_literate_people,
population-round((literacy*population/100),0) as total_illiterate_people from cte )
select * from cme;

/*Total literate and illiterate people in different states*/
with cte as (select a.district,a.state,a.literacy,(REPLACE(b.population, ',', '')) as population
from project.data1 a join project.data2 b on a.district=b.district),
cme as (
select *,round((literacy*population/100),0) as x,
population-round((literacy*population/100),0) as y from cte ) 
select state,sum(population),sum(x) as total_literate_people,sum(y) as total_illiterate_people
 from cme group by 1;
 
 
/*Population in previous census with respect to different district*/
select a.district,a.state,a.growth,round((REPLACE(b.population, ',', '')*100/(100+a.growth)),0) as previous_population,b.population 
from project.data1 a join project.data2 b on a.district=b.district;


/*Population in previous census*/
with cte as (select a.district,a.state,a.growth,round((REPLACE(b.population, ',', '')*100/(100+a.growth)),0) as previous_population,b.population 
from project.data1 a join project.data2 b on a.district=b.district)
select sum(previous_population),sum(REPLACE(population, ',', '')) from cte;

/*Population vs area*/
with cte as (select a.district,a.state,replace(b.Area_km2,',','') as a,replace(b.population,',','') as x
from project.data1 a join project.data2 b on a.district=b.district)
select *,round(x/a,0) as People_in_km2 from cte;

/*Top 3 districts from each state with highest literacy rate*/
with cte as (select a.state,a.district,a.literacy,rank() over(partition by a.state order by a.literacy desc) as top_rank
from project.data1 a join project.data2 b on a.district=b.district)
select * from cte
where top_rank<4








