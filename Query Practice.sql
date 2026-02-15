-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- USE database_name will select the database that you want to execute your code in.
USE MyDatabase;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- PRACTICING SELECT and FROM query
SELECT * 
FROM customers;

-- Specific columns
SELECT first_name, country, score
FROM customers;

-- Retrieve all order data
SELECT * 
FROM orders;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Using WHERE clause
-- Retrieve customers with a score not equal to 0
SELECT *
FROM customers
WHERE score != 0;	

-- Retrieve customers from Germany
SELECT *
FROM customers
WHERE country = 'Germany';

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Using ORDER BY clause
-- Retrieve all the customers and sort the result by the highest score first.
SELECT *
FROM customers
ORDER BY score DESC;

-- Retrieve all the customers and sort the result by the lowest score first.
SELECT *
FROM customers
ORDER BY score ASC;

-- [NESTED ORDER BY] Retrieve all the customers and sort the result by the country and then by the highest score.
SELECT * 
FROM customers
ORDER BY country ASC, score DESC;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Using GROUP BY clause
-- Find the total score for each country
-- Use alias as the resulting query will not have a column name
SELECT country, SUM(score) AS Total_Score
FROM customers
GROUP BY country

-- In the above query, can I add first name to the query? Answer is NO. Because in group by, you should either have the column which you can aggregate with or the column you have
-- chosen to group. Nothing else can be added in the select statement.
-- If you want first name, it should be added to both SELECT and GROUP BY statement.

SELECT country, first_name, SUM(score) AS Total_Score
FROM customers
GROUP BY country, first_name;

-- Find total score and total number of customers for each country
SELECT  country, SUM(score) AS Total_score, COUNT(*) AS Total_customers
FROM customers
GROUP BY country;

-- Find the average score for each country considering only customers with a score not equal to 0 and return only those countries with an average score greater than 430
SELECT country, AVG(score) AS Average_score
FROM customers
WHERE score != 0
GROUP BY country
HAVING AVG(score) > 430;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Using DISTINCT clause
-- Return unique list of all countries
SELECT DISTINCT(country)
FROM customers;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Using TOP/LIMIT (SQL SERVER - TOP)
-- Retrive only 3 customers
SELECT TOP 3 *
FROM customers;

-- Retrive the TOP 3 customers with the highest scores
SELECT TOP 3 first_name, score
FROM customers
ORDER BY score DESC;

-- Retrive the lowest 2 customers based on the score
SELECT TOP 2 first_name, score
FROM customers
ORDER BY score ASC;

-- Get the 2 most recent orders
SELECT TOP 2 *
FROM orders
ORDER BY order_date DESC;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Create a new table called persons and add columns : id, person_name, birth_date and phone
CREATE TABLE persons (
					id INT PRIMARY KEY,
					person_name VARCHAR(50) NOT NULL,
					birth_date DATE,
					phone VARCHAR(15) NOT NULL
					);

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ALTER TABLE command
ALTER TABLE persons
ADD email VARCHAR(50) NOT NULL;
-- Check - 
SELECT *
FROM persons;

-- Removing the new column
ALTER TABLE persons
DROP COLUMN phone;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- DROP command
DROP TABLE persons;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- INSERT INTO command
INSERT INTO customers
			(id, first_name, country, score)
VALUES		(6, 'Anna', 'USA', NULL),
			(7, 'Sam', NULL, 100);
-- Checking if table is updated
SELECT *
FROM customers;

-- Inserting values from customers table into persons table
 
INSERT INTO persons (id, person_name, birth_date, phone)
SELECT id, first_name, NULL, 'Unknown'
FROM customers;

SELECT * 
FROM persons;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- UPDATE command
-- Change the score of customer 6 to 0
UPDATE customers
SET score = 0
WHERE id = 6;

-- Change the socre of customer with ID 10 to 0 and update the country to UK
UPDATE customers
SET score = 0, country = 'UK'
WHERE id = 10;

-- Update all customers with a NULL score by setting their score to 0
UPDATE customers
SET score = 0
WHERE score IS NULL;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- DELETE command
-- Delete all customers with an ID greater than 5
DELETE FROM customers
WHERE id > 5;

