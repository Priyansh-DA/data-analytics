create database superstore_db;
create database Returnorder_db;

use superstore_db;
use Returnorder_db;

create 	table Return_Order(
    Order_ID varchar(200),
    Status varchar(50)
);


SHOW VARIABLES LIKE 'secure_file_priv';
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/return order.csv'
INTO TABLE Orders_Raw
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS





SHOW VARIABLES LIKE 'secure_file_priv';

CREATE TABLE Orders_Raw (
    Customer_Name VARCHAR(255),
    Customer_ID VARCHAR(50),
    Row_ID VARCHAR(50),
    Lenghth VARCHAR(50),
    Order_Priority VARCHAR(50),
    Discount VARCHAR(50),
    Unit_Price VARCHAR(50),
    Shipping_Cost VARCHAR(50),
    Ship_Mode VARCHAR(100),
    Customer_Segment VARCHAR(100),
    Product_Category VARCHAR(100),
    Product_Sub_Category VARCHAR(100),
    Product_Container VARCHAR(100),
    Product_Name TEXT,
    Product_Base_Margin VARCHAR(50),
    Country VARCHAR(100),
    Region VARCHAR(100),
    State_or_Province VARCHAR(100),
    City VARCHAR(100),
    Postal_Code VARCHAR(50),
    Order_Date VARCHAR(50),
    Ship_Date VARCHAR(50),
    Profit VARCHAR(50),
    Quantity_ordered_new VARCHAR(50),
    Sales VARCHAR(50),
    Order_ID VARCHAR(50),
    Status VARCHAR(50)
);




LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/SuperStoreUS-2015 1 (1) (1).csv'
INTO TABLE Orders_Raw
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    Customer_Name,
    Customer_ID,
    Row_ID,
    Order_Priority,
    Discount,
    Unit_Price,
    Shipping_Cost,
    Ship_Mode,
    Customer_Segment,
    Product_Category,
    Product_Sub_Category,
    Product_Container,
    Product_Name,
    Product_Base_Margin,
    Country,
    Region,
    State_or_Province,
    City,
    Postal_Code,
    Order_Date,
    Ship_Date,
    Profit,
    Quantity_ordered_new,
    Sales,
    Order_ID,
    @dummy1,
    @dummy2,
    @dummy3
);


DROP TABLE IF EXISTS Orders;

CREATE TABLE Orders AS
SELECT
    Customer_Name,

    NULLIF(Customer_ID, '') + 0 AS Customer_ID,

    NULLIF(Row_ID, '') + 0 AS Row_ID,

    NULLIF(Lenghth, '') + 0 AS Lenghth,

    NULLIF(TRIM(Order_Priority), '') AS Order_Priority,

    /* Discount: 7% → 7 */
    NULLIF(
        REPLACE(TRIM(Discount), '%', ''),
    '') + 0 AS Discount,

    /* Unit Price */
    NULLIF(
        REPLACE(
            REPLACE(TRIM(Unit_Price), '$', ''),
        ',', ''),
    '') + 0 AS Unit_Price,

    /* Shipping Cost */
    NULLIF(
        REPLACE(
            REPLACE(TRIM(Shipping_Cost), '$', ''),
        ',', ''),
    '') + 0 AS Shipping_Cost,

    Ship_Mode,
    Customer_Segment,
    Product_Category,
    Product_Sub_Category,
    Product_Container,
    Product_Name,

    /* Product Base Margin */
    NULLIF(
        REPLACE(TRIM(Product_Base_Margin), '%', ''),
    '') + 0 AS Product_Base_Margin,

    Country,
    Region,
    State_or_Province,
    City,

    NULLIF(Postal_Code, '') + 0 AS Postal_Code,

    /* Dates */
    STR_TO_DATE(TRIM(Order_Date), '%d-%m-%Y') AS Order_Date,

    STR_TO_DATE(TRIM(Ship_Date), '%d-%m-%Y') AS Ship_Date,

    /* Profit Handling */
    CASE
        WHEN Profit LIKE '%(%'
        THEN -(
            NULLIF(
                REPLACE(
                    REPLACE(
                        REPLACE(
                            REPLACE(
                                REPLACE(TRIM(Profit), '(', ''),
                            ')', ''),
                        '$', ''),
                    ',', ''),
                ' ', ''),
            '') + 0
        )

        ELSE
            NULLIF(
                REPLACE(
                    REPLACE(
                        REPLACE(TRIM(Profit), '$', ''),
                    ',', ''),
                ' ', ''),
            '') + 0
    END AS Profit,

    NULLIF(Quantity_ordered_new, '') + 0
    AS Quantity_ordered_new,

    /* Sales */
    NULLIF(
        REPLACE(
            REPLACE(
                REPLACE(TRIM(Sales), '$', ''),
            ',', ''),
        ' ', ''),
    '') + 0 AS Sales,

    NULLIF(Order_ID, '') + 0 AS Order_ID,

    Status

