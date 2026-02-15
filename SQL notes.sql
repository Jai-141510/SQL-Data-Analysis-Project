-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Database is a place where data is stored in the form of tables. Table are a collection of rows and columns.

-- SQL : Structured Query Language

-- DBMS : Database Management System : It is a software that manages a database and controls the flow of SQL queries into the database. Think of it like a load balancer for database.

-- RDBMS : Relational Database Mangement System. Same as before, just that, in RDBMS - the data is linked to one another, where tables have a relation with other tables.

-- Clauses : Clauses - SELECT, FROM, WHERE etc. Clauses specify what action is to be taken by the SQL.

-- Functions : Functions, for eg : LOWER - Transforms the data before providing an output

-- Identifiers : Identifiers are the column names that you want to retrive. Eg: Customers,  name, country etc.

-- Operators : =, <, >, != these are the operators. Usually used in WHERE clause which helps in retrieving a certain value of a specified condition.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- SELECT and FROM clause
-- SYNTAX
-- SELECT * ---> * is to select all the columns
-- FROM table ---> FROM will specify which table it has to get the data from.
-- Order of Operation here : SQL will first go to FROM to check where it has to get the data from and then will move to SELECT to find out what it has to retrieve.
-- (1) FROM (2) SELECT.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- WHERE clause (this is used to specify condition)
-- SYNTAX
-- SELECT *	
-- FROM table
-- WHERE condition
-- Order of Operation here : SQL will first go to FROM, then it will go to WHERE and filter out the condition row by row and then it will go to select to give out which columns
-- it has to give after filtering the rows. (1) FROM (2) WHERE (3) SELECT.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ORDER BY clause (this is used to order our data in either ascending [ASC] or descending order [DESC])
-- SYNTAX
-- SELECT *
-- FROM table
-- ORDER BY column ASC (Ascending)
-- ORDER BY column DESC (Descending)
-- Order of Operation here : (1) FROM (2) ORDER BY (3) SELECT