SELECT * 
FROM customers;

-- Delete all data from the persons table
TRUNCATE TABLE persons;

SELECT * 
FROM persons;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Operators
-- Comparision Operators

-- = 'Equal to'
-- Retrieve all customers from Germany
SELECT *
FROM customers
WHERE country = 'Germany';

-- != <> 'Not Equal to'
-- Retrieve all customers who are not from Germany
SELECT *
FROM customers
WHERE country <> 'Germany';

-- > 'Greater than'
-- Retrive all customers with a score greater than 500
SELECT *
FROM customers
WHERE score > 500;

-- >= 'Greater than or equal to'
-- Retrive all customers with a score greater than or equal to 500
SELECT *
FROM customers
WHERE score >= 500;

-- < 'Less than'
-- Retrieve all customers with a score less than 500
SELECT *
FROM customers
WHERE score < 500;

-- <= 'Less than or equal to'
-- Retrieve all customers with a score of 500 or less
SELECT *
FROM customers
WHERE score <= 500;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Logical Operator

-- AND operator
-- Retrieve all customers who are from the USA and have a score greater than 500
SELECT *
FROM customers
WHERE country = 'USA' AND score > 500;

-- OR operator
-- Retrieve all customers who are from the USA or have a score greater than 500
SELECT *
FROM customers
WHERE country = 'USA' OR score > 500;

-- NOT operator
-- Retrieve all customers who are from the USA or have a score greater than 500
SELECT *
FROM customers
WHERE NOT score < 500;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Range Operator

-- BETWEEN operator
-- Retrieve all customers whose score falls in the range between 100 and 500
SELECT *
FROM customers
WHERE score BETWEEN 100 AND 500;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Membership Operator

-- IN operator
-- Retrive all customers from either Germany or USA
SELECT *
FROM customers
WHERE country IN ('Germany', 'USA');

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Search Operator

-- Like operator (% and _)
-- Find all customers whose first name starts with 'M'
SELECT *
FROM customers
WHERE first_name LIKE 'M%';

-- Find all customers whose first name ends with 'n'
SELECT *
FROM customers
WHERE first_name LIKE '%n';

-- Find all customers whose first name contains an 'r'
SELECT *
FROM customers
WHERE first_name LIKE '%r%';

-- Find all customers whose first name has an 'r' in the 3rd position
SELECT *
FROM customers
WHERE first_name LIKE '__r%';

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--																				JOINS

-- NO JOIN
-- Retrieve all data from customers and orders in different results
SELECT *
FROM customers;
SELECT * 
FROM orders;

-- INNER JOIN
-- Get all customers along with the orders, but only for the customers who have placed orders
SELECT c.id, c.first_name, o.order_id, o.sales
FROM customers c INNER JOIN orders o
ON c.id = o.customer_id;

-- LEFT JOIN
-- Get all customers along with their orders, including those without orders
SELECT c.id, c.first_name, o.order_id, o.sales
FROM customers c LEFT JOIN orders o
ON c.id = o.customer_id;

-- RIGHT JOIN
-- Get all customers along with their orders, including those orders without matching customers
SELECT o.order_id, o.order_date, c.id, c.first_name
FROM customers c RIGHT JOIN orders o
ON c.id = o.customer_id;

-- FULL JOIN
-- Get all customers and all orders, even if there's no match
SELECT *
FROM customers c FULL JOIN orders o
ON c.id = o.customer_id;


-- LEFT ANTI JOIN
-- Get all customers who haven't placed any orders
SELECT *
FROM customers c LEFT JOIN orders o
ON c.id = o.customer_id
WHERE o.customer_id IS NULL

-- Get all orders without matching customers
SELECT *
FROM orders o LEFT JOIN  customers c
ON c.id = o.customer_id
WHERE c.id IS NULL;

-- FULL ANTI JOIN
-- Find customers without orders and orders without customers
SELECT *
FROM customers c FULL JOIN orders o
ON c.id = o.customer_id
WHERE c.id IS NULL OR o.customer_id IS NULL;

