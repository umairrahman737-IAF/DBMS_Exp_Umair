SELECT
E.Emp_ID, E.Emp_Name, E.Salary, D.Dept_Name
FROM Employee E
INNER JOIN Department D ON E.Dept_ID = D.Dept_ID;

SELECT
E.Emp_ID, E.Emp_Name, D.Dept_Name
FROM Employee E
LEFT JOIN Department D
ON E.Dept_ID = D.Dept_ID;

SELECT
E1.Emp_Name AS Employee1, E2.Emp_Name AS Employee2, E1.Dept_ID
FROM Employee E1 JOIN Employee E2
ON E1.Dept_ID = E2.Dept_ID
AND E1.Emp_ID < E2.Emp_ID;

SELECT
E.Emp_Name, D.Dept_Name, P.Project_Name, P.Budget
FROM Employee E
INNER JOIN Department D
ON E.Dept_ID = D.Dept_ID INNER JOIN Project P
ON D.Dept_ID = P.Dept_ID;

SELECT
E.Emp_Name, E.Salary, E.Dept_ID
FROM Employee E WHERE E.Salary > (
SELECT AVG(E2.Salary)
FROM Employee E2
WHERE E2.Dept_ID = E.Dept_ID
);

SELECT
D.Dept_ID, D.Dept_Name
FROM Department D
WHERE EXISTS ( SELECT 1
FROM Employee E
WHERE E.Dept_ID = D.Dept_ID
);

SELECT E.Emp_ID, E.Emp_Name FROM Employee E
WHERE E.Salary > 60000 AND EXISTS (
SELECT 1
FROM Project P
WHERE P.Dept_ID = E.Dept_ID
);

SELECT E.Emp_ID, E.Emp_Name FROM Employee E
WHERE E.Salary > 60000 AND NOT EXISTS (
SELECT 1
FROM Project P
WHERE P.Dept_ID = E.Dept_ID
);