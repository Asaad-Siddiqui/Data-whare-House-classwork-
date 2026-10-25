CREATE DATABASE IF NOT EXISTS Chit8_Hospital;
USE Chit8_Hospital;

CREATE TABLE Dim_Time (
    time_id INT PRIMARY KEY,
    day INT, month INT, quarter INT, year INT
);

CREATE TABLE Dim_Service (
    service_id INT PRIMARY KEY,
    service_name VARCHAR(50),
    category VARCHAR(50)
);

CREATE TABLE Dim_Location (
    location_id INT PRIMARY KEY,
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE Fact_Visits (
    visit_id INT PRIMARY KEY,
    time_id INT,
    service_id INT,
    location_id INT,
    patients INT,
    revenue DECIMAL(10,2),
    FOREIGN KEY (time_id) REFERENCES Dim_Time(time_id),
    FOREIGN KEY (service_id) REFERENCES Dim_Service(service_id),
    FOREIGN KEY (location_id) REFERENCES Dim_Location(location_id)
);

INSERT INTO Dim_Time VALUES
(1,5,1,1,2024),(2,15,3,1,2024),
(3,10,5,2,2024),(4,20,8,3,2024),
(5,12,10,4,2024),(6,18,12,4,2024),
(7,8,2,1,2025),(8,22,4,2,2025),
(9,4,7,3,2025),(10,14,9,3,2025);

INSERT INTO Dim_Service VALUES
(1,'General Checkup','Outpatient'),
(2,'Blood Test','Diagnostics'),
(3,'MRI Scan','Diagnostics');

INSERT INTO Dim_Location VALUES
(1,'Mumbai','Maharashtra','India'),
(2,'Pune','Maharashtra','India'),
(3,'Delhi','Delhi','India');

INSERT INTO Fact_Visits VALUES
(1,1,1,1,20,10000),(2,2,2,2,15,7500),
(3,3,3,1,5,25000),(4,4,1,3,25,12500),
(5,5,2,2,18,9000),(6,6,3,3,4,20000),
(7,7,1,1,22,11000),(8,8,2,2,16,8000),
(9,9,3,3,6,30000),(10,10,1,1,30,15000);

-- 1. SLICE: Visits in Mumbai
SELECT l.city, SUM(f.patients) AS total_patients,
       SUM(f.revenue) AS total_revenue
FROM Fact_Visits f
JOIN Dim_Location l ON f.location_id = l.location_id
WHERE l.city = 'Mumbai'
GROUP BY l.city;
-- Business question: How many patients and how much revenue came from Mumbai?

-- 2. DICE: Two years and diagnostic services
SELECT t.year, s.category,
       SUM(f.patients) AS total_patients,
       SUM(f.revenue) AS total_revenue
FROM Fact_Visits f
JOIN Dim_Time t ON f.time_id = t.time_id
JOIN Dim_Service s ON f.service_id = s.service_id
WHERE t.year IN (2024, 2025)
  AND s.category = 'Diagnostics'
GROUP BY t.year, s.category;
-- Business question: How did diagnostic services perform in 2024 and 2025?

-- 3. ROLL-UP: City to state to country
SELECT l.country, l.state, l.city,
       SUM(f.patients) AS total_patients
FROM Fact_Visits f
JOIN Dim_Location l ON f.location_id = l.location_id
GROUP BY l.country, l.state, l.city WITH ROLLUP;
-- Business question: What is the patient count by city, state and country?
-- NULL values indicate higher-level subtotals.

-- 4. DRILL-DOWN: Country to state to city
SELECT l.country, l.state, l.city,
       SUM(f.revenue) AS total_revenue
FROM Fact_Visits f
JOIN Dim_Location l ON f.location_id = l.location_id
GROUP BY l.country, l.state, l.city
ORDER BY l.country, l.state, l.city;
-- Business question: Which cities contribute to each state's hospital revenue?

-- 5. PIVOT: Revenue by service category and year
SELECT s.category,
       SUM(CASE WHEN t.year = 2024 THEN f.revenue ELSE 0 END) AS Revenue_2024,
       SUM(CASE WHEN t.year = 2025 THEN f.revenue ELSE 0 END) AS Revenue_2025
FROM Fact_Visits f
JOIN Dim_Service s ON f.service_id = s.service_id
JOIN Dim_Time t ON f.time_id = t.time_id
GROUP BY s.category;
-- Business question: How did revenue by service category change between the two years?