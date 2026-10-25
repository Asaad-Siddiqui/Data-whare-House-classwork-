CREATE DATABASE IF NOT EXISTS Chit9_Library;
USE Chit9_Library;

CREATE TABLE Dim_Time (
    time_id INT PRIMARY KEY,
    day INT, month INT, quarter INT, year INT
);

CREATE TABLE Dim_Book (
    book_id INT PRIMARY KEY,
    book_title VARCHAR(60),
    category VARCHAR(50),
    department VARCHAR(50)
);

CREATE TABLE Dim_Customer (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    segment VARCHAR(30)
);

CREATE TABLE Fact_Borrowing (
    borrow_id INT PRIMARY KEY,
    time_id INT,
    book_id INT,
    customer_id INT,
    copies INT,
    fine_amount DECIMAL(8,2),
    FOREIGN KEY (time_id) REFERENCES Dim_Time(time_id),
    FOREIGN KEY (book_id) REFERENCES Dim_Book(book_id),
    FOREIGN KEY (customer_id) REFERENCES Dim_Customer(customer_id)
);

INSERT INTO Dim_Time VALUES
(1,5,1,1,2024),(2,15,2,1,2024),
(3,10,4,2,2024),(4,20,5,2,2024),
(5,12,7,3,2024),(6,18,8,3,2024),
(7,8,10,4,2024),(8,22,11,4,2024),
(9,4,1,1,2025),(10,14,4,2,2025);

INSERT INTO Dim_Book VALUES
(1,'Novel A','Fiction','Arts'),
(2,'Novel B','Fiction','Arts'),
(3,'SQL Basics','Technology','Science'),
(4,'Physics Guide','Science','Science');

INSERT INTO Dim_Customer VALUES
(1,'Amit','Student'),
(2,'Sara','Faculty'),
(3,'Rahul','Student'),
(4,'Neha','Researcher');

INSERT INTO Fact_Borrowing VALUES
(1,1,1,1,2,0),(2,2,2,2,1,10),
(3,3,3,1,2,0),(4,4,4,3,1,5),
(5,5,1,4,1,0),(6,6,3,2,2,0),
(7,7,2,3,3,15),(8,8,4,1,1,0),
(9,9,1,2,2,0),(10,10,3,4,1,5);

-- 1. SLICE: Borrowings for Fiction books
SELECT b.category, SUM(f.copies) AS total_copies,
       SUM(f.fine_amount) AS total_fines
FROM Fact_Borrowing f
JOIN Dim_Book b ON f.book_id = b.book_id
WHERE b.category = 'Fiction'
GROUP BY b.category;
-- Business question: How many fiction books were borrowed and what fines were collected?

-- 2. DICE: Student borrowings in two quarters
SELECT c.segment, t.year, t.quarter,
       SUM(f.copies) AS total_copies
FROM Fact_Borrowing f
JOIN Dim_Customer c ON f.customer_id = c.customer_id
JOIN Dim_Time t ON f.time_id = t.time_id
WHERE c.segment = 'Student'
  AND ((t.year = 2024 AND t.quarter IN (1, 2)))
GROUP BY c.segment, t.year, t.quarter;
-- Business question: How many copies did students borrow in Q1 and Q2 of 2024?

-- 3. ROLL-UP: Book to category to department
SELECT b.department, b.category, b.book_title,
       SUM(f.copies) AS total_copies
FROM Fact_Borrowing f
JOIN Dim_Book b ON f.book_id = b.book_id
GROUP BY b.department, b.category, b.book_title WITH ROLLUP;
-- Business question: Which departments and categories have the most book borrowings?
-- NULL values indicate category or department subtotals.

-- 4. DRILL-DOWN: Department to category to book
SELECT b.department, b.category, b.book_title,
       SUM(f.copies) AS total_copies
FROM Fact_Borrowing f
JOIN Dim_Book b ON f.book_id = b.book_id
GROUP BY b.department, b.category, b.book_title
ORDER BY b.department, b.category, b.book_title;
-- Business question: Which individual books contribute to borrowing totals in each department?

-- 5. PIVOT: Borrowed copies by customer segment
SELECT c.segment,
       SUM(CASE WHEN t.quarter = 1 THEN f.copies ELSE 0 END) AS Q1_Copies,
       SUM(CASE WHEN t.quarter = 2 THEN f.copies ELSE 0 END) AS Q2_Copies
FROM Fact_Borrowing f
JOIN Dim_Customer c ON f.customer_id = c.customer_id
JOIN Dim_Time t ON f.time_id = t.time_id
WHERE t.year = 2024
GROUP BY c.segment;
-- Business question: How do borrowing patterns by customer segment compare between Q1 and Q2 of 2024?