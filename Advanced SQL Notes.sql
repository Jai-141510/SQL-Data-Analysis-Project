
--																	CASE STATEMENTS

-- Generate a report showing the total sales for each category, high if greter than 50, medium - between 20 and 50, low for lower than 20. sort the result from low to high

USE SalesDB;


SELECT category, SUM(sales) AS TotalSales
FROM (
	SELECT orderid, sales,
	CASE
		WHEN sales > 50 THEN 'High'
		WHEN sales BETWEEN 20 AND 50 THEN 'Medium'
		ELSE 'Low'
	END AS category
	FROM sales.orders ) AS Sales_agg
GROUP BY category
ORDER BY SUM(sales) DESC;

-- Retrieve employee details with gender diplayed as full text
SELECT EmployeeID, FirstName, LastName, Gender,
	CASE
		WHEN gender = 'M' THEN 'Male'
		ELSE 'Female'
	END AS [FULL Gender]
FROM sales.Employees;

-- Retrieve customer details with abbreviated country code
SELECT CustomerID, FirstName, LastName, Country,
CASE
	WHEN Country = 'Germany' THEN 'Ger'
	WHEN Country = 'USA' THEN 'US'
	ELSE 'Not available'
	END AS [Country Abbreviations]
FROM sales.customers;

-- Find the average scores of customers and treat NULLS as 0
SELECT CustomerID, score, Newscore,
AVG(Newscore) OVER() AS CorrectAvgScore
FROM (
SELECT CustomerID, score,
CASE
	WHEN score IS NULL THEN 0
	ELSE score
END AS NewScore
FROM sales.customers) AS temp_score

-- More efficient - less resources used
SELECT customerID, score,
	   AVG(COALESCE(score, 0)) OVER() [Average Score]
FROM sales.customers;

-- Count how many times each customers has made an order with sales greater than 30, need a column for total orders placed and total orders placed higher than 30
SELECT customerId, COUNT(customerID) AS [Total Orders Placed],
	SUM(CASE
		WHEN sales > 30 THEN 1
		ELSE 0
		END) [High Vol orders]
FROM sales.orders
GROUP BY customerID;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--																	 WINDOW FUNCTIONS

-- Find the total sales for each product and additionally provide details such as order ID, order date.
SELECT OrderID, OrderDate, ProductID,
	   SUM(sales) OVER(PARTITION BY ProductID) [Total sales/product]
FROM sales.orders
ORDER BY ProductID;

-- Lets say we also want a column with total orders for the above query
SELECT OrderID, OrderDate, ProductID,
	   SUM(sales) OVER() [TotalSales Across All],
	   SUM(sales) OVER(PARTITION BY ProductID) [Total sales/product]
FROM sales.orders
ORDER BY ProductID;

-- Find the total sales for each combination of product and order status
SELECT OrderID, ProductID, OrderStatus,
	   SUM(sales) OVER (PARTITION BY productId, OrderStatus) AS [TOTALSALES]
FROM sales.orders;

-- ORDER BY
-- Rank each order based on their sales from highest to lowest, additionally provide details such as order id and order date
SELECT orderID, sales, orderdate,
RANK() OVER(order by sales DESC) AS [Sales Rank]
FROM sales.orders;


-- Checking duplicates using partition by
SELECT *
FROM (
SELECT orderid,
COUNT(orderID) OVER(PARTITION BY orderID) AS [CHECK DUPS]
FROM sales.OrdersArchive) t
WHERE [CHECK DUPS] > 1;

-- Find the total sales across all orders and the total sales for each product. Additionally, provide details such as orderId and order date
SELECT orderID, orderdate, sales,
SUM(sales) OVER() AS [TOTAL SALES],
productid,
SUM(sales) OVER(PARTITION BY productID) AS [TOTAL SALES PER PRODUCT]
FROM sales.orders


-- Find the average sales across all orders and the average sales for each product. Additionally, provide details such as orderId and order date
SELECT orderid, orderdate, sales,
AVG(sales) OVER() AS [AVERAGE SALES],
productid,
AVG(sales) OVER(PARTITION BY productid) AS [AVERAGE SALE PER PRODUCT]
FROM sales.orders

