
-- STEP 1: Create Database
CREATE DATABASE SalesDB;
USE SalesDB;

-- STEP 2: Create Original Sales Table (UNF converted to 1NF)
CREATE TABLE Sales (
    Order_ID INT,
    Customer_Name VARCHAR(50),
    Product_ID VARCHAR(10),
    Product_Name VARCHAR(50),
    Quantity INT,
    Unit_Price DECIMAL(10,2),
    PRIMARY KEY (Order_ID, Product_ID)
);

-- STEP 3: Insert Sample Data
INSERT INTO Sales VALUES
(101, 'Ali', 'P01', 'Laptop', 1, 50000),
(101, 'Ali', 'P02', 'Mouse', 2, 500),
(102, 'Ahmed', 'P01', 'Laptop', 1, 50000),
(103, 'Sara', 'P03', 'Keyboard', 1, 1500);

-- STEP 4: Create 2NF / 3NF / BCNF Tables

CREATE TABLE Orders (
    Order_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(50)
);

CREATE TABLE Products (
    Product_ID VARCHAR(10) PRIMARY KEY,
    Product_Name VARCHAR(50),
    Unit_Price DECIMAL(10,2)
);

CREATE TABLE Order_Details (
    Order_ID INT,
    Product_ID VARCHAR(10),
    Quantity INT,
    PRIMARY KEY (Order_ID, Product_ID),
    FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID),
    FOREIGN KEY (Product_ID) REFERENCES Products(Product_ID)
);

-- STEP 5: Insert Data into Normalized Tables

INSERT INTO Orders
SELECT DISTINCT Order_ID, Customer_Name FROM Sales;

INSERT INTO Products
SELECT DISTINCT Product_ID, Product_Name, Unit_Price FROM Sales;

INSERT INTO Order_Details
SELECT Order_ID, Product_ID, Quantity FROM Sales;

-- STEP 6: Display Normalized Tables

SELECT * FROM Orders;
SELECT * FROM Products;
SELECT * FROM Order_Details;

-- STEP 7: Verify Lossless Join

SELECT
    O.Order_ID,
    O.Customer_Name,
    P.Product_ID,
    P.Product_Name,
    D.Quantity,
    P.Unit_Price
FROM Orders O
JOIN Order_Details D ON O.Order_ID = D.Order_ID
JOIN Products P ON D.Product_ID = P.Product_ID;

-- STEP 8: Verify Dependency Preservation

-- Order_ID -> Customer_Name
SELECT Order_ID
FROM Orders
GROUP BY Order_ID
HAVING COUNT(DISTINCT Customer_Name) > 1;

-- Product_ID -> Product_Name, Unit_Price
SELECT Product_ID
FROM Products
GROUP BY Product_ID
HAVING COUNT(DISTINCT Product_Name) > 1
OR COUNT(DISTINCT Unit_Price) > 1;

-- (Order_ID, Product_ID) -> Quantity
SELECT Order_ID, Product_ID
FROM Order_Details
GROUP BY Order_ID, Product_ID
HAVING COUNT(DISTINCT Quantity) > 1;
