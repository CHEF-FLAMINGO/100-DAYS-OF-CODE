-- ======================================
-- Day 6: SQL Basics
-- Dataset: WFP Nigeria Food Prices
-- ======================================


-- View sample of the data
SELECT  *
FROM wfp_food_prices_nga;

-- List all unique commodities
SELECT DISTINCT commodity
FROM wfp_food_prices_nga;

-- Filter data for Lagos state
SELECT *
FROM wfp_food_prices_nga
WHERE admin1 = 'Lagos';

-- What columns are in the dataset?
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'wfp_food_prices_nga';

-- How many records (rows) are in the dataset?
SELECT 
COUNT (*) AS 
NO_OF_ROWS 
FROM wfp_food_prices_nga;

-- How many unique commodities are tracked?
SELECT 
COUNT(DISTINCT COMMODITY) 
AS UNIQUE_COMMODITIES
FROM wfp_food_prices_nga;

-- How many states (admin1) are represented?
SELECT 
COUNT(DISTINCT ADMIN1) 
AS NUMBER_OF_STATES
FROM wfp_food_prices_nga;

-- How many markets exist per state?
SELECT DISTINCT 
ADMIN1, ADMIN2, COUNT(DISTINCT MARKET) 
AS MARKETS_PER_STATE
FROM wfp_food_prices_nga
GROUP BY ADMIN1, ADMIN2;

-- What units are used to measure prices (kg, bag, etc.)?
SELECT DISTINCT 
UNIT FROM wfp_food_prices_nga;


-- ======================================
-- DAY 7: BASIC FILTERING & SORTING
-- Dataset: WFP Nigeria Food Prices
-- ======================================


-- What are the top 10 most expensive food items overall?
SELECT TOP(10) commodity,price
FROM wfp_food_prices_nga
ORDER BY price DESC;

-- What are the cheapest commodities on average?
SELECT 
TOP(1) COMMODITY, 
AVG(PRICE) AS AVERAGE_PRICE
FROM wfp_food_prices_nga
GROUP BY commodity
ORDER BY AVERAGE_PRICE DESC;

-- What commodities are sold in Lagos state?
SELECT  
DISTINCT 
COMMODITY
FROM wfp_food_prices_nga
WHERE admin1= 'Lagos';

-- What is the price range (min–max) for rice?
SELECT
MIN(PRICE) AS MIN_PRICE,
MAX(PRICE) AS MAX_PRICE
FROM wfp_food_prices_nga
WHERE COMMODITY = 'Rice';

-- Which markets have prices above the national average?
SELECT MARKET, PRICE
FROM wfp_food_prices_nga
WHERE PRICE > (SELECT AVG(PRICE) FROM wfp_food_prices_nga);

-- Which states have the highest food prices?
SELECT TOP(5) ADMIN1, AVG(PRICE) AS AVERAGE_PRICE
FROM wfp_food_prices_nga
GROUP BY ADMIN1
ORDER BY AVERAGE_PRICE DESC;


-- ======================================
-- DAY 8: AGGREGATION & MATH 
-- Dataset: WFP Nigeria Food Prices
-- ======================================


-- What is the average price of each commodity?
SELECT COMMODITY, AVG(PRICE) AS AVERAGE_PRICE
FROM wfp_food_prices_nga
GROUP BY COMMODITY;

-- Which commodity has the highest average price?
SELECT TOP(1) 
COMMODITY, AVG(PRICE) 
AS AVERAGE_PRICE 
FROM wfp_food_prices_nga
GROUP BY commodity
ORDER BY AVERAGE_PRICE  DESC;

-- Which state has the highest average food prices?
SELECT TOP(1) admin1,admin2,
AVG(PRICE) AS AVERAGE_PRICE 
FROM wfp_food_prices_nga 
GROUP BY admin1,admin2
ORDER BY AVG(PRICE)DESC;

-- How many price records exist per commodity?
SELECT COMMODITY, COUNT(PRICE) 
AS PRICE_RECORDS 
FROM wfp_food_prices_nga
GROUP BY commodity
ORDER BY PRICE_RECORDS DESC; 

-- What is the average price of rice per state?
SELECT  AVG(price) 
AS AVERAGE_PRICE,
admin1, admin2, commodity
FROM wfp_food_prices_nga
WHERE commodity IN ('Rice (local)', 'Rice(imported)')
GROUP BY ADMIN1, admin2, commodity
ORDER BY AVERAGE_PRICE DESC;


-- ======================================
-- DAY 9: TIME ANALYSIS & TRENDS
-- Dataset: WFP Nigeria Food Prices
-- ======================================

-- What is the date range covered by the dataset?
SELECT MIN(date) AS MIN_DATE, 
MAX(date) AS MAX_DATE
FROM wfp_food_prices_nga;

-- How many price records exist per year?
SELECT YEAR(date) AS YEAR,
COUNT(PRICE) AS PRICE_RECORDS
FROM wfp_food_prices_nga
GROUP BY YEAR(DATE)
ORDER BY PRICE_RECORDS DESC;

