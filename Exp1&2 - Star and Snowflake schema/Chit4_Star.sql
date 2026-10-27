-- Extracted from the supplied DWM Practical Exp 1 & 2 PDF
-- MySQL script: schema creation, sample data, SELECT checks, and JOIN query.

-- STAR  |  Chit4_Hospital
CREATE DATABASE Chit4_Hospital; USE Chit4_Hospital;
-- Tables: dimensions first, fact last
CREATE TABLE Dim_Time(time_id INT PRIMARY KEY, day INT, month INT, quarter INT, year INT);
CREATE TABLE Dim_Patient(patient_id INT PRIMARY KEY, patient_name VARCHAR(50), area VARCHAR(40),
  city VARCHAR(40));
CREATE TABLE Dim_Department(department_id INT PRIMARY KEY, department_name VARCHAR(50));
CREATE TABLE Dim_Doctor(doctor_id INT PRIMARY KEY, doctor_name VARCHAR(50), specialization VARCHAR(50),
  department_id INT, FOREIGN KEY(department_id) REFERENCES Dim_Department(department_id));
CREATE TABLE Dim_Diagnosis(diagnosis_id INT PRIMARY KEY, diagnosis_name VARCHAR(50), category VARCHAR(40));
CREATE TABLE Fact_Admissions(admission_id INT PRIMARY KEY, time_id INT, patient_id INT, doctor_id INT,
  department_id INT, diagnosis_id INT, admissions INT, stay_days INT, treatment_cost DECIMAL(10,2),
  bill_amount DECIMAL(10,2), FOREIGN KEY(time_id) REFERENCES Dim_Time(time_id),
  FOREIGN KEY(patient_id) REFERENCES Dim_Patient(patient_id),
  FOREIGN KEY(doctor_id) REFERENCES Dim_Doctor(doctor_id),
  FOREIGN KEY(department_id) REFERENCES Dim_Department(department_id),
  FOREIGN KEY(diagnosis_id) REFERENCES Dim_Diagnosis(diagnosis_id));
-- One row in each table
INSERT INTO Dim_Time VALUES (1,25,10,4,2026);
INSERT INTO Dim_Patient VALUES (1,'Mira Joshi','Andheri','Mumbai');
INSERT INTO Dim_Department VALUES (1,'Cardiology');
INSERT INTO Dim_Doctor VALUES (1,'Dr. Karan Rao','Cardiologist',1);
INSERT INTO Dim_Diagnosis VALUES (1,'Hypertension','Chronic');
INSERT INTO Fact_Admissions VALUES (1,1,1,1,1,1,1,3,12000.00,15000.00);
-- Show every table
SELECT * FROM Dim_Time; SELECT * FROM Dim_Patient; SELECT * FROM Dim_Department; SELECT * FROM Dim_Doctor;
SELECT * FROM Dim_Diagnosis; SELECT * FROM Fact_Admissions;
-- Join: fact + all dimensions
SELECT f.admission_id, t.day, t.month, t.quarter, t.year, p.patient_name, p.area, p.city, d.doctor_name,
  d.specialization, dep.department_name, dx.diagnosis_name, dx.category, f.admissions, f.stay_days,
  f.treatment_cost, f.bill_amount
FROM Fact_Admissions f
JOIN Dim_Time t ON f.time_id=t.time_id
JOIN Dim_Patient p ON f.patient_id=p.patient_id
JOIN Dim_Doctor d ON f.doctor_id=d.doctor_id
JOIN Dim_Department dep ON f.department_id=dep.department_id
JOIN Dim_Diagnosis dx ON f.diagnosis_id=dx.diagnosis_id;
