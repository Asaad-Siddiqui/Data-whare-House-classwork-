-- Extracted from the supplied DWM Practical Exp 1 & 2 PDF
-- MySQL script: schema creation, sample data, SELECT checks, and JOIN query.

-- SNOWFLAKE  |  Chit1_Hotel_Snowflake
CREATE DATABASE Chit1_Hotel_Snowflake; USE Chit1_Hotel_Snowflake;
-- Tables: dimensions first, fact last
CREATE TABLE Dim_Time(time_id INT PRIMARY KEY, day INT, month INT, quarter INT, year INT);
CREATE TABLE Dim_State(state_id INT PRIMARY KEY, state VARCHAR(40));
CREATE TABLE Dim_City(city_id INT PRIMARY KEY, city VARCHAR(40), state_id INT,
  FOREIGN KEY(state_id) REFERENCES Dim_State(state_id));
CREATE TABLE Dim_Hotel(hotel_id INT PRIMARY KEY, hotel_name VARCHAR(60), city_id INT,
  FOREIGN KEY(city_id) REFERENCES Dim_City(city_id));
CREATE TABLE Dim_RoomType(room_type_id INT PRIMARY KEY, room_type VARCHAR(30));
CREATE TABLE Dim_Floor(floor_id INT PRIMARY KEY, floor_no INT);
CREATE TABLE Dim_Room(room_id INT PRIMARY KEY, room_number VARCHAR(10), room_type_id INT, floor_id INT,
  FOREIGN KEY(room_type_id) REFERENCES Dim_RoomType(room_type_id),
  FOREIGN KEY(floor_id) REFERENCES Dim_Floor(floor_id));
CREATE TABLE Dim_Booking(booking_id INT PRIMARY KEY, guest_name VARCHAR(60), booking_channel VARCHAR(30));
CREATE TABLE Fact_Occupancy(occupancy_id INT PRIMARY KEY, time_id INT, hotel_id INT, room_id INT,
  booking_id INT, rooms_occupied INT, nights_stayed INT, room_revenue DECIMAL(10,2),
  occupancy_pct DECIMAL(5,2), FOREIGN KEY(time_id) REFERENCES Dim_Time(time_id),
  FOREIGN KEY(hotel_id) REFERENCES Dim_Hotel(hotel_id), FOREIGN KEY(room_id) REFERENCES Dim_Room(room_id),
  FOREIGN KEY(booking_id) REFERENCES Dim_Booking(booking_id));
-- One row in each table
INSERT INTO Dim_Time VALUES (1,25,10,4,2026);
INSERT INTO Dim_State VALUES (1,'Maharashtra');
INSERT INTO Dim_City VALUES (1,'Mumbai',1);
INSERT INTO Dim_Hotel VALUES (1,'Grand Hotel',1);
INSERT INTO Dim_RoomType VALUES (1,'Deluxe');
INSERT INTO Dim_Floor VALUES (1,3);
INSERT INTO Dim_Room VALUES (1,'305',1,1);
INSERT INTO Dim_Booking VALUES (1,'Aarav Shah','Website');
INSERT INTO Fact_Occupancy VALUES (1,1,1,1,1,1,2,8000.00,75.00);
-- Show every table
SELECT * FROM Dim_Time; SELECT * FROM Dim_State; SELECT * FROM Dim_City; SELECT * FROM Dim_Hotel; SELECT *
FROM Dim_RoomType; SELECT * FROM Dim_Floor; SELECT * FROM Dim_Room; SELECT * FROM Dim_Booking; SELECT * FROM
Fact_Occupancy;
-- Join: fact + all dimensions
SELECT f.occupancy_id, t.day, t.month, t.quarter, t.year, h.hotel_name, c.city, s.state, r.room_number,
  rt.room_type, fl.floor_no, b.guest_name, b.booking_channel, f.rooms_occupied, f.nights_stayed,
  f.room_revenue, f.occupancy_pct
FROM Fact_Occupancy f
JOIN Dim_Time t ON f.time_id=t.time_id
JOIN Dim_Hotel h ON f.hotel_id=h.hotel_id
JOIN Dim_City c ON h.city_id=c.city_id
JOIN Dim_State s ON c.state_id=s.state_id
JOIN Dim_Room r ON f.room_id=r.room_id
JOIN Dim_RoomType rt ON r.room_type_id=rt.room_type_id
JOIN Dim_Floor fl ON r.floor_id=fl.floor_id
JOIN Dim_Booking b ON f.booking_id=b.booking_id;