-- What is the average food price per year?
SELECT YEAR(date) as YEAR 
, AVG(PRICE) 
AS AVERAGE_PRICE 
FROM wfp_food_prices_nga
GROUP BY YEAR(date) 
ORDER BY AVERAGE_PRICE DESC;

-- How has the average price of rice changed over time?
SELECT AVG(PRICE) 
AS AVERAGE_PRICE, COMMODITY, 
YEAR(date) AS YEAR 
from wfp_food_prices_nga
WHERE COMMODITY 
IN(('Rice (local)'), ('Rice (imported)'))
GROUP BY commodity, YEAR(date)
ORDER BY YEAR(date);

-- Which year had the highest average food prices?
SELECT TOP(1) YEAR(date) 
AS YEAR, AVG(PRICE) AS AVERAGE_PRICES
FROM wfp_food_prices_nga
GROUP BY YEAR(date)
ORDER BY AVERAGE_PRICES DESC;

-- What is the monthly average price trend for a selected commodity (e.g. Rice)?
SELECT YEAR(date) as YEAR,
MONTH(date)
AS MONTH, COMMODITY,
AVG(PRICE) AS AVERAGE_PRICE 
FROM wfp_food_prices_nga
WHERE commodity IN(('Rice (local)'), ('Rice (imported)'))
GROUP BY commodity, MONTH(date), YEAR(date)
ORDER BY year(date), month(date);

-- Which states experienced the biggest price increase over time?
SELECT TOP(10) admin1, date,
MAX(PRICE) AS PRICE_COUNT
FROM wfp_food_prices_nga
GROUP BY date, admin1, date
ORDER BY PRICE_COUNT;

-- Compare average prices before and after a specific year (e.g. pre-2020 vs post-2020).
SELECT COMMODITY,
AVG(CASE WHEN date <'2020-01-01' THEN price END) AS AVG_PRE_2020,
AVG(CASE WHEN date > '2020-01-01' THEN price END) AS AVG_POST_2020
FROM wfp_food_prices_nga
GROUP BY commodity;



-- ======================================
-- DAY 10: COMPARATIVE & INSIGHT QUERIES
-- Dataset: WFP Nigeria Food Prices
-- ======================================

-- Goal: Extract insights that feel like real analysis, not just practice.

-- Compare average prices of imported rice vs local rice across states.
SELECT COMMODITY, AVG(PRICE) AS AVERAGE_PRICE, admin1
FROM wfp_food_prices_nga
WHERE commodity IN (('Rice (local)') , ('Rice (imported)'))
GROUP BY admin1, commodity
ORDER BY AVERAGE_PRICE DESC;

--Which markets consistently have prices above their state average?
SELECT market, admin1, AVG(price) as market_fixed_avg
FROM wfp_food_prices_nga
GROUP BY market, admin1
HAVING AVG(price) > (
    -- This subquery calculates the "Global" average for the whole table
    -- (Or you can partition it by state)
    SELECT AVG(price) FROM wfp_food_prices_nga
)
ORDER BY market_fixed_avg DESC;

-- Which state has the most volatile food prices (highest price variation)?
SELECT TOP (1) ADMIN1,
MAX(PRICE) AS HIGHEST_PRICES FROM wfp_food_prices_nga
GROUP BY ADMIN1
ORDER BY MAX(price) DESC;

-- Rank states by average food prices (highest to lowest).
SELECT ADMIN1, AVG(PRICE) 
AS AVERAGE_FOOD_PRICES
FROM wfp_food_prices_nga
GROUP BY admin1
ORDER BY AVERAGE_FOOD_PRICES DESC;

-- Rank commodities by affordability (cheapest to most expensive).
SELECT COMMODITY, AVG(PRICE) AS AVERAGE_PRICES
FROM wfp_food_prices_nga
GROUP BY commodity
ORDER BY AVERAGE_PRICES ASC;

-- Which commodities show the largest price differences between states?
SELECT COMMODITY, ADMIN1, 
AVG(PRICE) 
AS AVERAGE_PRICES 
FROM wfp_food_prices_nga
GROUP BY commodity, admin1
ORDER BY AVERAGE_PRICES DESC;

-- Identify the top 5 most expensive markets overall.
SELECT TOP (5) MARKET,
AVG(PRICE) AS AVERAGE_PRICE 
FROM wfp_food_prices_nga
GROUP BY market, market_id
ORDER BY AVERAGE_PRICE DESC;

-- For each state, what is the most expensive commodity?
SELECT [state], commodity, 
avg_price 
FROM
(SELECT ADMIN1 AS [state], 
commodity, avg(price) as avg_price, RANK() 
OVER (PARTITION BY admin1 ORDER BY avg(price) DESC) 
as price_rank FROM wfp_food_prices_nga WHERE date > '2024-01-01'

group by admin1, commodity) AS RANKED_TABLE WHERE PRICE_RANK =1;
