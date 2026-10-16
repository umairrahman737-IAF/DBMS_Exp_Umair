CREATE VIEW Department_Salary_Summary AS SELECT
D.Dept_ID, D.Dept_Name,
COUNT(E.Emp_ID) AS Total_Employees, SUM(E.Salary) AS Total_Salary, AVG(E.Salary) AS Average_Salary, MAX(E.Salary) AS Highest_Salary, MIN(E.Salary) AS Lowest_Salary
FROM Department D LEFT JOIN Employee E
ON D.Dept_ID = E.Dept_ID
GROUP BY D.Dept_ID, D.Dept_Name;
SELECT * FROM Department_Salary_Summary;

UPDATE Employee
SET Salary = Salary + 10000 WHERE Dept_ID = 1;

CREATE VIEW Employee_Hierarchy AS SELECT
E.Emp_ID,
E.Emp_Name, E.Job_Title, E.Salary, E.Dept_ID, E.Manager_ID,
M.Emp_Name AS Manager_Name FROM Employee E
LEFT JOIN Employee M
ON E.Manager_ID = M.Emp_ID; SELECT * FROM Employee_Hierarchy;

UPDATE Employee SET Salary = 65000
WHERE Emp_ID = 101; SELECT *
FROM Employee_Hierarchy
WHERE Emp_ID = 101;

CREATE VIEW Employee_Basic AS SELECT
Emp_ID,
Emp_Name, Salary, Job_Title, Dept_ID
FROM Employee; SELECT *
FROM Employee
WHERE Emp_ID = 102;

WITH RECURSIVE ReportingChain AS (
-- Anchor member
SELECT
Emp_ID, Emp_Name, Manager_ID,
0 AS Level,
CAST(Emp_Name AS CHAR(500)) AS Reporting_Path FROM Employee
WHERE Manager_ID IS NULL

UNION ALL

-- Recursive member SELECT
E.Emp_ID,
E.Emp_Name, E.Manager_ID, RC.Level + 1,
CONCAT(RC.Reporting_Path, ' -> ', E.Emp_Name) FROM Employee E
INNER JOIN ReportingChain RC
ON E.Manager_ID = RC.Emp_ID
)
SELECT
Emp_ID, Emp_Name, Manager_ID, Level, Reporting_Path
FROM ReportingChain ORDER BY Reporting_Path;

WITH RECURSIVE ReportingChain AS (
SELECT
Emp_ID, Emp_Name, Manager_ID,
0 AS Level,
CAST(Emp_Name AS CHAR(500)) AS Reporting_Path FROM Employee
WHERE Emp_ID = 101 UNION ALL
SELECT
E.Emp_ID, E.Emp_Name, E.Manager_ID, RC.Level + 1,
CONCAT(RC.Reporting_Path, ' -> ', E.Emp_Name) FROM Employee E
JOIN ReportingChain RC
ON E.Manager_ID = RC.Emp_ID
)
SELECT *
FROM ReportingChain;