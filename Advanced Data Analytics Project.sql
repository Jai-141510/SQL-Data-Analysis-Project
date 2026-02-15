-- Using Database
USE SQLProject1;

-- Let's analyze some values over date (Change over time)

-- Analyze sales performance over time
SELECT
YEAR(order_date) AS YEAR,
MONTH(order_date) AS [MONTH],
SUM(sales_amount) AS [TOTAL SALES],
COUNT(DISTINCT(customer_key)) AS [TOTAL CUSTOMERS],
SUM(quantity) AS [TOTAL QUANTITY]
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date),  MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);



-- Cumulative analysis
-- Calculate the total sales for each month and the running total of sales over time
SELECT
*,
SUM([TOTAL SALES]) OVER (ORDER BY [YEAR], [MONTH]) AS [RUNNING TOTAL]
FROM 
(
SELECT
YEAR(order_date) AS [YEAR],
MONTH(order_date) AS [MONTH],
SUM(sales_amount) AS [TOTAL SALES]
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
) t


-- Performance analysis
-- Analyze the yearly performance of products by comparing each product's sale to both its average sales performance and the previous year's sales

WITH yearly_product_sales AS 
(
SELECT
YEAR(order_date) AS [YEAR],
p.product_name,
SUM(s.sales_amount) AS [TOTAL SALE]
FROM gold.dim_products p
INNER JOIN gold.fact_sales s
ON p.product_key = s.product_key
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), p.product_name
)

SELECT 
*,
AVG([TOTAL SALE]) OVER (PARTITION BY product_name) AS [AVERAGE SALES/PRODUCT],
[TOTAL SALE] - AVG([TOTAL SALE]) OVER (PARTITION BY product_name) AS [COMPARISION WITH AVG],
CASE
	WHEN [TOTAL SALE] - AVG([TOTAL SALE]) OVER (PARTITION BY product_name) > 0 THEN 'ABOVE AVERAGE'
	WHEN [TOTAL SALE] - AVG([TOTAL SALE]) OVER (PARTITION BY product_name) < 0 THEN 'BELOW AVERAGE'
	ELSE 'AVERAGE'
	END AS [AVERAGE CHANGE],
LAG([TOTAL SALE]) OVER (PARTITION BY product_name ORDER BY [YEAR]) AS [PREV SALES],
[TOTAL SALE] - LAG([TOTAL SALE]) OVER (PARTITION BY product_name ORDER BY [YEAR]) AS [DIFFERENCE WITH PREV YR],
CASE
	WHEN [TOTAL SALE] - LAG([TOTAL SALE]) OVER (PARTITION BY product_name ORDER BY [YEAR]) > 0 THEN 'INCREASE'
	WHEN [TOTAL SALE] - LAG([TOTAL SALE]) OVER (PARTITION BY product_name ORDER BY [YEAR]) < 0 THEN 'DECREASE'
	ELSE 'NO CHANGE'
END AS [TOTAL SALES CHANGE]
FROM yearly_product_sales
ORDER BY product_name, [YEAR];


-- Part to whole analysis - Percentages
-- Which category contributes the most to the overall sales
WITH cateogory_sales AS 
(
SELECT
category,
SUM(sales_amount) AS [Total Sales]
FROM gold.fact_sales s
INNER JOIN gold.dim_products p
ON s.product_key = p.product_key
GROUP BY category
)

SELECT
*,
SUM([Total Sales]) OVER () AS [Overall Sales],
CONCAT(ROUND((CAST ([Total Sales] AS FLOAT) /SUM([Total Sales]) OVER ()) * 100, 2), '%') AS [Percentage Contribution]
FROM cateogory_sales
ORDER BY [Total Sales] DESC;


-- Data segmentation - Using CASE statements, comparing measure with another measure

-- Segment products into cost ranges and count how many products fall into each segment

WITH product_segments AS 
(
SELECT
product_key,
product_name,
cost,
CASE
	WHEN cost < 100 THEN 'Below 100'
	WHEN cost BETWEEN 100 AND 500 THEN '100-500'
	WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
	ELSE 'Above 1000'
END AS [Cost Range] 
FROM gold.dim_products
)