-- Get all customers along with their orders, but only for customers who have placed an order - WITHOUT USING INNER JOIN
SELECT *
FROM customers c FULL JOIN orders o
ON c.id = o.customer_id
WHERE c.id IS NOT NULL AND o.customer_id IS NOT NULL;

-- Generate all possible combinations of customers and orders
SELECT *
FROM customers CROSS JOIN orders;


-- Using SalesDB, Retrieve a list of all orders, along with the related customer, product and employee details
-- Get order id, customer  name, product name, sales, price, sales person name.

USE SalesDB;

SELECT 
	o.OrderID,
	c.FirstName as CustomerFirstName,
	c.LastName as CustomerLastName,
	p.Product,
	o.Sales,
	p.Price,
	e.FirstName as SalesPersonFirstName,
	e.LastName as SalesPersonLastName
FROM Sales.Orders o
LEFT JOIN Sales.Customers c
ON o.CustomerID = c.CustomerID
LEFT JOIN sales.Products as p
ON o.ProductID = p.ProductID
LEFT JOIN Sales.Employees e
ON o.SalesPersonID = e.EmployeeID;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--																				SET OPERATORS

-- UNION
-- Combine the data from employees and customers into one table
SELECT customerID As ID, FirstName, LastName
FROM sales.Customers
UNION
SELECT EmployeeID, FirstName, LastName
FROM sales.Employees;

-- UNION ALL
-- Combine the data from employees and customers into one table, including duplicates
SELECT customerID as ID, FirstName, LastName
FROM sales.customers
UNION ALL
SELECT EmployeeID, FirstName, LastName
FROM sales.Employees;

-- EXCEPT operator
-- Find all the employees who are not customers at the same time
SELECT EmployeeID, FirstName, LastName
FROM sales.Employees
EXCEPT
SELECT CustomerID, FirstName, LastName
FROM sales.Customers;

-- INTERSECT operator
-- Find the employees who are also customers
SELECT EmployeeID, FirstName, LastName
FROM sales.Employees
INTERSECT
SELECT CustomerID, FirstName, LastName
FROM sales.Customers;

-- Orders are stored in separate tables (orders and ordersarchive). Combine all orders into one report without duplicates.
SELECT 'Orders' AS SourceTable , *
FROM sales.Orders
UNION
SELECT 'OrderArchieve' AS SourceTable,  *
FROM sales.OrdersArchive
ORDER BY OrderID;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--																				FUNCTIONS
-- CONCAT
-- Show a list of customers' first names together with their country in one column
USE MyDatabase

SELECT first_name, country, CONCAT (first_name, ' ', country) AS name_country
FROM customers;



-- LOWER AND UPPER
-- Convert the first name as lowercase
SELECT LOWER(first_name) AS low_name
FROM customers;

-- Convert the first name as lowercase
SELECT UPPER(first_name) AS up_name
FROM customers;


-- TRIM function
-- Find customers whose first name contains leading or trailing spaces
SELECT first_name
FROM customers
WHERE first_name != TRIM(first_name);
-- or [the above one is much better]
SELECT first_name, LEN(first_name)
FROM customers;

-- Trim it now
SELECT first_name, LEN(first_name), LEN(TRIM(first_name))
FROM customers;


-- REPLACE function
-- Remove dashes from a phone number
SELECT '123-456-789'AS PHONE, REPLACE ('123-456-789', '-', '') AS CLEANPHONE

-- Replace the file name from .txt to .csv
SELECT 'report.txt' AS OldFileName, REPLACE('report.txt', '.txt', '.csv') AS NewFileName;


-- Calculate the LENGTH of each customer's first name
SELECT first_name, LEN(first_name) AS len_FirstName
FROM customers;


-- LEFT and RIGHT
-- Retrieve the first 2 characters in each of the first name.
-- We will use TRIM to fix the name for JOHN which has a leading space.
SELECT LEFT(TRIM(first_name), 2) AS len_2_FirstName
FROM customers;

