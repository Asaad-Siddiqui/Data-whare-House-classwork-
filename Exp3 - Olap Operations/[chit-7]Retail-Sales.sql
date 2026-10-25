CREATE DATABASE IF NOT EXISTS Chit7_Retail;
USE Chit7_Retail;

CREATE TABLE Dim_Time (
    time_id INT PRIMARY KEY,
    day INT, month INT, quarter INT, year INT
);

CREATE TABLE Dim_Product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(50),
    department VARCHAR(50)
);

CREATE TABLE Dim_Location (
    location_id INT PRIMARY KEY,
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE Fact_Sales (
    sale_id INT PRIMARY KEY,
    time_id INT,
    product_id INT,
    location_id INT,
    quantity INT,
    amount DECIMAL(10,2),
    FOREIGN KEY (time_id) REFERENCES Dim_Time(time_id),
    FOREIGN KEY (product_id) REFERENCES Dim_Product(product_id),
    FOREIGN KEY (location_id) REFERENCES Dim_Location(location_id)
);

INSERT INTO Dim_Time VALUES
(1,5,1,1,2024),(2,15,2,1,2024),
(3,10,4,2,2024),(4,20,5,2,2024),
(5,12,7,3,2024),(6,18,8,3,2024),
(7,8,10,4,2024),(8,22,11,4,2024),
(9,4,1,1,2025),(10,14,2,1,2025);

INSERT INTO Dim_Product VALUES
(1,'Laptop','Electronics','Technology'),
(2,'Phone','Electronics','Technology'),
(3,'Chair','Furniture','Home');

INSERT INTO Dim_Location VALUES
(1,'Mumbai','Maharashtra','India'),
(2,'Pune','Maharashtra','India'),
(3,'Delhi','Delhi','India');

INSERT INTO Fact_Sales VALUES
(1,1,1,1,2,100000),(2,2,2,2,3,90000),
(3,3,1,1,1,50000),(4,4,3,3,4,20000),
(5,5,2,1,2,60000),(6,6,3,2,3,15000),
(7,7,1,3,1,55000),(8,8,2,1,2,65000),
(9,9,1,2,2,110000),(10,10,3,1,5,25000);

-- 1. SLICE: Sales in 2024
SELECT t.year, SUM(f.amount) AS total_sales,
       SUM(f.quantity) AS total_quantity
FROM Fact_Sales f
JOIN Dim_Time t ON f.time_id = t.time_id
WHERE t.year = 2024
GROUP BY t.year;
-- Business question: What were the total sales and quantity sold in 2024?

-- 2. DICE: Selected products and locations
SELECT p.product_name, l.city,
       SUM(f.amount) AS total_sales
FROM Fact_Sales f
JOIN Dim_Product p ON f.product_id = p.product_id
JOIN Dim_Location l ON f.location_id = l.location_id
WHERE p.category = 'Electronics'
  AND l.city IN ('Mumbai', 'Pune')
GROUP BY p.product_name, l.city;
-- Business question: How did electronics sales compare in Mumbai and Pune?

-- 3. ROLL-UP: Month to quarter to year
SELECT t.year, t.quarter, t.month,
       SUM(f.amount) AS total_sales
FROM Fact_Sales f
JOIN Dim_Time t ON f.time_id = t.time_id
GROUP BY t.year, t.quarter, t.month WITH ROLLUP;
-- Business question: What are sales totals by month, quarter and year?
-- NULL values in month/quarter indicate higher-level subtotals.

-- 4. DRILL-DOWN: Year to quarter to month
SELECT t.year, t.quarter, t.month,
       SUM(f.amount) AS total_sales
FROM Fact_Sales f
JOIN Dim_Time t ON f.time_id = t.time_id
GROUP BY t.year, t.quarter, t.month
ORDER BY t.year, t.quarter, t.month;
-- Business question: Which months and quarters contributed to yearly sales?

-- 5. PIVOT: Compare sales by product category and year
SELECT p.category,
       SUM(CASE WHEN t.year = 2024 THEN f.amount ELSE 0 END) AS Sales_2024,
       SUM(CASE WHEN t.year = 2025 THEN f.amount ELSE 0 END) AS Sales_2025
FROM Fact_Sales f
JOIN Dim_Product p ON f.product_id = p.product_id
JOIN Dim_Time t ON f.time_id = t.time_id
GROUP BY p.category;
-- Business question: How did each product category perform in 2024 versus 2025?