SELECT
[Cost Range],
COUNT(product_key) AS [Total Products]
FROM product_segments
GROUP BY [Cost Range]
ORDER BY 2 DESC


-- Group customers into 3 segements based on their spending behaviour - VIP : At least 12 months of history and spending more than 5000, Regular : at least 12 months of history but spending 5000 or less
-- New : lifespan less than 12 months. And also find the total number of customers by each group

WITH customer_segregation_rawdata AS
(
SELECT
c.customer_id,
MIN(order_date) AS [First Order],
MAX(order_date) AS [Last Order],
DATEDIFF(Month, MIN(order_date), MAX(order_date)) AS Lifespan,
SUM(s.sales_amount) AS [Total Sales]
FROM gold.dim_customers c
INNER JOIN gold.fact_sales s
ON c.customer_key = s.customer_key
GROUP BY c.customer_id
)

, customer_segregation AS (
SELECT
customer_id,
CASE
	WHEN [Total Sales] >= 5000 AND Lifespan >= 12 THEN 'VIP'
	WHEN [Total Sales] <= 5000 AND Lifespan >= 12 THEN 'Regular'
	ELSE 'New'
END AS [Customer Segregation]
FROM customer_segregation_rawdata
)

SELECT
[Customer Segregation],
COUNT([Customer Segregation]) AS [Num of Customers]
FROM customer_segregation
GROUP BY [Customer Segregation]
ORDER BY 2;

/*
----------------------------------------------------------------------------------------------
Customer Report
----------------------------------------------------------------------------------------------

Purpose : This report consolidates key customer metrics and behaviours

Highlights :
	1. Gathers essential fields such as names, ages and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
	3. Aggregates customer-level metrics :
				- Total orders
				- Total sales
				- Total quantity purchased
				- Total products
				- Lifespan of customers (in months)
	4. Calculates valuable KPIs -
				- recency (months since last order)
				- average order value
				- average monthly spend

----------------------------------------------------------------------------------------------
*/

-- Base query to retireve all the core columns

CREATE view gold.report_customers AS
WITH base_query AS
(
SELECT
s.order_number,
s.product_key,
s.order_date,
s.sales_amount,
s.quantity,
c.customer_key,
c.customer_number,
CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
DATEDIFF(YEAR, c.birthdate, CURRENT_DATE) AS age
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
ON c.customer_key = s.customer_key
WHERE order_date IS NOT NULL
)
, customer_aggregation AS 

(
SELECT 
customer_key,
customer_number,
customer_name,
age,
COUNT(DISTINCT order_number) AS total_orders,
SUM(sales_amount) AS total_sales,
SUM(quantity) AS total_quantity,
COUNT(DISTINCT product_key) AS total_products,
MAX(order_date) AS last_order_date,
DATEDIFF(Month, MIN(order_date), MAX(order_date)) AS lifespan
FROM base_query
GROUP BY customer_key, customer_number, customer_name, age
)

SELECT
*,
CASE
	WHEN total_sales >= 5000 AND lifespan >= 12 THEN 'VIP'
	WHEN total_sales <= 5000 AND lifespan >= 12 THEN 'Regular'
	ELSE 'New'
END AS [Customer Segregation],

CASE 
	WHEN age < 20 THEN 'Under 20'
	WHEN age BETWEEN 20 and 29 THEN '20-29'
	WHEN age BETWEEN 30 and 39 THEN '30-39'
	WHEN age BETWEEN 40 and 49 THEN '40-49'
	ELSE '50 and above'
END AS age_group,
-- Calcualting recency
DATEDIFF(MONTH, last_order_date, CURRENT_DATE) AS recency,
-- Computing average order value
CASE
	WHEN total_sales = 0 THEN 0
	ELSE total_sales/total_orders
END AS avg_order_value,
-- Computing average monthly spend
CASE
	WHEN lifespan = 0 THEN 0
	ELSE total_sales/lifespan
END AS avg_monthly_spend
FROM customer_aggregation


SELECT
*
FROM gold.report_customers