-- Handling nulls
SELECT customerid, lastname, score,
AVG(ISNULL(score, 0)) OVER() AS [AVERAGE SCORE]
FROM sales.customers

-- Find all orders where the sales are higher than average sales across all orders
SELECT *
FROM(
SELECT orderid, sales,
AVG(sales) OVER() AS [AVERAGE SALES]
FROM sales.orders) t
WHERE sales > [AVERAGE SALES];

-- Find the highest and lowest sale across all orders and also for each product, provide orderid and orderdate as well
SELECT orderid, orderdate, sales,
MIN(sales) OVER() AS [LOWEST SALE],
MAX(sales) OVER() AS [HIGHEST SALE],
productid,
MIN(sales) OVER(PARTITION BY productid) AS [LOWEST SALE/PRODUCT],
MAX(sales) OVER(PARTITION BY productid) AS [HIGHEST SALE/PRODUCT]
FROM sales.orders;

-- Show the employees who have the highest salaries
SELECT TOP 1 salary, employeeId, firstname, lastname
FROM sales.Employees
ORDER BY salary DESC

-- Finding out the deviation of each sale from min and max sale amounts
SELECT orderid, productid, sales,
MIN(sales) OVER() AS [MINIMUM SALE],
MAX(sales) OVER() AS [MAXIMUM SALE],
sales - MIN(sales) OVER() AS [MIN DEVIATION],
MAX(sales) OVER() - sales AS [MAX DEVIATION]
FROM sales.orders;


