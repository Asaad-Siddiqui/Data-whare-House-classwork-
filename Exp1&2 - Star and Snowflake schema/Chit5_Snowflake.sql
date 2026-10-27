-- Extracted from the supplied DWM Practical Exp 1 & 2 PDF
-- MySQL script: schema creation, sample data, SELECT checks, and JOIN query.

-- SNOWFLAKE  |  Chit5_Airline_Snowflake
CREATE DATABASE Chit5_Airline_Snowflake; USE Chit5_Airline_Snowflake;
-- Tables: dimensions first, fact last
CREATE TABLE Dim_Time(time_id INT PRIMARY KEY, day INT, month INT, quarter INT, year INT);
CREATE TABLE Dim_Aircraft(aircraft_id INT PRIMARY KEY, aircraft_type VARCHAR(40));
CREATE TABLE Dim_Flight(flight_id INT PRIMARY KEY, flight_no VARCHAR(15), aircraft_id INT,
  FOREIGN KEY(aircraft_id) REFERENCES Dim_Aircraft(aircraft_id));
CREATE TABLE Dim_Airport(airport_id INT PRIMARY KEY, airport_code VARCHAR(10), airport_name VARCHAR(50));
CREATE TABLE Dim_Route(route_id INT PRIMARY KEY, origin_airport_id INT, destination_airport_id INT,
  FOREIGN KEY(origin_airport_id) REFERENCES Dim_Airport(airport_id),
  FOREIGN KEY(destination_airport_id) REFERENCES Dim_Airport(airport_id));
CREATE TABLE Dim_Passenger(passenger_id INT PRIMARY KEY, passenger_name VARCHAR(50),
  passenger_type VARCHAR(30));
CREATE TABLE Dim_Agent(agent_id INT PRIMARY KEY, agent_name VARCHAR(50), agency VARCHAR(50));
CREATE TABLE Fact_Booking(booking_id INT PRIMARY KEY, time_id INT, flight_id INT, route_id INT,
  passenger_id INT, agent_id INT, tickets_sold INT, fare_amount DECIMAL(10,2),
  seat_occupancy_pct DECIMAL(5,2), cancellations INT, FOREIGN KEY(time_id) REFERENCES Dim_Time(time_id),
  FOREIGN KEY(flight_id) REFERENCES Dim_Flight(flight_id),
  FOREIGN KEY(route_id) REFERENCES Dim_Route(route_id),
  FOREIGN KEY(passenger_id) REFERENCES Dim_Passenger(passenger_id),
  FOREIGN KEY(agent_id) REFERENCES Dim_Agent(agent_id));
-- One row in each table
INSERT INTO Dim_Time VALUES (1,25,10,4,2026);
INSERT INTO Dim_Aircraft VALUES (1,'Airbus A320');
INSERT INTO Dim_Flight VALUES (1,'AI202',1);
INSERT INTO Dim_Airport VALUES (1,'BOM','Mumbai'),(2,'DEL','Delhi');
INSERT INTO Dim_Route VALUES (1,1,2);
INSERT INTO Dim_Passenger VALUES (1,'Kabir Mehta','Adult');
INSERT INTO Dim_Agent VALUES (1,'Sky Travels','Sky Agency');
INSERT INTO Fact_Booking VALUES (1,1,1,1,1,1,1,8500.00,80.00,0);
-- Show every table
SELECT * FROM Dim_Time; SELECT * FROM Dim_Aircraft; SELECT * FROM Dim_Flight; SELECT * FROM Dim_Airport;
SELECT * FROM Dim_Route; SELECT * FROM Dim_Passenger; SELECT * FROM Dim_Agent; SELECT * FROM Fact_Booking;
-- Join: fact + all dimensions
SELECT f.booking_id, t.day, t.month, t.quarter, t.year, fl.flight_no, ac.aircraft_type,
  ao.airport_name AS origin, dest.airport_name AS destination, p.passenger_name, a.agent_name,
  f.tickets_sold, f.fare_amount, f.seat_occupancy_pct, f.cancellations
FROM Fact_Booking f
JOIN Dim_Time t ON f.time_id=t.time_id
JOIN Dim_Flight fl ON f.flight_id=fl.flight_id
JOIN Dim_Aircraft ac ON fl.aircraft_id=ac.aircraft_id
JOIN Dim_Route r ON f.route_id=r.route_id
JOIN Dim_Airport ao ON r.origin_airport_id=ao.airport_id
JOIN Dim_Airport dest ON r.destination_airport_id=dest.airport_id
JOIN Dim_Passenger p ON f.passenger_id=p.passenger_id
JOIN Dim_Agent a ON f.agent_id=a.agent_id;