-- Retrieve last 2 characters for each first name
SELECT RIGHT(first_name, 2) AS len_2_end_name
FROM customers;


-- SUBSTRING function
-- Retrieve a list of customers' first name after removing the first character
SELECT SUBSTRING(TRIM(first_name), 2, LEN(TRIM(first_name))) AS sub_name
FROM customers;


-- ROUND FUNCTION
SELECT 3.516, ROUND(3.516, 2) AS Round_2, ROUND(3.516, 1) AS Round_1, ROUND(3.516, 0) AS Round_0;

-- ABS Function
SELECT -10 AS Negative_Value, ABS(-10) AS Positive_Value;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--																		DATE AND TIME FUNCTIONS

-- Extract year, month and date from the entire date
USE SalesDB;

SELECT OrderID, CreationTime, 
	   YEAR(CreationTime) AS YEAR, 
	   MONTH(CreationTime) AS MONTH,
	   DAY(CreationTime) AS DAY
FROM sales.Orders

-- Using DATEPART function - MUCH BETTER
 

-- Using DATENAME function -- DATA TYPE FOR DAY WILL BE STRING
SELECT OrderId, CreationTime,
	   DATENAME(MONTH, CreationTime) AS MONTH_NAME,
	   DATENAME(DAY, CreationTime) AS DAY_NAME
FROM sales.Orders;

-- Using DATETRUNC function
SELECT OrderID, CreationTime,
	   DATETRUNC(MINUTE, CreationTime) AS MinuteDate_Trunc,
	   DATETRUNC(DAY, CreationTime) AS NoTime_Trunc
FROM sales.Orders;

-- Tell me how many orders did we get for each month
SELECT DATETRUNC(month, CreationTime) AS MONTH, COUNT(*) AS Orders
FROM sales.Orders
GROUP BY DATETRUNC(month, CreationTime);


-- EOMONTH() function --> CAST function will remove all the extra 000 in the end while using DATETRUNC
SELECT OrderID, CreationTime, 
	   EOMONTH(CreationTime) AS EOM,
	   CAST(DATETRUNC(Month, CreationTime) AS DATE) AS SOM
FROM sales.orders;


-- USE CASES FOR DATE FUNCTIONS
-- How many orders were placed each year?
SELECT YEAR(OrderDate) AS YEAR, count(*) AS NumberOforders 
FROM sales.orders
GROUP BY YEAR(OrderDate);

-- How many orders were placed each month? - Additionally I have ordered correctly by the months
SELECT MONTH(OrderDate), DATENAME(MONTH, OrderDate) AS MONTH, count(*) AS NumOfOrders
FROM sales.orders
GROUP BY DATENAME(MONTH, OrderDate), MONTH(OrderDate)
ORDER BY MONTH(OrderDate);

-- Show all orders that were placed during the month of February
SELECT *
FROM sales.orders
WHERE MONTH(OrderDate) = 2;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- FORMAT AND CASTING
-- FORMAT
SELECT OrderID, CreationTime,
	   FORMAT(CreationTime, 'dd') AS DD,
	   FORMAT(CreationTime, 'ddd') AS DDD,
	   FORMAT(CreationTime, 'dddd') AS DDDD,
	   FORMAT(CreationTime, 'MM') AS MM,
	   FORMAT(CreationTime, 'MMM') AS MMM,
	   FORMAT(CreationTime, 'MMMM') AS MMMM,
	   FORMAT(CreationTime, 'MM-dd-yyyy') AS USA_FORMAT
FROM sales.orders;

-- Show creation time using the following format: Day Wed Month quarter year hh:mm:ss AM/PM

SELECT OrderId, CreationTime,
	   'Day ' + FORMAT(CreationTime, 'ddd MMM') + 
	   ' Q' + DATENAME(QUARTER, CreationTime)
	   + ' ' + FORMAT(CreationTime, 'yyyy hh:mm:ss tt') AS CustomFormat
FROM sales.orders;


-- CONVERT ------- PRO TIP:  [] will give more freedom to name columns with spaces.
SELECT CONVERT(INT, '1234') AS [String to int convert],
	   CONVERT(DATE, CreationTime) AS [DATETIME to DATE convert]
