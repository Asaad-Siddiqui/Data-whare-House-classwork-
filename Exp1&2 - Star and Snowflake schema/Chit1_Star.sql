-- Extracted from the supplied DWM Practical Exp 1 & 2 PDF
-- MySQL script: schema creation, sample data, SELECT checks, and JOIN query.

-- STAR  |  Chit1_Hotel
CREATE DATABASE Chit1_Hotel; USE Chit1_Hotel;
-- Tables: dimensions first, fact last
CREATE TABLE Dim_Time(time_id INT PRIMARY KEY, day INT, month INT, quarter INT, year INT);
CREATE TABLE Dim_Hotel(hotel_id INT PRIMARY KEY, hotel_name VARCHAR(60), city VARCHAR(40), state VARCHAR(40));
CREATE TABLE Dim_Room(room_id INT PRIMARY KEY, room_number VARCHAR(10), room_type VARCHAR(30), floor_no INT);
CREATE TABLE Dim_Booking(booking_id INT PRIMARY KEY, guest_name VARCHAR(60), booking_channel VARCHAR(30));
CREATE TABLE Fact_Occupancy(occupancy_id INT PRIMARY KEY, time_id INT, hotel_id INT, room_id INT,
  booking_id INT, rooms_occupied INT, nights_stayed INT, room_revenue DECIMAL(10,2),
  occupancy_pct DECIMAL(5,2), FOREIGN KEY(time_id) REFERENCES Dim_Time(time_id),
  FOREIGN KEY(hotel_id) REFERENCES Dim_Hotel(hotel_id), FOREIGN KEY(room_id) REFERENCES Dim_Room(room_id),
  FOREIGN KEY(booking_id) REFERENCES Dim_Booking(booking_id));
-- One row in each table
INSERT INTO Dim_Time VALUES (1,25,10,4,2026);
INSERT INTO Dim_Hotel VALUES (1,'Grand Hotel','Mumbai','Maharashtra');
INSERT INTO Dim_Room VALUES (1,'305','Deluxe',3);
INSERT INTO Dim_Booking VALUES (1,'Aarav Shah','Website');
INSERT INTO Fact_Occupancy VALUES (1,1,1,1,1,1,2,8000.00,75.00);
-- Show every table
SELECT * FROM Dim_Time; SELECT * FROM Dim_Hotel; SELECT * FROM Dim_Room; SELECT * FROM Dim_Booking; SELECT *
FROM Fact_Occupancy;
-- Join: fact + all dimensions
SELECT f.occupancy_id, t.day, t.month, t.quarter, t.year, h.hotel_name, h.city, r.room_number, r.room_type,
  b.guest_name, b.booking_channel, f.rooms_occupied, f.nights_stayed, f.room_revenue, f.occupancy_pct
FROM Fact_Occupancy f
JOIN Dim_Time t ON f.time_id=t.time_id
JOIN Dim_Hotel h ON f.hotel_id=h.hotel_id
JOIN Dim_Room r ON f.room_id=r.room_id
JOIN Dim_Booking b ON f.booking_id=b.booking_id;
