
-- =========================================
-- BANKING TRANSACTION MANAGEMENT
-- =========================================

-- STEP 1: CREATE DATABASE
CREATE DATABASE BankingDB;
USE BankingDB;

-- STEP 2: CREATE ACCOUNTS TABLE
CREATE TABLE Accounts (
    Account_ID INT PRIMARY KEY,
    Account_Name VARCHAR(50),
    Balance DECIMAL(10,2)
) ENGINE=InnoDB;

-- STEP 3: INSERT SAMPLE DATA
INSERT INTO Accounts VALUES
(101, 'Ali', 10000),
(102, 'Ahmed', 5000),
(103, 'Sara', 8000);

-- CHECK INITIAL BALANCE
SELECT * FROM Accounts;


-- =========================================
-- STEP 4: BASIC TRANSACTION (COMMIT)
-- =========================================

START TRANSACTION;

UPDATE Accounts
SET Balance = Balance - 1000
WHERE Account_ID = 101;

UPDATE Accounts
SET Balance = Balance + 1000
WHERE Account_ID = 102;

COMMIT;

SELECT * FROM Accounts;


-- =========================================
-- STEP 5: ROLLBACK TRANSACTION
-- =========================================

START TRANSACTION;

UPDATE Accounts
SET Balance = Balance - 2000
WHERE Account_ID = 101;

UPDATE Accounts
SET Balance = Balance + 2000
WHERE Account_ID = 102;

-- CANCEL TRANSACTION
ROLLBACK;

-- BALANCE WILL REMAIN UNCHANGED
SELECT * FROM Accounts;


-- =========================================
-- STEP 6: SAVEPOINT
-- =========================================

START TRANSACTION;

UPDATE Accounts
SET Balance = Balance - 500
WHERE Account_ID = 101;

SAVEPOINT S1;

UPDATE Accounts
SET Balance = Balance - 1000
WHERE Account_ID = 102;

-- UNDO ONLY THE SECOND UPDATE
ROLLBACK TO SAVEPOINT S1;

COMMIT;

SELECT * FROM Accounts;


-- =========================================
-- STEP 7: SIMULATE PARTIAL FAILURE
-- =========================================

START TRANSACTION;

UPDATE Accounts
SET Balance = Balance - 1000
WHERE Account_ID = 101;

SAVEPOINT Before_Failure;

-- SIMULATED FAILURE:
-- Invalid account ID; no account is updated.
UPDATE Accounts
SET Balance = Balance + 1000
WHERE Account_ID = 999;

-- ROLLBACK TO SAVEPOINT
ROLLBACK TO SAVEPOINT Before_Failure;

COMMIT;

SELECT * FROM Accounts;


-- =========================================
-- STEP 8: ISOLATION LEVELS
-- =========================================

-- READ UNCOMMITTED
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- READ COMMITTED
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- REPEATABLE READ
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- SERIALIZABLE
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- CHECK CURRENT ISOLATION LEVEL
SELECT @@transaction_isolation;
