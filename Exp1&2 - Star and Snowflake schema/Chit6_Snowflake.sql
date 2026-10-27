-- Extracted from the supplied DWM Practical Exp 1 & 2 PDF
-- MySQL script: schema creation, sample data, SELECT checks, and JOIN query.

-- SNOWFLAKE  |  Chit6_College_Snowflake
CREATE DATABASE Chit6_College_Snowflake; USE Chit6_College_Snowflake;
-- Tables: dimensions first, fact last
CREATE TABLE Dim_Time(time_id INT PRIMARY KEY, academic_year VARCHAR(12), year INT);
CREATE TABLE Dim_Category(category_id INT PRIMARY KEY, category_name VARCHAR(30));
CREATE TABLE Dim_State(state_id INT PRIMARY KEY, state VARCHAR(40));
CREATE TABLE Dim_City(city_id INT PRIMARY KEY, city VARCHAR(40), state_id INT,
  FOREIGN KEY(state_id) REFERENCES Dim_State(state_id));
CREATE TABLE Dim_Student(student_id INT PRIMARY KEY, student_name VARCHAR(50), category_id INT, city_id INT,
  FOREIGN KEY(category_id) REFERENCES Dim_Category(category_id),
  FOREIGN KEY(city_id) REFERENCES Dim_City(city_id));
CREATE TABLE Dim_Department(department_id INT PRIMARY KEY, department_name VARCHAR(50));
CREATE TABLE Dim_Course(course_id INT PRIMARY KEY, course_name VARCHAR(50), branch VARCHAR(40),
  department_id INT, FOREIGN KEY(department_id) REFERENCES Dim_Department(department_id));
CREATE TABLE Dim_Faculty(faculty_id INT PRIMARY KEY, faculty_name VARCHAR(50), designation VARCHAR(40));
CREATE TABLE Fact_Admissions(admission_id INT PRIMARY KEY, time_id INT, student_id INT, course_id INT,
  faculty_id INT, category_id INT, applications INT, seats_filled INT, fees_collected DECIMAL(10,2),
  average_marks DECIMAL(5,2), pass_percentage DECIMAL(5,2),
  FOREIGN KEY(time_id) REFERENCES Dim_Time(time_id),
  FOREIGN KEY(student_id) REFERENCES Dim_Student(student_id),
  FOREIGN KEY(course_id) REFERENCES Dim_Course(course_id),
  FOREIGN KEY(faculty_id) REFERENCES Dim_Faculty(faculty_id),
  FOREIGN KEY(category_id) REFERENCES Dim_Category(category_id));
-- One row in each table
INSERT INTO Dim_Time VALUES (1,'2026-27',2026);
INSERT INTO Dim_Category VALUES (1,'Open');
INSERT INTO Dim_State VALUES (1,'Maharashtra');
INSERT INTO Dim_City VALUES (1,'Mumbai',1);
INSERT INTO Dim_Student VALUES (1,'Ishaan Desai',1,1);
INSERT INTO Dim_Department VALUES (1,'Engineering');
INSERT INTO Dim_Course VALUES (1,'Computer Engineering','Computer',1);
INSERT INTO Dim_Faculty VALUES (1,'Prof. Meera Shah','Assistant Professor');
INSERT INTO Fact_Admissions VALUES (1,1,1,1,1,1,100,60,600000.00,78.50,85.00);
-- Show every table
SELECT * FROM Dim_Time; SELECT * FROM Dim_Category; SELECT * FROM Dim_State; SELECT * FROM Dim_City; SELECT
* FROM Dim_Student; SELECT * FROM Dim_Department; SELECT * FROM Dim_Course; SELECT * FROM Dim_Faculty;
SELECT * FROM Fact_Admissions;
-- Join: fact + all dimensions
SELECT f.admission_id, t.academic_year, s.student_name, cat.category_name, ci.city, st.state, c.course_name,
  c.branch, dep.department_name, fa.faculty_name, fa.designation, f.applications, f.seats_filled,
  f.fees_collected, f.average_marks, f.pass_percentage
FROM Fact_Admissions f
JOIN Dim_Time t ON f.time_id=t.time_id
JOIN Dim_Student s ON f.student_id=s.student_id
JOIN Dim_Category cat ON s.category_id=cat.category_id
JOIN Dim_City ci ON s.city_id=ci.city_id
JOIN Dim_State st ON ci.state_id=st.state_id
JOIN Dim_Course c ON f.course_id=c.course_id
JOIN Dim_Department dep ON c.department_id=dep.department_id
JOIN Dim_Faculty fa ON f.faculty_id=fa.faculty_id;
