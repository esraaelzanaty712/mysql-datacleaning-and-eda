#eda 
use firstproject;
 SELECT * FROM newlayoffs1;
 
 select min(`date`) , max(`date`) from newlayoffs;
 
SELECT company , MAX(total_laid_off) FROM newlayoffs1 
GROUP BY company 
ORDER BY 2 DESC;

SELECT company , AVG(percentage_laid_off) FROM newlayoffs1 
GROUP BY company 
ORDER BY 2 DESC;

SELECT industry , MAX(total_laid_off) FROM newlayoffs1 
GROUP BY industry 
ORDER BY 2 DESC;

SELECT country , MAX(total_laid_off) FROM newlayoffs1 
GROUP BY country 
ORDER BY 2 DESC;

SELECT year(`date`) as `year` , MAX(total_laid_off) FROM newlayoffs1 
GROUP BY `year` 
ORDER BY 2 DESC;

SELECT substring(`date` , 1 ,7) as `month` , MAX(total_laid_off) FROM newlayoffs1 
GROUP BY `month` 
ORDER BY 2 DESC;

SELECT substring(`date` , 1 ,7) as `month` , MAX(total_laid_off) FROM newlayoffs1 
GROUP BY `month` 
ORDER BY 2 ASC;

with rolling_total as
(
	select substring(`date` , 1 ,7) as `month` , sum(total_laid_off) as total_off
    FROM newlayoffs1 
    where substring(`date` , 1 ,7) is not null
	GROUP BY `month`
	ORDER BY 1 ASC
)
select `month` , total_off , sum(total_off) over(ORDER BY `month`) from rolling_total;


SELECT company , SUM(total_laid_off) FROM newlayoffs1 
GROUP BY company 
ORDER BY 2 DESC;

SELECT company ,year(`date`) as `year`, SUM(total_laid_off) FROM newlayoffs1 
GROUP BY company , `year`
ORDER BY 3 DESC;

with company_year(company , `year` , total_laid_off) as
(
SELECT company ,year(`date`) as `year`, SUM(total_laid_off) FROM newlayoffs1 
GROUP BY company , `year`
), company_year_rank as (
select * , dense_rank() over(partition by `year` order by total_laid_off desc) as ranking
from company_year 
where `year` is not null
)
select * from company_year_rank
where ranking <= 5;

select company , industry , SUM(total_laid_off) AS total_laid_off
from newlayoffs1 
where (industry is not null or industry = '') and total_laid_off is not null 
GROUP BY company , industry
ORDER BY total_laid_off desc;

;