-- Find the running total and the rolling total of the sales by month
SELECT MONTH(orderdate) [MONTH NUM], DATENAME(month, orderdate) AS [MONTH], sales, 
SUM(sales) OVER(ORDER BY MONTH(orderdate) ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS [RUNNING TOTAL],
SUM(sales) OVER(ORDER BY MONTH(orderdate) ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS [ROLLING QUARTER TOTAL]
FROM sales.orders;


-- Calculating the moving average of sales for each product over time
SELECT orderID, orderdate, sales, productID,
AVG(sales) OVER(PARTITION BY productID) AS [AVG SALES/PROD],
AVG(sales) OVER(PARTITION BY productID ORDER BY orderdate) AS [moving avg]
FROM sales.orders;


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--																		RANK FUNCTIONS

-- Rank the orders based on their sales from highest to lowest 
SELECT orderid, sales,
RANK() OVER (ORDER BY sales DESC) AS [ORDER RANK]
FROM sales.orders;
-- Rank will have duplicates and will also skip ranks when you have 2 values in same rank
-- If you wish to have no duplicates - 
SELECT orderid, sales,
ROW_NUMBER() OVER (ORDER BY sales DESC) AS [ROW_RANK]
FROM sales.orders;
-- If you still wish to use the rank function and not have any skips, use DENSE_RANK
SELECT orderid, sales,
DENSE_RANK() OVER (ORDER BY sales DESC) AS [DENSE_ROW_RANK]
FROM sales.orders;


-- USE CASE
-- Find the highest sales for each product
SELECT *
FROM (
SELECT productid, sales,
ROW_NUMBER() OVER(PARTITION BY productid ORDER BY sales DESC) AS [RANKS/PROD]
FROM sales.orders) t
WHERE [RANKS/PROD] = 1;

-- Find the lowest 2 customers based on their total sales
SELECT TOP 2 customerid, SUM(sales) AS [TOTAL SALE]
FROM sales.orders
GROUP BY customerid
ORDER BY SUM(sales);

-- Assign unique IDs to the rows of the 'Orders Archieve' table
SELECT ROW_NUMBER() OVER(ORDER BY OrderDate) AS [UNIQUE ID], *
FROM sales.OrdersArchive;

-- Identify duplicate rows in the orderarchieve table and return a clearn result without any duplicates
SELECT *
FROM (
SELECT 
ROW_NUMBER() OVER(PARTITION BY orderid ORDER BY creationtime) AS [identifying duplicates],
*
FROM sales.OrdersArchive) t
WHERE [identifying duplicates] > 1;

--																		PERCENT RANK FUNCTIONS

-- Find the producs that fall within the highest 40% of the prices
SELECT productid, product, price,
CUME_DIST() OVER (ORDER BY price DESC) AS [DISTRANK]
FROM sales.Products;

-- Moving tables
-- Divide the data into 2 groups
SELECT
NTILE(2) OVER (ORDER BY orderID) AS Buckets,
*
FROM Sales.orders;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--																		WINDOW VALUE FUNCTIONS
-- Analyse the month over month performance by finding out the percentage change in sales
SELECT *, TotalSales - PrevMonthSales AS MoM_Change,
ROUND(CAST((TotalSales - PrevMonthSales) AS FLOAT)/PrevMonthSales * 100, 1) AS Perct_Change
FROM (
SELECT MONTH(Orderdate) AS Month, SUM(sales) AS TotalSales,
LAG(SUM(sales)) OVER (ORDER BY MONTH(Orderdate)) AS PrevMonthSales
FROM sales.orders
GROUP BY MONTH(Orderdate)) t

-- Analyze customer loyalty by ranking customers based on the average number of days between orders

SELECT customerid, AVG(NumOfDays) AS [Averagedays],
RANK() OVER (ORDER BY COALESCE(AVG(NumOfDays), 9999999)) RankAvg
FROM (
SELECT customerID, orderDate,
LAG(orderdate) OVER (PARTITION BY customerID ORDER BY customerID, orderdate) AS PrevOrderDate,
DATEDIFF(DAY, LAG(orderdate) OVER (PARTITION BY customerID ORDER BY customerID, orderdate), orderdate) AS NumOfDays
FROM sales.orders) t
GROUP BY customerid


-- Find the average shipping duartion in days for each month
SELECT MONTH(orderdate) AS Month,
AVG(DATEDIFF(DAY, orderdate, shipdate)) AS AvgDaysTakenToShip
FROM sales.orders
GROUP BY MONTH(orderdate)

-- Find the number of days between each order and previous order
SELECT orderid, orderdate,
LAG(orderdate) OVER(ORDER BY orderdate) AS NextOrder,
DATEDIFF(DAY, LAG(orderdate) OVER(ORDER BY orderdate), orderdate) AS Diffofdate
FROM sales.orders;

-- Find the lowest and the highest sale for each product
SELECT orderid, productid, sales,
FIRST_VALUE(sales) OVER (PARTITION BY productid ORDER BY sales) AS LowestSales,
FIRST_VALUE(sales) OVER (PARTITION BY productid ORDER BY sales DESC) AS HighestSales
FROM sales.orders

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--																					SUBQUERIES
-- Find the products that have a price higher than the average price of all products
SELECT *
FROM (
	SELECT product, price,
	AVG(price) OVER() AS AvgPrice
	FROM sales.products) t
WHERE price > AvgPrice;

-- Rank customers based on their total amount of sales - SUBQUERY IN FROM
SELECT *,
RANK() OVER (ORDER BY TotalSales DESC) AS SalesRanking
FROM (
	SELECT customerid, SUM(sales) AS TotalSales
	FROM sales.orders
	GROUP BY customerid) t

-- Show all customer details and find the total orders of each customer - SUBQUERY IN JOINS
SELECT c.*, o.Totalorders
FROM sales.customers c
LEFT JOIN (
SELECT customerid, COUNT(orderid) AS Totalorders
FROM sales.orders
GROUP BY customerid) o
ON c.customerid = o.customerid

-- SUBQUERY IN WHERE clause
-- Find the products that have a price higher than the average price of all products
SELECT *
FROM sales.products
WHERE price > (SELECT AVG(price) FROM sales.products)


-- Using IN operator
-- Show the details of orders made by German customers
SELECT *
FROM sales.orders
WHERE customerid IN 
				(SELECT customerid
				 FROM sales.customers
				 WHERE country = 'Germany')
-- Learning from mistake - We cannot have multiple columns in select statement when using nested queries in WHERE


-- USING ANY/ALL
-- Find female employees whose salaries are greater than the salaries of any male employees

SELECT EmployeeID, FirstName, Gender, Salary
FROM sales.employees
WHERE Gender = 'F' AND salary > ANY(
								SELECT Salary
								FROM sales.Employees
								WHERE Gender = 'M')


-- Show all customer details and find the total orders of each customer
SELECT *,
	   (SELECT COUNT(customerid) FROM sales.orders o WHERE c.customerid = o.customerid) AS TotalSales
FROM sales.Customers c

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--																				CTE PROJECT
-- CTE
-- (1) Find the total sales per customer
WITH CTE_Total_Sales AS
(
SELECT customerid, SUM(sales) AS TotalSales
FROM sales.orders
GROUP BY customerid
)

-- (2) Find the last order date for each customer -- NESTED CTE
, CTE_Last_Order AS
(
SELECT customerid, MAX(orderdate) AS LastOrder
FROM sales.orders
GROUP BY customerid
)

-- (3) Rank customers based on the Total sales per customer -- NESTED CTE
, CTE_Customer_Rank AS
(
SELECT customerid, TotalSales,
RANK() OVER (ORDER BY TotalSales DESC) AS CustomerRank
FROM CTE_Total_Sales
)

-- (4) Segment the customers based on their total sales -- NESTED CTE
, CTE_Customer_Segment AS
(
SELECT customerid, TotalSales,
CASE
	WHEN TotalSales > 100 THEN 'High Sales'
	WHEN TotalSales > 80 THEN 'Medium Sales'
	ELSE 'Low Sales'
	END AS CustomerSegment
FROM CTE_Total_Sales
)

-- Main query
SELECT c.*, cte1.TotalSales, cte2.LastOrder, cte3.CustomerRank, cte4.CustomerSegment
FROM sales.Customers c
LEFT JOIN CTE_Total_Sales cte1
ON c.CustomerID = cte1.customerid
LEFT JOIN CTE_Last_Order cte2
ON c.CustomerID = cte2.customerid
LEFT JOIN CTE_Customer_Rank cte3
ON c.CustomerID = cte3.customerid
LEFT JOIN CTE_Customer_Segment cte4
ON c.CustomerID = cte4.customerid


-- RECURSIVE CTE
-- List down all number from 1 to 100
WITH CTE_List AS
(
SELECT 1 AS MyNumber
UNION ALL
SELECT MyNumber + 1
FROM CTE_List
WHERE MyNumber < 100
)
SELECT *
FROM CTE_List

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--																				VIEWS
CREATE VIEW Sales.V_Montly_Summary AS
(
SELECT DATETRUNC(month, orderdate) AS OrderMonth,
	   SUM(sales) AS TotalSales,
	   COUNT(orderid) AS TotalOrders,
	   SUM(quantity) AS TotalQuantities
FROM sales.orders
GROUP BY DATETRUNC(month, orderdate)
)


-- Provide a view that combines details from orders, products, customers and employees
CREATE VIEW Sales.V_Order_Details AS 
(
SELECT 
o.orderid,
p.product,
p.category,
o.orderdate,
o.sales,
o.quantity,
CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
c.Country,
CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
e.Department,
e.Gender,
e.ManagerID

FROM sales.orders o
LEFT JOIN sales.products p
ON o.productid = p.productid
LEFT JOIN sales.customers c
ON o.CustomerID = c.CustomerID
LEFT JOIN sales.Employees e
ON o.SalesPersonID = e.EmployeeID
);

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--																		CREATING TABLES, CTAS
-- Create a CTAS table for total number of orders each month
USE SalesDB;

SELECT
	DATENAME(month, orderdate) AS order_month,
	COUNT(orderid) AS TotalOrders
-- In SQL server, INTO is used
INTO Sales.MonthlyOrders
FROM sales.orders
GROUP BY DATENAME(month, orderdate);

-- Checking
SELECT * 
FROM Sales.MonthlyOrders;

-- Dropping table
DROP TABLE Sales.MonthlyOrders;

--																		TEMPORARY TABLES
SELECT 
*
INTO #Orders
FROM sales.orders;

-- Checking temp table
SELECT *
FROM #orders

-- Deleting some data from temp table
DELETE FROM #Orders
WHERE OrderStatus = 'Delivered';

-- Now, lets make this permanent
SELECT
*
INTO sales.OrdersTest
FROM #Orders

-- Checking
SELECT
* 
FROM sales.OrdersTest

  ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--																			 STORED PROCEDURES
-- For US customers, find the total number of customers and average score - create stored procedure

-- Building the query
SELECT
	COUNT(*) AS TotalNumOfCustomers,
	AVG(score) AS AverageScore
FROM sales.customers
WHERE country = 'USA';

-- Creating stored procedure for the query
CREATE PROCEDURE UScustomersummary AS
BEGIN
SELECT
	COUNT(*) AS TotalNumOfCustomers,
	AVG(score) AS AverageScore
FROM sales.customers
WHERE country = 'USA'
END;

-- Executing the stored procedure
EXEC UScustomersummary;


-- Making it dynamic, if you wish to extract same data for Germany without having to write the entire code again
ALTER PROCEDURE UScustomersummary @country NVARCHAR(50) AS
BEGIN

	-- Inputting TRY CATCH statements
	BEGIN TRY

		-- Generating report
		-- Declaring variables
		DECLARE @TotalNumOfCustomers INT, @AverageScore FLOAT;

		-- Prepare and cleanup data
		IF EXISTS (SELECT * FROM sales.customers WHERE Country = 'USA' AND score IS NULL)
		BEGIN
			PRINT('Updating NULL values to 0');
			UPDATE sales.customers
			SET score = 0
			WHERE score IS NULL and country = @country
		END

		ELSE
		BEGIN
			PRINT ('No NULL scores found')
		END;

		-- Writing the main query
		SELECT
			@TotalNumOfCustomers = COUNT(*),
			@AverageScore = AVG(score)
		FROM sales.customers
		WHERE country = @country;

		PRINT 'Total Customers from' + @country + ':' + CAST(@TotalNumOfCustomers AS NVARCHAR);
		PRINT 'Average Score of customers from' + @country + ':' + CAST(@AverageScore AS NVARCHAR);

		-- Attaching a complex query
		SELECT
			COUNT(*) AS TotalOrders,
			SUM(sales) AS TotalSales,
			1/0
		FROM sales.orders o
		JOIN sales.Customers c
		ON o.CustomerID = c.CustomerID
		WHERE Country = @country;

	-- Ending the try statement
	END TRY

	-- Starting with catch statement
	BEGIN CATCH
			PRINT('An error occured.');
			PRINT('Error message: ' +  ERROR_MESSAGE());
			PRINT('Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR));
			PRINT('Error Line: ' + CAST(ERROR_LINE() AS NVARCHAR));
			PRINT('Error Procedure: ' + ERROR_PROCEDURE());

	-- Ending the catch statement
	END CATCH
END

-- Executing the stored procedure
EXEC UScustomersummary @country = 'Germany';

-- DROP stored procedure --> DROP PROCEDURE UScustomersummary

-- Complex queries
-- Give total orders and total sales, need split by country
SELECT
	COUNT(*) AS TotalOrders,
	SUM(sales) AS TotalSales
FROM sales.orders o
JOIN sales.Customers c
ON o.CustomerID = c.CustomerID
WHERE Country = @country

-- we will attach it to the first query


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--																						INDEXES

-- Creating a new table without any indexes
USE SalesDB;

SELECT *
INTO Sales.DBCustomers
FROM sales.customers

-- Creating clustered index
CREATE CLUSTERED INDEX idx_DBCustomers_CustomerID
ON sales.DBCustomers (customerID);

-- When you have a repeated query, create a nonclustered index
CREATE INDEX idx_DBCustomers_LastName
ON sales.DBCustomers (LastName)

SELECT *
FROM sales.DBCustomers
WHERE LastName = 'Brown';

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--																					PARTITIONS

-- Storing the partition logic in database
CREATE PARTITION FUNCTION PartitionByYear (DATE)
AS RANGE LEFT FOR VALUES ('2023-12-31', '2024-12-31','2025-12-31')

-- Creating file groups to split the data
ALTER DATABASE SalesDB ADD FILEGROUP FG_2023;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2024;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2025;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2026;

