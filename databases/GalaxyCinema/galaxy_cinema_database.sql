-- File: galaxy_cinema_database.sql
-- Author: Phu Vo
-- Created At: 09-08-2025
-- Description: Database and tables for system management of the Galaxy Cinema
-- 				including films, screenings, rooms, booking, seats, and customers

SET NAMES utf8mb4;

CREATE DATABASE IF NOT EXISTS galaxy_cinema
	DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;
    
USE galaxy_cinema;

BEGIN;

-- Drop tables in reversed order to avoid errors relating to foreign keys
DROP TABLE IF EXISTS reserved_seats;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS screenings;
DROP TABLE IF EXISTS seats;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS rooms;
DROP TABLE IF EXISTS films;

-- Create tables
CREATE TABLE IF NOT EXISTS films (
	id CHAR(5) PRIMARY KEY,
    film_name VARCHAR(50) NOT NULL,
    length_min INT NOT NULL,
    genre VARCHAR(25) NOT NULL,
    country CHAR(2) NOT NULL,
    CONSTRAINT chk_length_min CHECK (length_min > 0)
);

CREATE TABLE IF NOT EXISTS rooms (
	id CHAR(4) PRIMARY KEY,
    room_name VARCHAR(25) NOT NULL
);

CREATE TABLE IF NOT EXISTS customers (
	id CHAR(4) PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL,
    phone CHAR(10),
    CONSTRAINT chk_phone CHECK (phone REGEXP '^[0-9]{10}$')
);

CREATE TABLE IF NOT EXISTS screenings (
	id CHAR(5) PRIMARY KEY,
    film_id CHAR(5) NOT NULL,
    room_id CHAR(4) NOT NULL,
    start_time DATETIME NOT NULL,
    CONSTRAINT fk_screenings_film_id FOREIGN KEY (film_id) REFERENCES films(id),
    CONSTRAINT fk_screenings_room_id FOREIGN KEY (room_id) REFERENCES rooms(id)
);

CREATE TABLE IF NOT EXISTS bookings (
	id CHAR(4) PRIMARY KEY,
    customer_id CHAR(4) NOT NULL,
    screening_id CHAR(5) NOT NULL,
    booking_time DATETIME NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_bookings_customer_id FOREIGN KEY (customer_id) REFERENCES customers(id),
    CONSTRAINT fk_bookings_screening_id FOREIGN KEY (screening_id) REFERENCES screenings(id),
    CONSTRAINT chk_total CHECK (total >= 0)
);

CREATE TABLE IF NOT EXISTS seats (
	id CHAR(4) PRIMARY KEY,
    room_id CHAR(4) NOT NULL,
    row_character CHAR(1) NOT NULL,
    col_number INT NOT NULL,
    x INT NOT NULL,
    y INT NOT NULL,
    seat_type ENUM('normal', 'couple', 'luxury') DEFAULT 'normal',
    CONSTRAINT fk_seats_room_id FOREIGN KEY (room_id) REFERENCES rooms(id),
    CONSTRAINT chk_row_character CHECK (row_character BETWEEN 'A' AND 'Z'),
    CONSTRAINT chk_col_number CHECK (col_number > 0),
    CONSTRAINT uq1_seats UNIQUE(room_id, row_character, col_number),
    CONSTRAINT uq2_seats UNIQUE(room_id, x, y)
);

CREATE TABLE IF NOT EXISTS reserved_seats (
	id CHAR(5) PRIMARY KEY,
    booking_id CHAR(4) NOT NULL,
    seat_id CHAR(4) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_reserved_seats_booking_id FOREIGN KEY (booking_id) REFERENCES bookings(id),
    CONSTRAINT fk_reserved_seats_seat_id FOREIGN KEY (seat_id) REFERENCES seats(id),
    CONSTRAINT chk_price CHECK (price >= 0),
    CONSTRAINT uq1_reserved_seats UNIQUE(id, booking_id, seat_id)
);

-- Insert data
INSERT INTO  films VALUES
('FM001', 'Movie A',  120, 'Comedy', 'VN'),
('FM002', 'Movie B',  125, 'Horror', 'AU'),
('FM003', 'Movie C',  162, 'Horror', 'JP');

INSERT INTO rooms VALUES
('T001', 'Threater A'),
('T002', 'Threater B'),
('T003', 'Threater C');

INSERT INTO customers VALUES
('C001', 'Leslie', '0123123123'),
('C002', 'Noah', '0456456456'),
('C003', 'Ivy', '0789789789'),
('C004', 'Jayden', '0123456789'),
('C005', 'Johnathan', '0123454321');

INSERT INTO screenings VALUES
('SC001', 'FM003', 'T002', '2025-09-01 14:00:00'),
('SC002', 'FM002', 'T001', '2025-09-02 10:00:00'),
('SC003', 'FM002', 'T001', '2025-09-04 10:00:00'),
('SC004', 'FM001', 'T003', '2025-09-05 18:00:00');

INSERT INTO bookings VALUES
('B001', 'C001', 'SC002', '2025-08-30 15:30:00', 14.99),
('B002', 'C001', 'SC003', '2025-08-31 10:40:00', 14.99),
('B003', 'C003', 'SC004', '2025-09-01 8:37:00', 14.99),
('B004', 'C004', 'SC004', '2025-09-01 6:11:00', 14.99);

INSERT INTO seats VALUES
('S001', 'T001', 'A', 1, 1, 1, 'normal'),
('S002', 'T001', 'A', 5, 1, 3, 'normal'),
('S003', 'T002', 'G', 4, 1, 1, 'luxury'),
('S004', 'T003', 'F', 6, 2, 1, 'couple'),
('S005', 'T003', 'F', 5, 3, 1, 'couple');

INSERT INTO reserved_seats VALUES
('RS001', 'B001', 'S001', 2.99),
('RS002', 'B002', 'S002', 2.99),
('RS003', 'B003', 'S004', 2.99),
('RS004', 'B003', 'S003', 2.99),
('RS005', 'B004', 'S005', 2.99);

-- Optimize tables
OPTIMIZE TABLE films, rooms, customers, screenings, bookings, seats, reserved_seats;

COMMIT;

SELECT * FROM films;

SELECT * FROM rooms;

SELECT * FROM customers;

SELECT * FROM screenings;

SELECT * FROM bookings;

SELECT * FROM seats;

SELECT * FROM reserved_seats;