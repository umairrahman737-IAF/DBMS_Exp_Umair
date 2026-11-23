
CREATE DATABASE RailwayDB;
USE RailwayDB;


-- STEP 2: CREATE TABLE

CREATE TABLE Railway_Booking (
    Booking_ID INT PRIMARY KEY,
    Passenger_Name VARCHAR(50),
    Train_No INT,
    From_Station VARCHAR(50),
    To_Station VARCHAR(50),
    Journey_Date DATE,
    Travel_Class VARCHAR(20),
    Seat_No INT,
    Fare DECIMAL(10,2),
    Booking_Status VARCHAR(20)
) ENGINE=InnoDB;


-- STEP 3: INSERT 5000 RECORDS

DELIMITER //

CREATE PROCEDURE GenerateBookings()
BEGIN
    DECLARE i INT DEFAULT 1;

    WHILE i <= 5000 DO

        INSERT INTO Railway_Booking VALUES (
            i,
            CONCAT('Passenger_', i),
            12000 + MOD(i, 50),
            CONCAT('Station_', MOD(i, 10)),
            CONCAT('Station_', MOD(i + 3, 10)),
            DATE_ADD('2026-01-01',
                INTERVAL MOD(i, 90) DAY),
            CASE MOD(i, 3)
                WHEN 0 THEN 'Sleeper'
                WHEN 1 THEN 'AC'
                ELSE 'General'
            END,
            MOD(i, 72) + 1,
            500 + MOD(i, 1000),
            CASE MOD(i, 2)
                WHEN 0 THEN 'Confirmed'
                ELSE 'Waiting'
            END
        );

        SET i = i + 1;

    END WHILE;
END //

DELIMITER ;

CALL GenerateBookings();

-- CHECK TOTAL RECORDS

SELECT COUNT(*) AS Total_Records
FROM Railway_Booking;


-- ==========================================
-- STEP 4: PERFORMANCE BEFORE INDEXING
-- ==========================================

-- Display existing indexes

SHOW INDEX FROM Railway_Booking;

-- Check execution plan

EXPLAIN
SELECT *
FROM Railway_Booking
WHERE Train_No = 12010
AND Journey_Date = '2026-01-11';

-- Measure actual execution

EXPLAIN ANALYZE
SELECT *
FROM Railway_Booking
WHERE Train_No = 12010
AND Journey_Date = '2026-01-11';


-- ==========================================
-- STEP 5: CREATE SINGLE INDEX
-- ==========================================

CREATE INDEX idx_train
ON Railway_Booking(Train_No);

-- Check execution plan after single index

EXPLAIN
SELECT *
FROM Railway_Booking
WHERE Train_No = 12010
AND Journey_Date = '2026-01-11';

-- Measure execution

EXPLAIN ANALYZE
SELECT *
FROM Railway_Booking
WHERE Train_No = 12010
AND Journey_Date = '2026-01-11';


-- ==========================================
-- STEP 6: CREATE COMPOSITE INDEX
-- ==========================================

CREATE INDEX idx_train_date
ON Railway_Booking(Train_No, Journey_Date);

-- Remove single index to compare composite alone

DROP INDEX idx_train ON Railway_Booking;

-- Check execution plan after composite index

EXPLAIN
SELECT *
FROM Railway_Booking
WHERE Train_No = 12010
AND Journey_Date = '2026-01-11';

-- Measure actual execution

EXPLAIN ANALYZE
SELECT *
FROM Railway_Booking
WHERE Train_No = 12010
AND Journey_Date = '2026-01-11';


-- ==========================================
-- STEP 7: TEST SINGLE INDEX ON PASSENGER
-- ==========================================

CREATE INDEX idx_passenger
ON Railway_Booking(Passenger_Name);

EXPLAIN
SELECT *
FROM Railway_Booking
WHERE Passenger_Name = 'Passenger_1000';

EXPLAIN ANALYZE
SELECT *
FROM Railway_Booking
WHERE Passenger_Name = 'Passenger_1000';


-- ==========================================
-- STEP 8: DISPLAY ALL INDEXES
-- ==========================================

SHOW INDEX FROM Railway_Booking;


-- ==========================================
-- STEP 9: FINAL TABLE CHECK
-- ==========================================

SELECT COUNT(*) AS Total_Records
FROM Railway_Booking;

SELECT *
FROM Railway_Booking
LIMIT 10;
