
CREATE DATABASE QueryOptimization;
USE QueryOptimization;


-- STEP 2: CREATE CUSTOMERS TABLE

CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(50)
) ENGINE=InnoDB;


-- STEP 3: CREATE ORDERS TABLE

CREATE TABLE Orders (
    Order_ID INT PRIMARY KEY,
    Customer_ID INT,
    Product_Category VARCHAR(30),
    City VARCHAR(30),
    Order_Date DATE,
    Status VARCHAR(20),
    Amount DECIMAL(10,2),

    FOREIGN KEY (Customer_ID)
    REFERENCES Customers(Customer_ID)
) ENGINE=InnoDB;


-- STEP 4: GENERATE 10,000 RECORDS

DELIMITER //

CREATE PROCEDURE GenerateData()
BEGIN
    DECLARE i INT DEFAULT 1;

    -- Generate 1000 customers
    WHILE i <= 1000 DO

        INSERT INTO Customers VALUES (
            i,
            CONCAT('Customer_', i)
        );

        SET i = i + 1;
    END WHILE;

    SET i = 1;

    -- Generate 10000 orders
    WHILE i <= 10000 DO

        INSERT INTO Orders VALUES (
            i,
            MOD(i, 1000) + 1,

            CASE MOD(i, 4)
                WHEN 0 THEN 'Electronics'
                WHEN 1 THEN 'Clothing'
                WHEN 2 THEN 'Furniture'
                ELSE 'Books'
            END,

            CASE MOD(i, 5)
                WHEN 0 THEN 'Delhi'
                WHEN 1 THEN 'Mumbai'
                WHEN 2 THEN 'Agra'
                WHEN 3 THEN 'Mathura'
                ELSE 'Jaipur'
            END,

            DATE_ADD(
                '2024-01-01',
                INTERVAL MOD(i, 1095) DAY
            ),

            CASE MOD(i, 3)
                WHEN 0 THEN 'Completed'
                WHEN 1 THEN 'Pending'
                ELSE 'Cancelled'
            END,

            100 + MOD(i * 37, 5000)
        );

        SET i = i + 1;

    END WHILE;
END //

DELIMITER ;

CALL GenerateData();


-- STEP 5: VERIFY DATASET

SELECT COUNT(*) AS Total_Customers
FROM Customers;

SELECT COUNT(*) AS Total_Orders
FROM Orders;


-- ============================================
-- STEP 6: FIVE SLOW QUERIES (BEFORE OPTIMIZATION)
-- ============================================

-- SLOW QUERY 1:
-- Using YEAR() function on Order_Date

EXPLAIN
SELECT *
FROM Orders
WHERE YEAR(Order_Date) = 2025
AND Status = 'Completed';

EXPLAIN ANALYZE
SELECT *
FROM Orders
WHERE YEAR(Order_Date) = 2025
AND Status = 'Completed';


-- SLOW QUERY 2:
-- Using LOWER() function on City

EXPLAIN
SELECT *
FROM Orders
WHERE LOWER(City) = 'delhi';

EXPLAIN ANALYZE
SELECT *
FROM Orders
WHERE LOWER(City) = 'delhi';


-- SLOW QUERY 3:
-- Searching using multiple conditions

EXPLAIN
SELECT *
FROM Orders
WHERE Product_Category = 'Electronics'
AND Status = 'Completed';

EXPLAIN ANALYZE
SELECT *
FROM Orders
WHERE Product_Category = 'Electronics'
AND Status = 'Completed';


-- SLOW QUERY 4:
-- Searching and sorting customer orders

EXPLAIN
SELECT *
FROM Orders
WHERE Customer_ID = 101
ORDER BY Order_Date DESC
LIMIT 20;

EXPLAIN ANALYZE
SELECT *
FROM Orders
WHERE Customer_ID = 101
ORDER BY Order_Date DESC
LIMIT 20;


-- SLOW QUERY 5:
-- Correlated subquery for total customer spending

EXPLAIN
SELECT Customer_ID
FROM Customers C
WHERE (
    SELECT SUM(Amount)
    FROM Orders O
    WHERE O.Customer_ID = C.Customer_ID
) > 20000;

EXPLAIN ANALYZE
SELECT Customer_ID
FROM Customers C
WHERE (
    SELECT SUM(Amount)
    FROM Orders O
    WHERE O.Customer_ID = C.Customer_ID
) > 20000;


-- ============================================
-- STEP 7: CREATE INDEXES
-- ============================================

-- Index 1: Single index on City

CREATE INDEX idx_city
ON Orders(City);


-- Index 2: Composite index on Status and Date

CREATE INDEX idx_status_date
ON Orders(Status, Order_Date);


-- Index 3: Composite index on Category and Status

CREATE INDEX idx_category_status
ON Orders(Product_Category, Status);


-- Index 4: Composite index on Customer and Date

CREATE INDEX idx_customer_date
ON Orders(Customer_ID, Order_Date);


-- Index 5: Single index on Customer_ID

CREATE INDEX idx_customer
ON Orders(Customer_ID);


-- Update table statistics

ANALYZE TABLE Orders;


-- ============================================
-- STEP 8: OPTIMIZED QUERIES
-- ============================================

-- OPTIMIZED QUERY 1:
-- Replace YEAR() with date range

EXPLAIN ANALYZE
SELECT *
FROM Orders
WHERE Status = 'Completed'
AND Order_Date >= '2025-01-01'
AND Order_Date < '2026-01-01';


-- OPTIMIZED QUERY 2:
-- Remove LOWER() function

EXPLAIN ANALYZE
SELECT *
FROM Orders
WHERE City = 'Delhi';


-- OPTIMIZED QUERY 3:
-- Use composite index

EXPLAIN ANALYZE
SELECT *
FROM Orders
WHERE Product_Category = 'Electronics'
AND Status = 'Completed';


-- OPTIMIZED QUERY 4:
-- Use composite index for filtering and sorting

EXPLAIN ANALYZE
SELECT *
FROM Orders
WHERE Customer_ID = 101
ORDER BY Order_Date DESC
LIMIT 20;


-- OPTIMIZED QUERY 5:
-- Replace correlated subquery with JOIN

EXPLAIN ANALYZE
SELECT O.Customer_ID
FROM Orders O
GROUP BY O.Customer_ID
HAVING SUM(O.Amount) > 20000;


-- ============================================
-- STEP 9: DISPLAY ALL CREATED INDEXES
-- ============================================

SHOW INDEX FROM Orders;


-- ============================================
-- STEP 10: FINAL RECORD COUNT
-- ============================================

SELECT COUNT(*) AS Final_Total_Records
FROM Orders;

SELECT * FROM Orders LIMIT 10;
