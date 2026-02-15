
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--																	CASE STATEMENTS

-- In short, its a conditional statement
-- SYNTAX
-- CASE
		-- WHEN condition1 THEN result1
		-- WHEN condition2 THEN result2
-- ELSE result  --> Optional
-- END

-- You can also use CASE COLUMN and then just specifiy values inside that to make the query even faster. BUT it is only for = operator.
-- EG - CASE COUNTRY
	--		WHEN 'Germany' THEN 'DE'



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--																	 WINDOW FUNCTIONS

-- Window functions perform aggregations on row level, that is, unlike GROUP BY which will shrink the number of rows down to show the average, sum or count etc, window functions
-- will not shrink down, the level of detail is not compromised and you will get the same result but now it will be shown as a new column side by side the original data.

--  Use case : When you wish to have the details and also need aggregations. GROUP BY will not allow you to have both.

-- OVER() - This will tell SQL that you are using window functions
-- PARTITION BY - This is another word for group by, used inside window functions.

-- SYNTAX

-- (1) Window functions start with aggregate functions/Rank functions/Value functions - SUM, AVG, COUNT, LEAD, LAG, RANK etc
-- (2) OVER - over is used to tell SQL we are using window function
-- (3) Condition - Condition is used to filter out data even more

-- PARTITION BY
-- Another word for GROUP BY, it is used to divide our data. If you dont use PARTITION BY, SQL will use the whole data for calculation.
-- We can use list of columns in PARTITION BY

-- Using order by in window function
-- Order by is used after the partition by, so when you use partition by, it will divide the data and then the order by clause will be activated and it will sort the 
-- data within the groups.



-- FRAME clause in window function
-- Imagine it like a window inside a window. First you would use partition by to divide the data into multiple windows, then you would use FRAME clause to extract just a 
-- tiny group of data inside that window.

-- We cannot use FRAME clause without the order by CLAUSE

-- EXAMPLE SYNTAX
-- AVG(SALES) OVER(PARTITION BY category ORDER BY OrderDate ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)

-- Frame - 
	-- It has 2 frame, lower frame and upper frame
	-- Lower frame accepts - CURRENT ROW, N PRECEDING, UNBOUNDED PRECEDING
	-- Upper frame accepts - CURRENT ROW, N FOLLOWING, UNBOUNDED FOLLOWING


-- LIMITATIONS OF WINDOW FUNCTIONS
-- Can only be used in SELECT Clause and ORDER BY clause
-- We cannot do nesting
-- Window function is executed after WHERE clause
-- Can be used by group by only if you use the columns are a part of GROUP BY

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--																		RANK FUNCTIONS

-- RANK () - It will provide ranks to the data, we should have order by for this to work. It will not allow you to have any expression inside the clause
-- SYNTAX
-- RANK() OVER(PARTITION BY column_name, order by column_name)

-- ROW_NUMBER() - It will assign a row number to each value. It will assign a unique value even if there are duplicates in the source data.
-- SYNTAX
-- ROW_NUMBER() OVER(ORDER BY column_name)


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--																		WINDOW VALUE FUNCTIONS

-- LEAD AND LAG functions
-- LEAD() - It allows you to access a value from the next row within a window
-- LAG() - It allows you to access a value from the previous row within a window
-- SYNTAX
-- LEAD/LAG(column_1, no of rows forward, default value if no row available) OVER (PARTITION BY column ORDER BY column)
-- if you dont specify the number of rows, it will by default pick 1
-- if you dont specify the default value, it will by default use NULL
-- ORDER BY IS A MUST!!

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ANY/ALL operator
-- ANY - If any of the options match, it will give result
-- ALL - All the conditions should match perfectly. It is more restrictive

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--																		COMMON TABLE EXPRESSION

-- Big difference between subquery and CTE is that CTE can be used by multiple queries in the main query, but for subquery, it can only be used once by the main query.

--																			Non-Recrusive CTE
-- Subtype - 
-- Standalone CRE
-- It runs independently and does not depend on other CTEs

-- CTE SYNTAX
-- WITH ctename AS
-- (
-- SELECT FROM WHERE
-- )

-- Outside we can use CTE like - 
--				SELECT
--				FROM Ctename
--				WHERE

-- POINT TO NOTE : We cannot use ORDER BY in CTE


-- Multiple CTEs
-- SYNTAX
-- WITH CTE_NAME AS
-- (
-- SELECT FROM WHERE
-- )
-- , CTE_NAME_2 AS
-- (
-- SELECT FROM WHERE
-- )

-- MAIN QUERY
-- SELECT
-- FROM CTE_NAME_1
-- JON CTE_NAME_2
-- WHERE


-- NESTED CTE
-- Using CTE inside another CTE


