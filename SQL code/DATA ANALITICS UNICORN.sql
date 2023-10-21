create database unicorn_companies

select * from unicorn_companies.dbo.Unicorn_Companies

--checking for null values
select *
from unicorn_companies.dbo.Unicorn_Companies
where Company is null or 
Valuation is null or
(Date_Joined is null) or
(Industry is null) or
(City is null) or
(Country_Region is null) or
(Continent is null) or
(Year_Founded is null) or
(Funding is null) or
(Select_Investors is null )

--we have 1 null value from only Bahamas
select * from unicorn_companies.dbo.Unicorn_Companies
where Country_Region='Bahamas'
--Setting blank1 for Bahamas
Update unicorn_companies.dbo.Unicorn_Companies
	set City='blank1'
	where Country_Region= 'Bahamas' 
--checking for Hong Kong
select * from unicorn_companies.dbo.Unicorn_Companies
where Country_Region='Hong Kong'
go

--setting the null values as 'Cheung Sha Wan' in Hong Kong
UPDATE unicorn_companies.dbo.Unicorn_Companies
SET City = 'Cheung Sha Wan'
WHERE City IS NULL and Country_Region='Hong Kong'

--checking Singapore
select * from unicorn_companies.dbo.Unicorn_Companies
where Country_Region='Singapore'
go


--Setting blank2 for Singapore

 	Update unicorn_companies.dbo.Unicorn_Companies
	set City='blank2'
	where Country_Region= 'Singapore' and City is null 
	go


--checking for the null values and there are no null values anymore
	select city from unicorn_companies.dbo.Unicorn_Companies
	where City is null

	
--converting Valuation column into int and getting rid of the dollar sign and the letter 'B'
	select
	CAST(SUBSTRING(Valuation, 2, LEN(Valuation) - 2) AS int) AS Valuation2, valuation
	from unicorn_companies.dbo.Unicorn_Companies 

--making new column as Valuation_B

ALTER TABLE unicorn_companies.dbo.Unicorn_Companies
ADD Valuation_B INT;

--updating the Valuation_B

UPDATE unicorn_companies.dbo.Unicorn_Companies
SET Valuation_B= CAST(SUBSTRING(Valuation, 2, LEN(Valuation) - 2) AS INT);

--checking the columns
select * from unicorn_companies.dbo.Unicorn_Companies

-- Adding new column funding in millions as Funding_M

	ALTER TABLE unicorn_companies.dbo.Unicorn_Companies
ADD Funding_M INT
--update the values to new column Funding_M
update unicorn_companies.dbo.Unicorn_Companies
set Funding_M= case
WHEN RIGHT(funding, 1) = 'M' THEN 
            CAST(SUBSTRING(funding, 2, LEN(funding) - 2) AS INT) 
WHEN RIGHT(Funding, 1) = 'B' THEN 
            CAST(SUBSTRING(Funding, 2, LEN(Funding) - 2) AS INT) * 1000
			end;

go

--1.What are the top unicorn companies by valuation?
select top 10 Valuation_B, Company
from unicorn_companies.dbo.Unicorn_Companies
order by Valuation_B desc

--2.How many companies are there in each Industry?
select Industry,COUNT(industry) as count_value
from unicorn_companies.dbo.Unicorn_Companies
group by Industry
order by Count(industry) desc

--3.avg valuation based on region
select avg(Valuation_B) as avg_value, Country_Region
from unicorn_companies.dbo.Unicorn_Companies
group by Country_Region
order by AVG(valuation_B) desc

--4.Total Valuation by city
select sum(Valuation_B), City
from unicorn_companies.dbo.Unicorn_Companies
group by City
order by sum(Valuation_B) desc

--5.Total Valuation by region
select sum(Valuation_B), Country_Region
from unicorn_companies.dbo.Unicorn_Companies
group by Country_Region
order by sum(Valuation_B) desc

--6.Which unicorn companies have the most Funding and who are their Select Investors?
select Company, Funding_M, Select_Investors
from unicorn_companies.dbo.Unicorn_Companies
order by Funding_M desc

--7.what is the Avg funding for each industry?
select avg(funding_M), Industry
from unicorn_companies.dbo.Unicorn_Companies
group by Industry
order by avg(Funding_M) desc

--8.How has the number of unicorn companies grown over the years?
SELECT Year_founded, COUNT(*) AS Count
FROM unicorn_companies.dbo.Unicorn_Companies
GROUP BY Year_founded
ORDER BY Year_founded;

--9.How has the Valuation of unicorn companies changed over the years, on average?
SELECT Year_founded, AVG(Valuation_B) AS AvgValuation
FROM unicorn_companies.dbo.Unicorn_Companies
GROUP BY Year_founded
ORDER BY Year_founded;


--10.How many unicorn companies have Valuations that are greater than the average Valuation of all companies?
select Company, valuation_B
from unicorn_companies.dbo.Unicorn_Companies
where Valuation_B> (select avg(valuation_B) from unicorn_companies.dbo.Unicorn_Companies)




