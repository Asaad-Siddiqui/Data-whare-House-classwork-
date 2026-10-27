-- Extracted from the supplied DWM Practical Exp 1 & 2 PDF
-- MySQL script: schema creation, sample data, SELECT checks, and JOIN query.

-- STAR  |  Chit2_Furniture
CREATE DATABASE Chit2_Furniture; USE Chit2_Furniture;
-- Tables: dimensions first, fact last
CREATE TABLE Dim_Time(time_id INT PRIMARY KEY, day INT, month INT, quarter INT, year INT);
CREATE TABLE Dim_Product(product_id INT PRIMARY KEY, product_name VARCHAR(50), category VARCHAR(40),
  supplier VARCHAR(50));
CREATE TABLE Dim_Retailer(retailer_id INT PRIMARY KEY, retailer_name VARCHAR(50), segment VARCHAR(30));
CREATE TABLE Dim_Location(location_id INT PRIMARY KEY, city VARCHAR(40), state VARCHAR(40),
  region VARCHAR(40));
CREATE TABLE Dim_Salesperson(salesperson_id INT PRIMARY KEY, salesperson_name VARCHAR(50),
  territory VARCHAR(40));
CREATE TABLE Fact_Sales(sale_id INT PRIMARY KEY, time_id INT, product_id INT, retailer_id INT,
  location_id INT, salesperson_id INT, units_sold INT, sales_amount DECIMAL(10,2), discount DECIMAL(8,2),
  profit DECIMAL(10,2), FOREIGN KEY(time_id) REFERENCES Dim_Time(time_id),
  FOREIGN KEY(product_id) REFERENCES Dim_Product(product_id),
  FOREIGN KEY(retailer_id) REFERENCES Dim_Retailer(retailer_id),
  FOREIGN KEY(location_id) REFERENCES Dim_Location(location_id),
  FOREIGN KEY(salesperson_id) REFERENCES Dim_Salesperson(salesperson_id));
-- One row in each table
INSERT INTO Dim_Time VALUES (1,25,10,4,2026);
INSERT INTO Dim_Product VALUES (1,'Oak Dining Table','Tables','WoodWorks Ltd');
INSERT INTO Dim_Retailer VALUES (1,'City Furniture Mart','Retail');
INSERT INTO Dim_Location VALUES (1,'Mumbai','Maharashtra','West');
INSERT INTO Dim_Salesperson VALUES (1,'Neha Patil','West Zone');
INSERT INTO Fact_Sales VALUES (1,1,1,1,1,1,10,150000.00,5000.00,25000.00);
-- Show every table
SELECT * FROM Dim_Time; SELECT * FROM Dim_Product; SELECT * FROM Dim_Retailer; SELECT * FROM Dim_Location;
SELECT * FROM Dim_Salesperson; SELECT * FROM Fact_Sales;
-- Join: fact + all dimensions
SELECT f.sale_id, t.day, t.month, t.quarter, t.year, p.product_name, p.category, p.supplier, r.retailer_name,
  r.segment, l.city, l.state, l.region, s.salesperson_name, s.territory, f.units_sold, f.sales_amount,
  f.discount, f.profit
FROM Fact_Sales f
JOIN Dim_Time t ON f.time_id=t.time_id
JOIN Dim_Product p ON f.product_id=p.product_id
JOIN Dim_Retailer r ON f.retailer_id=r.retailer_id
JOIN Dim_Location l ON f.location_id=l.location_id
JOIN Dim_Salesperson s ON f.salesperson_id=s.salesperson_id;
