-- Extracted from the supplied DWM Practical Exp 1 & 2 PDF
-- MySQL script: schema creation, sample data, SELECT checks, and JOIN query.

-- STAR  |  Chit3_Supermarket
CREATE DATABASE Chit3_Supermarket; USE Chit3_Supermarket;
-- Tables: dimensions first, fact last
CREATE TABLE Dim_Time(time_id INT PRIMARY KEY, day INT, month INT, quarter INT, year INT);
CREATE TABLE Dim_Product(product_id INT PRIMARY KEY, product_name VARCHAR(50), category VARCHAR(40),
  brand VARCHAR(40));
CREATE TABLE Dim_Store(store_id INT PRIMARY KEY, store_name VARCHAR(50), city VARCHAR(40), state VARCHAR(40));
CREATE TABLE Dim_Customer(customer_id INT PRIMARY KEY, customer_name VARCHAR(50), segment VARCHAR(30));
CREATE TABLE Dim_Promotion(promotion_id INT PRIMARY KEY, promo_name VARCHAR(50), discount_type VARCHAR(30));
CREATE TABLE Fact_StoreSales(sales_id INT PRIMARY KEY, time_id INT, product_id INT, store_id INT,
  customer_id INT, promotion_id INT, quantity_sold INT, sales_amount DECIMAL(10,2), discount DECIMAL(8,2),
  profit DECIMAL(10,2), FOREIGN KEY(time_id) REFERENCES Dim_Time(time_id),
  FOREIGN KEY(product_id) REFERENCES Dim_Product(product_id),
  FOREIGN KEY(store_id) REFERENCES Dim_Store(store_id),
  FOREIGN KEY(customer_id) REFERENCES Dim_Customer(customer_id),
  FOREIGN KEY(promotion_id) REFERENCES Dim_Promotion(promotion_id));
-- One row in each table
INSERT INTO Dim_Time VALUES (1,25,10,4,2026);
INSERT INTO Dim_Product VALUES (1,'Milk 1L','Dairy','FarmFresh');
INSERT INTO Dim_Store VALUES (1,'Central Market','Mumbai','Maharashtra');
INSERT INTO Dim_Customer VALUES (1,'Riya Mehta','Regular');
INSERT INTO Dim_Promotion VALUES (1,'Festival Offer','Percentage');
INSERT INTO Fact_StoreSales VALUES (1,1,1,1,1,1,20,1200.00,100.00,250.00);
-- Show every table
SELECT * FROM Dim_Time; SELECT * FROM Dim_Product; SELECT * FROM Dim_Store; SELECT * FROM Dim_Customer;
SELECT * FROM Dim_Promotion; SELECT * FROM Fact_StoreSales;
-- Join: fact + all dimensions
SELECT f.sales_id, t.day, t.month, t.quarter, t.year, p.product_name, p.category, p.brand, s.store_name,
  s.city, s.state, c.customer_name, c.segment, pr.promo_name, pr.discount_type, f.quantity_sold,
  f.sales_amount, f.discount, f.profit
FROM Fact_StoreSales f
JOIN Dim_Time t ON f.time_id=t.time_id
JOIN Dim_Product p ON f.product_id=p.product_id
JOIN Dim_Store s ON f.store_id=s.store_id
JOIN Dim_Customer c ON f.customer_id=c.customer_id
JOIN Dim_Promotion pr ON f.promotion_id=pr.promotion_id;
