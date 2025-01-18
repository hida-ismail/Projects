CREATE DATABASE Work;
use work;

-- To ensure the code works correctly, please import the layoff.csv file into your database. 
-- In MySQL Workbench, go to the 'work' schema, right-click on 'Tables,' and select 'Table Data Import Wizard.' 
-- Choose the layoff.csv file, map the columns as needed, and complete the import process.

select * from layoffs;
-- 1. REMOVR DUPLICATES
-- 2. STANDARDIZE THE DATA
-- 3. NULL VALUES OR BLANK VALUES
-- 4. REMOVE ANY COLUMNS

-- COPY OF layoffs TABLE (creating a copy of own raw data then working on it, so we have always have original data)
CREATE TABLE layoffs_staging LIKE layoffs;
INSERT INTO layoffs_staging select * from layoffs;
select * from layoffs_staging;

-- 1. Removing duplicates 
with duplicate_cte as
(select *, row_number() over(partition by  
company,location, industry,total_laid_off, percentage_laid_off,`date`,stage,country,funds_raised_millions) as rownumber
from layoffs_staging
)
select * from duplicate_cte where rownumber>1;  -- cte is a select statemnet (for veiwing) not a table so create another table with a col row_number

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_number` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into layoffs_staging2 
select *, row_number() over(partition by  
company,location, industry,total_laid_off, percentage_laid_off,`date`,stage,country,funds_raised_millions) as rownumber
from layoffs_staging;

delete from layoffs_staging2 where `row_number`>1;
select * from layoffs_staging2 where `row_number`>1; -- removed duplicates
select * from layoffs_staging2;

-- 2. STANDARDIZE THE DATA
select company, trim(company) from layoffs_staging2; -- remove extra spaces from company column
update layoffs_staging2 set company=trim(company);

select distinct(industry) from layoffs_staging2 order by 1; -- update industry row that are same but with alternate names
select * from layoffs_staging2 where industry like 'Crypto%';
update layoffs_staging2 set industry="Crypto" where industry like 'Crypto%';

select distinct(country) from layoffs_staging2 order by country; 
select distinct(country),trim(trailing "." from country) from layoffs_staging2 order by country; -- trim as united states was with a '.'
update layoffs_staging2 set country=trim(trailing "." from country) where country="United States%";

select `date` from layoffs_staging2 ; -- changed date datatype text to data
select `date`,str_to_date(`date`,"%m/%d/%Y") from layoffs_staging2;
update layoffs_staging2 set `date`=str_to_date(`date`,"%m/%d/%Y");
alter table layoffs_staging2 modify column `date` Date;

-- 3. NULL VALUES OR BLANK VALUES
update layoffs_staging2 set industry=NULL where industry ="";
select * from layoffs_staging2 where industry is null or industry ="";
select * from layoffs_staging2 where company in ("Airbnb","Bally's Interactive","Carvana","Juul");

select t1.industry,t2.industry from layoffs_staging2 t1 join layoffs_staging2 t2 on t1.company=t2.company and t1.location=t2.location where (t1.industry is null or t1.industry="") and t2.industry is not null;
update layoffs_staging2 t1 join layoffs_staging2 t2 on t1.company=t2.company set t1.industry=t2.industry where (t1.industry is null or t1.industry="") and t2.industry is not null;

-- 4. REMOVE ANY COLUMNS AND UNNECESSARY ROWS
select * from layoffs_staging2 where percentage_laid_off is null and total_laid_off is null; -- deleted rows where percentage_laid_off and total_laid_off was null
delete from layoffs_staging2 where percentage_laid_off is null and total_laid_off is null;
alter table layoffs_staging2 drop column `row_number`; -- deleted the column row_number

-- data cleaning done

--  EXPLORATORY DATA ANALYSIS
select * from layoffs_staging2;
select MAX(total_laid_off),MIN(total_laid_off), MAX(percentage_laid_off), MIN(percentage_laid_off)from layoffs_staging2;
select * from layoffs_staging2 WHERE percentage_laid_off=1 order by total_laid_off desc;
select * from layoffs_staging2 WHERE percentage_laid_off=1 order by funds_raised_millions desc;
select company,sum(total_laid_off) from layoffs_staging2 group by company order by sum(total_laid_off) desc ;
select industry,sum(total_laid_off) from layoffs_staging2 group by industry order by sum(total_laid_off) desc ;
select country,sum(total_laid_off) from layoffs_staging2 group by country order by sum(total_laid_off) desc ;
select year(`date`),sum(total_laid_off) from layoffs_staging2 group by year(`date`) order by 1 desc ;
select stage,sum(total_laid_off) from layoffs_staging2 group by stage order by sum(total_laid_off) desc ;
select MIN(date), MAX(date) from layoffs_staging2;
select substring(`date`,1,7) as `MONTH`,sum(total_laid_off) as total_off from layoffs_staging2 where substring(`date`,1,7) is not null 
group by `MONTH`order by 1;
with rolling_total as (select substring(`date`,1,7) as `MONTH`,sum(total_laid_off) as total_off from layoffs_staging2 where substring(`date`,1,7) is not null 
group by `MONTH`order by 1 asc)
select `MONTH`,total_off,sum(total_off) over( order by `MONTH` ) as rolling_total
from rolling_total;
select * from layoffs_staging2 where company="uber";
with cte(company,years,total_laid_off) as
(select company,year(`date`),sum(total_laid_off) from layoffs_staging2 group by company,year(`date`) order by 3 desc),
company_year_rank as (select company,years,total_laid_off, dense_rank() over(partition by years order by total_laid_off desc) as ranking from cte where years is not null)
select * from company_year_rank where ranking<=5 ;

with rolling_totals_funds(company,dates,sum_funds) as 
(select company,`date`,sum(funds_raised_millions) from layoffs_staging2 group by company,`date` order by 3 desc)
select company,dates,sum_funds,sum(sum_funds) over(partition by company order by dates) as rolling_totals 
from rolling_totals_funds where dates is not null and sum_funds is not null order by 1,2;

select industry, sum(funds_raised_millions) from layoffs_staging2 where industry is not null group by industry order by 2 desc;
 
 
 
 
 
 
 
 
 
 