-- RECURSIVE CTE
-- It is used to define loops in a CTE, usually used in a hirerarchy
-- SYNTAX
-- WITH cte_name AS 
-- (
-- SELECT FROM WHERE
-- UNION ALL
-- SELECT FROM WHERE
--)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*																				VIEWS

 It is a virtual table that will present the data from the database for further analysis
 SYNTAX
 CREATE VIEW AS view_name AS
 (
 SELECT FROM WHERE
 )

 DROPING VIEWS -
 SYNTAX
 DROP VIEW view_name

 ALTERING VIEWS
 ALTER VIEW

 ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
																		CREATING TABLES, CTAS

 CREATE/INSERT Method of creating table
 -> It helps us to create a table from the scratch

 CTAS method
 -> It helps us to create a table using select statement from a pre-existing table

 CTAS vs VIEWS 
 -> In VIEWS, once u create a view, everytime you execute a query, SQL will run the VIEW query from the database and then provide the result. It has to contact the main table.
 -> In CTAS, SQL will not query the main table, it will store the result as a separate table and the result of the query will be fetched from the CTAS table directly. No contact to main table

 -> VIEWS are slower than CTAS as in view, SQL has to contact the database everytime.

 -> For VIEWS, if the original table is updated, the view table will also be updated
 -> But, in CTAS, the new updates are not shown in the new table.

 ---------------------------
 CREATE/INSERT SYNTAX
 CREATE TABLE table_name
 (
 column1 datatype,
 column2 dataype
 )

 INSERT INTO table_name
 VALUES (data1, data2)
 ---------------------------
 -- The below is for MYSQL
 CTAS SYNTAX [CREATE TABLE NAME AS - CTAS full form]
 CREATE TABLE table_name AS
 (
 SELECT FROM WHERE
 ) 

 -- Query for SQL server
 SELECT
 INTO
 FROM 
 WHERE


 - USECASE
 - To take a snapshot of the table to analyse when there is some problem with the data quality because if the table is constantly updating, it will be difficult and time consuming
  to extract data everytime and correctly understand the issue.


  --																		TEMPORARY TABLES
  
  Temp tables live in the database only for one session, once you disconnect a session, it will be removed.
  SYNTAX
  SELECT
  INTO #table_name
  FROM
  WHERE

  ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
																			 STORED PROCEDURES

  In simple words, query which is stored in the server side of the database which you have to run everyday. You can store multiple sql statements in stored procedure and just run
  the stored procedure which will run all the queries.

  Useful for repetitive queries that you have to run everyday.

  SYNTAX
  CREATE PROCEDURE procedurename AS
  BEGIN
  sql statement here
  END

  EXEC proecurename --> this is used to execute stored procedure.


-- IF ELSE statement in stored procedure
-- It can be used to treat nulls
-- SYNTAX
-- IF
-- BEGIN
-- condition
-- END

-- TRY CATCH
-- This is done to organize your error handling procedure. Try statement is generated and if it encounters error, it will jump to catch statement and execute that.
-- SYNTAX
-- BEGIN TRY
-- codes
-- END TRY
-- BEGIN CATCH
-- catch statements
-- END CATCH


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--																						INDEXES

Clustered index - It physically sorts and stores the data in index order, only 1 is allowed per table and it usually is the primary key. Slow write, fast read

Non-Clusterd index - It does not sort the data, rather it creates a pointer to point the data in the table. Multiple allowed per table. Fast write, okayish read.

More reads few writes - Clustered index
Heavy writes - Non clustered index

Primary key will automatically create a clustered index.

SYNTAX --> Default index will always be non-clustered index.

CREATE INDEX index_name ON table_name (column1, column2,..)

WHERE clause cannot be used on a clustered index

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

																					PARTITIONS

SYNTAX

CREATE PARTITION FUNCTION partition_name (datatype)
AS RANGE LEFT/RIGHT FOR VALUES (boundaries)

CREATING FILE GROUPS
ALTER DATABASE dbname ADD FILEGROUP filegroup_name


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

																					Performance tips

-- Check execution plan, if no difference, pick the one which is easier to read

Fetching data - 

-- Select only what you need, avoid using select *
-- Don't use distinct and order by too much. Check for duplicates, if you dont have one, dont use distinct. Distinct and order by are very expensive.
-- To explore the table, use LIMIT/TOP. Don't fetch millions of records just for exploration.

Filtering data - 

-- Create nonclustered index on frequently used WHERE clause.
-- Avoid applying functions (eg LOWER UPPER) in WHERE clause. SQL will not use INDEX if you use functions.
-- Use IN instead of OR for multiple conditions. OR is very expensive plus it is hard to read.

Joining data - 

-- Try to use index in the common column that you use to join. This will speed up the process.
-- Try to use CTE or subquery to prepare the data before joining it.
-- Don't use OR in joins, it will avoid indexes. Use UNION instead.

Aggregating data -

-- Use columnstore index for aggregations.