FROM sales.orders;


-- CAST() Function
SELECT CAST('123' AS INT) AS [STRING TO INT], CreationTime,
	   CAST(CreationTime AS DATE) AS [DATETIME TO DATE]
FROM sales.orders;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- DATE ADD OR SUBTRACT
SELECT orderID, orderdate,
	   DATEADD(month, 2, orderdate) AS [2 MONTHS LATER],
	   DATEADD(Year, 2, orderdate) AS [2 Years LATER],
	   DATEADD(Day,-10, orderdate) AS [10 days earlier]
FROM sales.orders;

-- DATEDIFF
-- Calculate the age of employees
SELECT FirstName, LastName, BirthDate,
	   DATEDIFF(YEAR, BirthDate, GETDATE()) AS [AGE OF EMPLOYEES]
FROM sales.Employees;

-- Find the average shipping duration in days for each month
SELECT MONTH(orderdate) AS [MONTH OF ORDER],
	   AVG(DATEDIFF(DAY, OrderDate , ShipDate)) AS [Time taken to ship]
FROM sales.Orders
GROUP BY MONTH(orderdate);

-- Time Gap Analysis
-- Find the number of days between each order and the previous order
SELECT OrderId, OrderDate AS [Current Order Date],
	   LAG(Orderdate) OVER (order by OrderDate) AS [Previous order date],
	   DATEDIFF(DAY,  LAG(Orderdate) OVER (order by OrderDate), OrderDate) AS [Days between each order]
FROM sales.orders;

-- ISDATE()
SELECT ISDATE('123') AS [CHECKING DATE],
	   ISDATE('2025-08-20') AS [CHECKING DATE 2],
	   ISDATE('20-08-2025') AS [CHECKING DATE 3], -- this will be 0 because it does not follow the ISO standard of SQL.
	   ISDATE('2025') AS [CHECKING DATE 4]


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--																			NULLS
-- ISNULL and COALESCE
-- Find the average scores of the customers (take care of nulls)
USE SalesDB;

-- Finding out if there is a NULL
SELECT *
FROM sales.Customers
WHERE score IS NULL;

-- Replacing NULL with 0
SELECT customerID, score, COALESCE(score, 0) AS [FIXED SCORE],
	   AVG(score) OVER() AS [AVERAGE SCORE 1],
	   AVG(COALESCE(score, 0)) OVER() AS [AVERAGE SCORE 2]
FROM sales.customers;


-- Display the full name of customers in a single field by merging their first and last names, and add 10 bonus points to each customers' score
SELECT *
FROM sales.Customers;

SELECT FirstName, LastName,
	   CONCAT(FirstName, ' ', LastName) AS [MERGED NAME],
	   LEN(CONCAT(FirstName, ' ', LastName)) AS [NAME LENGTH],
	   score,
	   COALESCE(score, 0) + 10 AS [BONUS SCORE]
FROM sales.customers;

-- Sort the customers from lowest to highest scores with nulls appearing last.

SELECT customerID, score,
CASE
	WHEN score IS NULL THEN 1
	ELSE 0
	END AS [FLAG]
FROM sales.customers
ORDER BY CASE
	WHEN score IS NULL THEN 1
	ELSE 0
	END,
	score;

-- Find the sales price for each order by dividing the sales by the quantity.
-- This is how you prevent dividing by 0
SELECT OrderID,Quantity, Sales,
	   Sales/NULLIF(Quantity, 0) AS [SALES PRICE]
FROM sales.orders


-- Identify the customers who have no scores
USE SalesDB;

SELECT CustomerID, score
FROM sales.Customers
WHERE score IS NULL;

-- Show a list of all customers who have scores
SELECT CustomerID, FirstName, LastName, Score
FROM sales.customers
WHERE score IS NOT NULL;

-- List all details for customers who have not placed any orders
SELECT c.*, o.orderID, o.ProductID
FROM sales.customers c LEFT JOIN sales.orders o
ON c.CustomerID = o.CustomerID
WHERE o.orderID IS NULL;