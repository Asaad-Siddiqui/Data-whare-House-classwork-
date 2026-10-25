CREATE DATABASE IF NOT EXISTS Chit10_Banking;
USE Chit10_Banking;

CREATE TABLE Dim_Time (
    time_id INT PRIMARY KEY,
    day INT, month INT, quarter INT, year INT
);

CREATE TABLE Dim_Customer (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    segment VARCHAR(30)
);

CREATE TABLE Dim_Location (
    location_id INT PRIMARY KEY,
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE Dim_Product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(50)
);

CREATE TABLE Fact_Transactions (
    transaction_id INT PRIMARY KEY,
    time_id INT,
    customer_id INT,
    location_id INT,
    product_id INT,
    transaction_count INT,
    amount DECIMAL(12,2),
    FOREIGN KEY (time_id) REFERENCES Dim_Time(time_id),
    FOREIGN KEY (customer_id) REFERENCES Dim_Customer(customer_id),
    FOREIGN KEY (location_id) REFERENCES Dim_Location(location_id),
    FOREIGN KEY (product_id) REFERENCES Dim_Product(product_id)
);

INSERT INTO Dim_Time VALUES
(1,5,1,1,2024),(2,10,1,1,2024),
(3,15,2,1,2024),(4,20,2,1,2024),
(5,5,3,1,2024),(6,10,3,1,2024),
(7,15,1,1,2025),(8,20,1,1,2025),
(9,5,2,1,2025),(10,10,2,1,2025);

INSERT INTO Dim_Customer VALUES
(1,'Amit','Personal'),
(2,'Sara','Business'),
(3,'John','Personal');

INSERT INTO Dim_Location VALUES
(1,'Mumbai','Maharashtra','India'),
(2,'Pune','Maharashtra','India'),
(3,'Delhi','Delhi','India');

INSERT INTO Dim_Product VALUES
(1,'Savings Account','Deposit'),
(2,'Personal Loan','Loan'),
(3,'Credit Card','Credit');

INSERT INTO Fact_Transactions VALUES
(1,1,1,1,1,1,5000),(2,2,2,2,2,1,50000),
(3,3,1,1,3,2,12000),(4,4,3,3,1,1,8000),
(5,5,2,2,2,1,75000),(6,6,1,1,3,1,15000),
(7,7,3,3,1,1,10000),(8,8,2,2,2,1,60000),
(9,9,1,1,3,2,20000),(10,10,3,3,1,1,9000);

-- 1. SLICE: Transactions by Personal customers
SELECT c.segment, SUM(f.transaction_count) AS total_transactions,
       SUM(f.amount) AS total_amount
FROM Fact_Transactions f
JOIN Dim_Customer c ON f.customer_id = c.customer_id
WHERE c.segment = 'Personal'
GROUP BY c.segment;
-- Business question: What is the total transaction count and amount for Personal customers?

-- 2. DICE: Selected locations and products, amount above 10,000
SELECT l.city, p.product_name,
       SUM(f.amount) AS total_amount
FROM Fact_Transactions f
JOIN Dim_Location l ON f.location_id = l.location_id
JOIN Dim_Product p ON f.product_id = p.product_id
WHERE l.city IN ('Mumbai', 'Pune')
  AND p.category IN ('Loan', 'Credit')
GROUP BY l.city, p.product_name
HAVING SUM(f.amount) > 10000;
-- Business question: Which loan or credit products exceed 10,000 in total amount in Mumbai or Pune?

-- 3. ROLL-UP: Day to month to year
SELECT t.year, t.month, t.day,
       SUM(f.amount) AS total_amount
FROM Fact_Transactions f
JOIN Dim_Time t ON f.time_id = t.time_id
GROUP BY t.year, t.month, t.day WITH ROLLUP;
-- Business question: What are the banking transaction totals by day, month and year?
-- NULL values indicate month and year subtotals.

-- 4. DRILL-DOWN: Year to month to day
SELECT t.year, t.month, t.day,
       SUM(f.amount) AS total_amount
FROM Fact_Transactions f
JOIN Dim_Time t ON f.time_id = t.time_id
GROUP BY t.year, t.month, t.day
ORDER BY t.year, t.month, t.day;
-- Business question: Which months and days contribute to yearly transaction totals?

-- 5. PIVOT: Transaction amount by product and year
SELECT p.product_name,
       SUM(CASE WHEN t.year = 2024 THEN f.amount ELSE 0 END) AS Amount_2024,
       SUM(CASE WHEN t.year = 2025 THEN f.amount ELSE 0 END) AS Amount_2025
FROM Fact_Transactions f
JOIN Dim_Product p ON f.product_id = p.product_id
JOIN Dim_Time t ON f.time_id = t.time_id
GROUP BY p.product_name;
-- Business question: How did transaction amounts for each banking product compare between 2024 and 2025?