-- ORDER BY NESTED QUERY (this is used when you want the result with 2 or more specific data ordering, first by column1 and then by column2 (alphabetically if column is a string)
-- SYNTAX
-- SELECT *
-- FROM table
-- ORDER BY column1 ASC,  column2 DESC

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- GROUP BY clause (It is used to combine rows of the same value)
-- SYNTAX (For group by, remember, we should always be using 2 columns, one for category and one for aggregation)
-- SELECT country, sum(score)
-- FROM table
-- GROUP BY country
-- Order of operation here : (1) FROM (2) GROUP BY (3) the aggregate function in select (4) the rest of the select statement
-- Important point to note when using group by - While using GROUP BY, remember that the select statment should only have a column that either needs to be aggregated and
-- a column that needs to be grouped. Nothing more can be added else it will throw an error

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- HAVING CLAUSE (it is used only when GROUP BY clause is used to filter the groups)
-- SYNTAX
-- SELECT country, sum(score)
-- FROM table
-- GROUP BY country
-- HAVING SUM(score) > 500;
-- Order of operations here - (1) FROM (2) GROUP BY (3) HAVING (4) SELECT

-- WHERE vs HAVING
-- WHERE is used when you want to filter the data before aggregation, eg: you wish to have sum of scores grouped by country. But if you wish to filter out scores which are only above
-- 400, you would use WHERE clause before the GROUP BY.
-- HAVING clause is only used after the GROUP BY to process the aggregation condition.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- DISTINCT clause (Distinct is used to retrieve only unique values from a column, it removes the dupliate values from the result)
-- SYNTAX
-- SELECT DISTINCT column
-- FROM table
-- Order of Operations here - (1) FROM (2) SELECT (3) DISTINCT

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- TOP/LIMIT clause (TOP - SQL server, LIMIT - MySQL. TOP/LIMIT is used to restrict the number of rows retrieved by the query)
-- SYNTAX
-- SELECT TOP 3 *
-- FROM table
-- Order of operation here - (1) FROM (2) SELECT (3) TOP/LIMIT

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- IMPORTANT - EXECUTION ORDER
-- (1) FROM - from will run first because SQL has to find out which table it has to refer.
-- (2) WHERE - then the where clause to filter out the rows based on the condition
-- (3) GROUP BY - group by condition will always come after WHERE clause because if you use GROUP BY, you must use HAVING clause to filter the groups.
-- (4) HAVING - Having clause will run next to filter out the rows.
-- (5) SELECT - Select will be used now to select which columns the SQL has to retrieve.
-- (6) ORDER BY - Once all the filters are done, SQL will then order the rows according to the condition.
-- (7) LIMIT/TOP - SQL will now remove the rows according to the TOP/LIMIT clause.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- DDL (DATA DEFINITION LANGUAGE) -- CREATE ALTER DELETE
-- In DDL, you will not get any result as this is not a query, but rather a command. So the output box will only have "success" message.

-- CREATE TABLE - This is used to create a new table and specify the table structure.
-- SYNTAX
-- CREATE TABLE table name ( 
						-- column1 data_type contraint,
						-- column2 data_type contraint
						-- )

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ALTER TABLE - This is used to add or remove columns in the table.
-- SYNTAX
-- ALTER TABLE table name
-- ADD column data_type contraint.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- DROP - This is used to remove the entire table.
-- SYNTAX
-- DROP TABLE table name;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- DML commands

-- INSERT INTO - Insert into is used to insert any data into the table.
-- SYNTAX
-- INSERT INTO table_name (column_1, column_2, column_3) ---> Here, mentioning columns in optional, if columns are not mentioned, SQL expects you to give data for all the columns.
-- VALUES (value_1, value_2, value_3), ---> RULE: The values should match the number of columns.
--		  (value_1, value_2, value_3);
 

-- INSERTING VALUES FROM ONE TABLE INTO ANOTHER TABLE IF YOU ALREADY HAVE AN PRE-EXISTING DATA IN A TABLE FORMAT.
-- SYNTAX
-- INSERT INTO destination_table (column_1, column_2)
-- SELECT column_1, column_2
-- FROM source_table

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- UPDATE - Update command is used to update a specfic row in a table.
-- SYNTAX
-- UPDATE table_name
-- SET column_1 = value_1,
--	   column_2 = value_2;
-- WHERE condition --> -- IMPORTANT - UPDATE COMMAND SHOULD ALWAYS HAVE WHERE CLAUSE, ELSE IT WILL UPDATE ALL THE ROWS.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- DELETE command - It is used to delete the data in the table.
-- SYNTAX
-- DELETE FROM table_name
-- WHERE condition --> -- IMPORTANT - DELETE COMMAND SHOULD ALWAYS HAVE WHERE CLAUSE, ELSE IT WILL DELETE ALL THE ROWS.
-- If you want to delete everything from a table - Use TRUNCATE TABLE instead. Because, TRUNCATE uses less resources, does not store logs and is faster compared to DELETE.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--																			OPERATORS

--																	  COMPARISION OPERATORS


-- (1) = 'Equal to' operator is used to find the value that matches exactly to the condition.
-- (2) != <> 'Not Equal to' operator is used to find the value that does not match exactly to the condition.
-- (3) > 'Greater than' operator is used to find the value that is greater than the given condition.
-- (4) >= 'Greater than or equal to' operator is used to find the value that is greater than or equal to the given condition.
-- (5) < 'Less than' operator is used to find the value that is less than the given condition.
-- (6) <= 'Less than or equal to' operator is used to find the value that is less than or equal to the given condition.

--																	    LOGICAL OPERATORS

-- (1) AND operator - Both the conditions in AND operator should be TRUE for it to consider the data.
-- (2) OR opertor - At least 1 of the conditions must be TRUE.
-- (3) NOT opertor -  It will include all the rows except for condiion that is specified in the query.

--																	    RANGE OPERATORS

-- BETWEEN operator - It is to check if a value is within a specified range
-- NOTE - The lower and upper range value is included. So, if you say BETWEEN 100 and 500, it will include 100 and 500 as well.

--																	    MEMBERSHIP OPERATORS

-- IN operator - It will check if the value exist in the list.
-- Best place to use - If you find yourself using multiple OR operators or if the list of the values is high, it is more logical to use IN. IN also has better performance than OR.

-- NOT IN operator - Opposite of IN operator. It will include the values which does not exist in the list.

--																	     SEARCH OPERATORS

-- LIKE operator
-- We have to define a pattern
-- Patterns -
--		% When you use %, you are saying anything, either it could be no charecters at all, or only one charecter or multiple charecters.
--		_ When you use _, you are expecting to have exactly 1 charecter
-- (% is more widely used in the industry than _)

-- % - Examples : When you say M%, it will give all values starting with M. It will not give the result where M is in the middle. 'Emma' will not be accepted.
--				  When you use %in, it will give all values that end with in. It will not give the result if the value is Jasmine, it should end with in, like Vin, Martin.
--				  When you use %r%, it will give all the values which contain the R, either in the start, in the middle, or in the end. Maria, Peter etc will be accepted, Alice will not be accepted.
--				  When you use __b%, it will only give those values where b is in 3rd charecter. Albert, Rob will be accepted. Abel will not be accepted.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--																		JOINS

-- In simple words, JOINS is used to combine two tables using a common column. It helps to get a big picture or to get more information which is typically spread across multiple tables.

-- General confusion with JOINS and SET operator. JOINS is used to combine the columns of two tables. SET is used to combine rows, SET will place rows of 2nd table below the rows
-- of first table. It will not copy the columns. SET operator will make your table longer, JOINS will make your table wider.

-- Why Joins?
-- (1) To combine multiple tables so that we get a big picture. Eg: Combining all info about customers from order table, address table, reveiw table into one big table
-- (2) To get extra information - eg: We would combine zip code table to the customer table to get more info on the geography of our customers in a city.
-- (3) To check for data existence/non existence - We would combine 2 tables customers and orders to find out if there are customers that have not ordered in a few months.


--																		JOIN TYPES

-- NO JOIN - It returns the data from both the tables without combining them. It will give all rows from table 1 and table 2
-- SYNTAX
-- SELECT * FROM table1
-- SELECT * FROM table2


-- INNER JOIN - It returns only the matching rows from both the tables.
-- SYNTAX
-- SELECT *
-- FROM A INNER JOIN B  ---> If you don't specify the word INNER, it will use INNER JOIN by default.
-- ON A.key = B.key;
-- NOTE - The order of tables does not matter in INNER JOIN because we only want the common columns. It will give the same result if you interchange A and B.


-- LEFT JOIN - Returns all rows from left table and only matching from right table
-- SYNTAX
-- SELECT *
-- FROM A LEFT JOIN B  ---> Order of the table is very important.
-- ON A.key = B.key;


-- RIGHT JOIN - Returns all the rows from right table and only the matching from the left table
-- SYNTAX
-- SELECT *
-- FROM A RIGHT JOIN B  ---> Order of the table is very important.
-- ON A.key = B.key;
-- RIGHT JOIN is pretty much pointless as you can just switch the location of tables and use left join. Much more convinient.


-- FULL JOIN - It returns all the rows from both the tables
-- SYNTAX
-- SELECT *
-- FROM A FULL JOIN B  ---> Order of the table is not important
-- ON A.key = B.key;


--																		ADVANCED JOIN TYPES

-- LEFT ANTI JOIN - Return the rows from left table that has no match in right.
-- SYNTAX
-- SELECT *
-- FROM A LEFT JOIN B  ---> Order of the table is very important.
-- ON A.key = B.key;
-- WHERE B.key IS NULL;

-- FULL ANTI JOIN - Returns only rows that don't match in either tables
-- SYNTAX
-- SELECT *
-- FROM A FULL JOIN B  ---> Order of the table is not important
-- ON A.key = B.key;
-- WHERE B.key IS NULL OR A.key IS NULL;


-- CROSS JOIN - It combines every row from left with every row from right. It gives all possible combinations. It is also known as Cartersian Join
-- How does it work? It will join first row of table A with first row of Table B, and then first row of Table A to 2nd row of Table B, then 1st row of Table A to 3rd row of Table B
-- and so on.
-- To find out how many rows you will get as a result, just multiply the rows from table A to table B. Eg: Table A has 2 rows, Table B has 3 rows. Output = 2*3 = 6 rows
-- SYNTAX
-- SELECT *
-- FROM A CROSS JOIN B
-- No condion is required here, order of table does not matter as it is a multiplication.

-- Where can you use CROSS JOIN? - Let's say you wish to find out how each product looks with all different colors that you have, in this case, you would use cross join
-- just to find out how each product looks with each of the color.


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--																				SET OPERATORS

-- The number of columns in both the tables must be exactly the same.

-- SET operators can be used in almost all the clauses - WHERE, JOIN, GROUP BY, HAVING but ORDER BY is allowed only once at the end of the query.

-- The datatype of all the columns should be the same.

-- The order of columns should also always be the same.

-- The first query will control the naming of the output column names.


-- UNION - Union will return all the distinct rows from both the queries, it will remove all the duplicate rows from the result.
-- SYNTAX
-- SELECT column_1, column_2
-- FROM table_1
-- UNION
-- SELECT column_1, column_2
-- FROM table_2


-- UNION ALL - Union all returns all the rows from both queries, it will not remove duplicates. It is the only set operator which does not remove the duplicates
-- When will we use Union ALL instead of Union? If you know that your data does not have duplicates, always use UNION ALL because it is much faster than UNION as it does not 
-- perform the extra action of checking for duplicates.
-- SYNTAX
-- SELECT column_1, column_2
-- FROM table_1
-- UNION ALL
-- SELECT column_1, column_2
-- FROM table_2


-- EXCEPT operator - Returns all the distinct rows from the first query that are not a part of the second query
-- SYNTAX
-- SELECT column_1, column_2
-- FROM table_1
-- EXCEPT
-- SELECT column_1, column_2
-- FROM table_2


-- INTERSECT operator - Returns only the common rows that are present in both the queries
-- SYNTAX
-- SELECT column_1, column_2
-- FROM table_1
-- INTERSECT
-- SELECT column_1, column_2
-- FROM table_2

-- Where would we use the set operators??
-- To combine information before analyzing the data.
-- Let's say you have multiple tables which has data relating to some persons, instead of running separate queries in each of the table, you can use SET operators to combine 
-- them into 1 big table and then perform data analysis on that table.

-- If there are multiple tables containing orders of 2021, 2022, 2023, 2024 etc. If you want to make a report which has Year on Year performance from 2021 to 2024, you will
-- use UNION ALL set operator to combine all the rows and then generate a report using just 1 SQL query than having multiple SQL queries across all the tables.

-- Where would we use EXCEPT operator??
-- We can use EXCEPT to check for data discrepancies between databases. We can use EXCEPT to check if there is some data that has not been loaded into another database.
-- We can use EXCEPT in data engineering to load new data from source system to a data warehouse. EXCEPT can be used to make sure that duplicate values are not loaded.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--																		FUNCTIONS

-- Functions are used in SQL to clear, manipulate or analyze data.
-- Functions take one input value, change it to the required manner and then produces an output value.

-- Type of Functions -
--			--> (1) Single row functions - They take in one value and also give only one value output. EG: LOWER()
--			--> (2) Multi row functions - They take in multiple rows and give out a result. EG: SUM()

-- NESTED FUNCTIONS : We can use multiple functions together inside another function.

-- Single row functions sort of act as a data prep for the multi level functions as multi level functions are more analytical.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--																		STRING FUNCTIONS

-- CONCAT - Combines two string columns into one column. EG: Combine first name and last name into one column called NAME.
-- SYNTAX
-- SELECT CONCAT(column_1, ' ',  column_2) --> this adds space in between.
-- FROM table_name


-- UPPER AND LOWER function - UPPER is used to capitalize the entire string, LOWER is used to convert string to lowercase.
-- SYNTAX
-- SELECT UPPER(column_name) --> Same for LOWER.
-- FROM table_name


-- TRIM - This is very useful to remove all unnecessary spaces in a string, either at start, middle or end.
-- SYNTAX
-- SELECT TRIM(column_name)
-- FROM table_name


-- REPLACE - It is used to replace some value within a string to another value.
-- example syntax
-- SELECT '123-456-789'AS PHONE, REPLACE ('123-456-789', '-', '')


-- LEN - It calculates the length of the string.
-- SYNTAX
-- SELECT LEN(column_name)
-- FROM table_name


-- LEFT and RIGHT function - it is used to extract the string from a value depending on the number of charceters you specify
-- SYNTAX
-- SELECT LEFT(value, no of charecters)
-- FROM table_name


-- SUBSTRING - To extract a specific value in between a string.
-- SYNTAX
-- SUBSTRING(value, start_position, length)
-- Tip - Use LEN function for length so that u dont have to use any static value and make the query dynamic.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--																		NUMBER FUNCTIONS

-- ROUND FUNCTION - It is used to round up or round down after a certain decimal value
-- Eg: Number - 3.516, if you choose ROUND 2, it will decide if it has to round up or down based on the 3rd value, here 3rd value is 6, so it will round up and result will be - 3.52
-- ROUND 1 --> It will decide based on 2nd digit - 1. Because it is less than 5, it will remain the same and result will be - 3.5
-- ROUND 0 --> It will decide based on the number just after the decimal, here it is 5 (5 and above 5 will be rounded up). So, the result will be 4.0


-- ABS (ABSOLUTE) - It will convert the negative number to positive number.
-- SYNTAX
-- SELECT ABS(-10)

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--																		 DATE AND TIME FUNCTION

-- PART EXTRACTION

-- DAY() - Returns the Day from the date, MONTH() - Returns the Month from the date, Year() - Returns the year from the date.

-- DATEPART() - It will extract more information about the date, eg - week, quarter etc.
-- SYNTAX
-- SELECT DATEPART(part we want to extract, date_column) --> if you want for a specific date, use '' -- eg: DATEPART(month, '2025-08-20')

-- DATENAME() - It will extract the string format of a date, eg: August etc. For the days like wednesday, friday etc, we will get numbers but they will be in STRING format and not INT.
-- SYNTAX
-- SELECT DATENAME(part we want to extract, date_column)


-- DATETRUNC() - Truncates the date to a specific part, it does not extract any date, but rather resets the part of the date you do not need.
-- SYNTAX
-- SELECT DATETRUNC(part we want to extract, date_column)


-- EOMONTH() - End of Month function, it will change the date to the last day of the month.
-- SYNTAX
-- EOMONTH(DATE)

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--																DATE AND TIME FUNCTION - FORMATTING AND CASTING

-- FORMATTING - Changing the format of date from one format to another format. Eg: Changing format from 2025-08-20 to 08/20/25 etc.
-- CASTING - Changing the datetype from string to number, date to string, string to date etc.

-- FORMAT()
-- SYNTAX
-- SELECT FORMAT(value, format, culture) --> culture is optional,  it is to show the data specific to a geography or industry standard.
-- FROM table_name;

-- CONVERT()
-- SYNTAX
-- CONVERT(data_type, value) Eg: CONVERT (INT, '124'), CONVERT(VARCHAR, OrderDate)


-- CAST()
-- SYNTAX
-- SELECT CAST(value AS data_type); Eg: CAST('123' AS INT)

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--																DATE AND TIME FUNCTION - ADD/SUBTRACT FROM DATE

-- DATEADD() - We can add year, month or date and even subtract it
-- SYNTAX
-- SELECT DATEADD(part to add/subtract, by how much, value) Eg: DATEADD(year, 2, OrderDate) - this will add 2 years to the date.

-- DATEDIFF() - To find out how many days have been passed since 2 days.
-- SYNTAX
-- DATEDIFF(part to add/subtract, start_date, end_date)


-- ISDATE() - Check if a value is a date, it will return 1 if it is a valid date, 0 if it is not a valid date.
-- SYNTAX
-- SELECT ISDATE('2025-08-20') ---> this will return as 1 as it is a valid date.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--																					NULLS

-- ISNULL()/IFNULL() - Replaces a NULl value with another value. LIMIITED to 2 values only. But if you want to optimize performance, ISNULL is better. IFNULL - MYSQL.
-- SYNTAX
-- ISNULL(column, replacement_value/replacement_column) --> It will find the nulls in the column and replace it with whatever you provide in replacement. 
-- We can also include a column in replacement value.


-- COALESCE() - It acts the same way as ISNULL but this function can accept multiple columns. It is SLOWER than ISNULL but has wide range.
-- SYNTAX
-- COALESCE(column1, column2, column3, replacement_value)


-- In a case when there is a null value in the key to join tables, it will cause problems as SQL will either skip that row in result
-- This will need to be dealt with first before joining tables.
-- example code
-- SELECT a.year, a.type, a.orders, b.sales
-- FROM table1 a INNER JOIN table2 b
-- ON a.year = b.year
-- AND COALESCE(a.type, '') = COALESCE(b.type, '')

-- SORTING
-- If you sort the column ASC, it will show the nulls in the start, if you do DESC, it will show nulls in the end.


-- NULLIF() - NULLIF has 2 values, value1 and value2, SQL will go over the value1 and if it finds a row which has value2, it will replace it with NULL
-- SYNTAX
-- NULLIF(value1, value2) --> only 2 values.
-- Eg: NULLIF(price, -1) ---> Here if SQL finds a price which is -1, it will replace that row with NULL.
-- Eg 2: NULLIF(original_price, discounted_price) --> Here, if original price is equal to discounted price, that will be an issue, in that case it will flag it to NULL.


-- IS NULL - It will return true if the value is null, will return false if value is not null.
-- SYNTAX
-- column_name IS NULL/IS NOT NULL