FROM Orders_Raw;



-- View First 10 Rows
SELECT * from Orders_RAW Limit 10;


-- Count Total Records
SELECT COUNT(*) FROM Orders_RAW;


-- Display All Records
select * from Orders_RAW;


--  Select Specific Columns
select Customer_Name,Product_Name,Sales,Profit
from Orders_RAW;


-- Filter by State
select * from Orders_RAW where state_or_province ='California';


-- Negative Profit Orders
select * from Orders_RAW where Profit like '(%';


-- Discount Based Filtering
select * from Orders_RAW where Discount > 0.20;


-- Sort Data
select * from Orders_RAW Order by Sales desc;


-- Top Selling Orders
select * from Orders_RAW Order by Sales desc Limit 10;


--  Unique Customer Segments
select distinct Customer_segment from Orders_RAW;



-- Sales Range Filtering
select * from Orders_RAW where Sales between 500 and 2000;


-- Customer Name Pattern
select * from Orders_RAW where Customer_Name like 'A%';


--  Total Sales
select sum(Sales) as Total_Sales from Orders_Raw;


-- Average Profit
select avg(profit) as Average_Profit From Orders_RAW;


-- Maximum Sales
select max(sales) As Maximum_Sales from Orders_RAW;


-- Minimum Profit
select min(sales) As Minimum_Sales from Orders_RAW;


-- Total Number of Orders
select count(*) as Total_Orders from Orders_RAW;


-- Sales by Region
SELECT Region,
       SUM(Sales) AS Total_Sales
FROM Orders_RAW
GROUP BY Region;


-- Profit by State
SELECT State_or_Province,
       SUM(Profit) AS Total_Profit
FROM Orders_RAW
GROUP BY State_or_Province;


-- Average Sales by Segment
select Customer_Segment,
       AVG(Sales) AS Average_Sales
FROM Orders_RAW
group by Customer_Segment;


--  Customer Count by Region
SELECT Region,
       COUNT(DISTINCT Customer_ID) AS Total_Customers
FROM Orders_RAW
GROUP BY Region;


--  Quantity Sold by Category
select Product_Category,
       SUM(Quantity_ordered_new) as Toatal_Quantity_Sold
FROM Orders_RAW
GROUP BY Product_Category;


-- High Sales Regions
SELECT Region,
       SUM(Sales) AS Total_Sales
FROM Orders_RAW
GROUP BY Region
HAVING SUM(Sales) > 50000;


-- High Profit Categories
SELECT Product_Category, 
       AVG(Profit) AS Average_Profit
FROM Orders_RAW
GROUP BY Product_Category
HAVING AVG(Profit) > 100;


-- Monthly Orders
SELECT MONTH(Order_Date) AS Month_Number,
       COUNT(*) AS Total_Orders
FROM Orders_RAW
GROUP BY MONTH(Order_Date)
ORDER BY Month_Number;

SELECT Order_Date
FROM Orders_RAW
LIMIT 10;

SELECT MONTH(STR_TO_DATE(Order_Date, '%d-%m-%Y')) AS Month_Number,
       COUNT(*) AS Total_Orders
FROM Orders_RAW
GROUP BY MONTH(STR_TO_DATE(Order_Date, '%d-%m-%Y'));



-- Monthly Orders
SELECT MONTH(STR_TO_DATE(Order_Date, '%d-%m-%Y')) AS Month_Number,
       COUNT(*) AS Total_Orders
FROM Orders_RAW
GROUP BY MONTH(STR_TO_DATE(Order_Date, '%d-%m-%Y'))
ORDER BY Month_Number;


-- Shipping Delay Analysis
SELECT Order_Date,
       Ship_Date,
       DATEDIFF(
           STR_TO_DATE(Ship_Date, '%d-%m-%Y'),
           STR_TO_DATE(Order_Date, '%d-%m-%Y')
       ) AS Days_Difference
FROM Orders_RAW;


-- Date Filtering
SELECT *
FROM Orders_RAW
WHERE STR_TO_DATE(Order_Date, '%d-%m-%Y') > '2015-06-01';


-- Returned Orders
