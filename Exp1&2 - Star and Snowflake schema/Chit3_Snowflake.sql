-- Extracted from the supplied DWM Practical Exp 1 & 2 PDF
-- MySQL script: schema creation, sample data, SELECT checks, and JOIN query.

-- SNOWFLAKE  |  Chit3_Supermarket_Snowflake
CREATE DATABASE Chit3_Supermarket_Snowflake; USE Chit3_Supermarket_Snowflake;
-- Tables: dimensions first, fact last
CREATE TABLE Dim_Time(time_id INT PRIMARY KEY, day INT, month INT, quarter INT, year INT);
CREATE TABLE Dim_Category(category_id INT PRIMARY KEY, category_name VARCHAR(40));
CREATE TABLE Dim_Brand(brand_id INT PRIMARY KEY, brand_name VARCHAR(40));
CREATE TABLE Dim_Product(product_id INT PRIMARY KEY, product_name VARCHAR(50), category_id INT, brand_id INT,
  FOREIGN KEY(category_id) REFERENCES Dim_Category(category_id),
  FOREIGN KEY(brand_id) REFERENCES Dim_Brand(brand_id));
CREATE TABLE Dim_State(state_id INT PRIMARY KEY, state VARCHAR(40));
CREATE TABLE Dim_City(city_id INT PRIMARY KEY, city VARCHAR(40), state_id INT,
  FOREIGN KEY(state_id) REFERENCES Dim_State(state_id));
CREATE TABLE Dim_Store(store_id INT PRIMARY KEY, store_name VARCHAR(50), city_id INT,
  FOREIGN KEY(city_id) REFERENCES Dim_City(city_id));
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
INSERT INTO Dim_Category VALUES (1,'Dairy');
INSERT INTO Dim_Brand VALUES (1,'FarmFresh');
INSERT INTO Dim_Product VALUES (1,'Milk 1L',1,1);
INSERT INTO Dim_State VALUES (1,'Maharashtra');
INSERT INTO Dim_City VALUES (1,'Mumbai',1);
INSERT INTO Dim_Store VALUES (1,'Central Market',1);
INSERT INTO Dim_Customer VALUES (1,'Riya Mehta','Regular');
INSERT INTO Dim_Promotion VALUES (1,'Festival Offer','Percentage');
INSERT INTO Fact_StoreSales VALUES (1,1,1,1,1,1,20,1200.00,100.00,250.00);
-- Show every table
SELECT * FROM Dim_Time; SELECT * FROM Dim_Category; SELECT * FROM Dim_Brand; SELECT * FROM Dim_Product;
SELECT * FROM Dim_State; SELECT * FROM Dim_City; SELECT * FROM Dim_Store; SELECT * FROM Dim_Customer; SELECT
* FROM Dim_Promotion; SELECT * FROM Fact_StoreSales;
-- Join: fact + all dimensions
SELECT f.sales_id, t.day, t.month, t.quarter, t.year, p.product_name, cat.category_name, b.brand_name,
  st.store_name, ci.city, sta.state, c.customer_name, c.segment, pr.promo_name, f.quantity_sold,
  f.sales_amount, f.discount, f.profit
FROM Fact_StoreSales f
JOIN Dim_Time t ON f.time_id=t.time_id
JOIN Dim_Product p ON f.product_id=p.product_id
JOIN Dim_Category cat ON p.category_id=cat.category_id
JOIN Dim_Brand b ON p.brand_id=b.brand_id
JOIN Dim_Store st ON f.store_id=st.store_id
JOIN Dim_City ci ON st.city_id=ci.city_id
JOIN Dim_State sta ON ci.state_id=sta.state_id
JOIN Dim_Customer c ON f.customer_id=c.customer_id
JOIN Dim_Promotion pr ON f.promotion_id=pr.promotion_id;
