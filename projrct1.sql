use firstproject;
select * from layoffs;
#make another table with the same data but to work on 
create table newlayoffs
like layoffs;

insert into newlayoffs 
select * from layoffs;

select * from newlayoffs;

#1:remove duplicates
#if roenumber=1 not duplicate (unique)
select * , 
row_number() over(partition by company , industry , total_laid_off , percentage_laid_off ,`date` ) as row_num
from newlayoffs;

CREATE TABLE `newlayoffs1` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL, 
  row_num int 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into newlayoffs1
select * , 
row_number() over(partition by company , industry , total_laid_off , percentage_laid_off ,`date` ) as row_num
from newlayoffs;

select * from newlayoffs1;

delete FROM newlayoffs1 WHERE row_num > 1 ;

select  distinct country, trim(country)
from newlayoffs1
order by 1;

update newlayoffs1
set country = trim(trailing '.' from country)
where country like 'United States%' ;

select `date` , str_to_date(`date` , '%m/%d/%Y')
from newlayoffs1;



update newlayoffs1 
set `date` = str_to_date(`date` , '%m/%d/%Y') ;

alter table newlayoffs1 
modify column `date` date; 

select * from newlayoffs1
where industry is null;

update newlayoffs1 
set industry = null 
where industry ='';

update newlayoffs1 t1
join newlayoffs1 t2
on t1.company =t2.company 
set t1.industry = t2.industry 
where t1.industry is null 
and t2.industry is not null ;

delete from newlayoffs1
where total_laid_off is null
and percentage_laid_off is null;

alter table newlayoffs1
drop column row_num;

select * from newlayoffs1;