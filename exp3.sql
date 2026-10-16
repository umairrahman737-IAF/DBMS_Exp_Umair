CREATE TABLE Department ( Dept_ID INT PRIMARY KEY,
Dept_Name VARCHAR(50) NOT NULL,
Location VARCHAR(50)
);

CREATE TABLE Employee ( Emp_ID INT PRIMARY KEY,
Emp_Name VARCHAR(50) NOT NULL,
Salary DECIMAL(10,2),
Job_Title VARCHAR(50), Dept_ID INT,
FOREIGN KEY (Dept_ID) REFERENCES Department(Dept_ID)
);

CREATE TABLE Project ( Project_ID INT PRIMARY KEY,
Project_Name VARCHAR(100) NOT NULL,
Budget DECIMAL(12,2),
Dept_ID INT,
FOREIGN KEY (Dept_ID) REFERENCES Department(Dept_ID)
);

INSERT INTO Department VALUES
(1, 'Computer Science', 'Block A'), (2, 'Human Resources', 'Block B'), (3, 'Finance', 'Block C'),
(4, 'Marketing', 'Block D'),
(5, 'Research', 'Block E');

INSERT INTO Employee VALUES
(101, 'UMAIR', 55000, 'Developer', 1),
(102, 'RAHMAN', 62000, 'Senior Developer', 1),
(103, 'Priya', 48000, 'Tester', 1),

(104,	'Neha', 75000, 'Team Lead', 1),
(105,	'Rohan', 52000, 'Developer', 1),
(106,	'Simran', 68000, 'Data Analyst', 1),
(107,	'Ankit',	45000,	'HR Executive', 2),
(108,	'Pooja',	58000,	'HR Manager', 2),
(109,	'Karan',	42000,	'Recruiter', 2),
(110,	'Sneha',	65000,	'HR Manager', 2),
(111,	'Arjun',	47000,	'HR Executive', 2),
(112,	'Meena',	50000,	'Recruiter', 2),
(113,	'Vikash', 60000, 'Accountant', 3),
(114,	'Nisha', 72000, 'Finance Manager', 3),
(115,	'Raj', 48000, 'Accountant', 3),
(116,	'Kavita', 55000, 'Financial Analyst', 3),
(117,	'Deepak', 80000, 'Finance Manager', 3),
(118,	'Tanya', 51000, 'Accountant', 3),
(119,	'Mohit', 46000, 'Marketing Executive', 4),
(120,	'Riya', 59000, 'Marketing Manager', 4),
(121,	'Varun', 52000, 'SEO Specialist', 4),
(122,	'Isha', 70000, 'Marketing Manager', 4),
(123,	'Nitin', 44000, 'Content Writer', 4),
(124,	'Anjali', 56000, 'Marketing Executive', 4),
(125,	'Sahil', 65000, 'Researcher', 5),
(126,	'Aditi', 78000, 'Research Scientist', 5),
(127,	'Manish', 55000, 'Researcher', 5),
(128,	'Komal', 62000, 'Data Scientist', 5),
(129,	'Yash', 85000, 'Research Lead', 5),
(130,	'Divya', 60000, 'Researcher', 5);

INSERT INTO Project VALUES

(201,	'AI Chatbot', 500000, 1),
(202,	'Web Application', 350000, 1),
(203,	'Employee Management System', 250000, 2),
(204,	'Payroll System', 400000, 3),
(205,	'Marketing Campaign', 300000, 4),
(206,	'Social Media Analytics', 275000, 4),
(207,	'Machine Learning Research', 600000, 5),
(208,	'Data Science Platform', 550000, 5);

SELECT *
FROM Employee
WHERE Salary > 60000 and emp_id between 101 and 105;
SELECT Emp_Name, Salary
FROM Employee where emp_id between 101 and 105;

SELECT
COUNT(*) AS Total_Employees, SUM(Salary) AS Total_Salary, AVG(Salary) AS Average_Salary, MAX(Salary) AS Highest_Salary, MIN(Salary) AS Lowest_Salary
FROM Employee;

SELECT Dept_ID, COUNT(*) AS Employee_Count FROM Employee
GROUP BY Dept_ID;

SELECT Dept_ID, COUNT(*) AS Employee_Count FROM Employee
GROUP BY Dept_ID
HAVING COUNT(*) > 5;

SELECT
Emp_Name, Salary, CASE
WHEN Salary >= 75000 THEN 'High Salary' WHEN Salary >= 55000 THEN 'Medium Salary' ELSE 'Low Salary'
END AS Salary_Category
FROM Employee where emp_id between 101 and 105;

SELECT Emp_Name, Salary FROM Employee
where emp_id between 101 and 105 ORDER BY Salary ASC;