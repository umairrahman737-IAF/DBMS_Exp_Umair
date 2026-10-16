DELIMITER //

CREATE PROCEDURE transfer_employee( IN p_emp_id INT,
IN p_new_dept_id INT
) BEGIN
DECLARE v_emp_count INT DEFAULT 0;
DECLARE v_dept_count INT DEFAULT 0; DECLARE v_current_dept INT;

-- Error handler
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
ROLLBACK; RESIGNAL;
END;

START TRANSACTION;

-- Check employee SELECT COUNT(*)
INTO v_emp_count
FROM Employee
WHERE Emp_ID = p_emp_id;


IF v_emp_count = 0 THEN SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Employee does not exist'; END IF;

-- Check department SELECT COUNT(*)
INTO v_dept_count
FROM Department
WHERE Dept_ID = p_new_dept_id;

IF v_dept_count = 0 THEN SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Department does not exist';
END IF;

-- Get current department SELECT Dept_ID
INTO v_current_dept
FROM Employee
WHERE Emp_ID = p_emp_id;

-- Check if already in department
IF v_current_dept = p_new_dept_id THEN SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Employee is already in this department';
END IF;

-- Transfer employee UPDATE Employee
SET Dept_ID = p_new_dept_id
WHERE Emp_ID = p_emp_id;

COMMIT;
END // DELIMITER ;
CALL transfer_employee(101, 2);

SELECT Emp_ID, Emp_Name, Dept_ID FROM Employee
WHERE Emp_ID = 101;
CALL transfer_employee(999, 2); CREATE TABLE Salary_Audit (
Audit_ID INT AUTO_INCREMENT PRIMARY KEY,
Emp_ID INT,
Old_Salary DECIMAL(10,2),
New_Salary DECIMAL(10,2),
Changed_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
Action_Type VARCHAR(20)
);

DELIMITER //

CREATE TRIGGER validate_salary BEFORE INSERT ON Employee
FOR EACH ROW BEGIN
IF NEW.Salary <= 0 THEN SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Salary must be greater than zero'; END IF;
END // DELIMITER ; DELIMITER //
CREATE TRIGGER validate_salary_update BEFORE UPDATE ON Employee
FOR EACH ROW BEGIN
IF NEW.Salary <= 0 THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Salary must be greater than zero'; END IF;
END //

DELIMITER ;

UPDATE Employee SET Salary = 65000 WHERE Emp_ID = 101;

UPDATE Employee SET Salary = -5000 WHERE Emp_ID = 101;

UPDATE Employee
SET Salary = 0 WHERE Emp_ID = 101;

DELIMITER //

CREATE TRIGGER salary_audit AFTER UPDATE ON Employee FOR EACH ROW
BEGIN
IF OLD.Salary <> NEW.Salary THEN

INSERT INTO Salary_Audit (
Emp_ID,
Old_Salary, New_Salary, Action_Type
)
VALUES (



); END IF;
END // DELIMITER ;
OLD.Emp_ID,
OLD.Salary, NEW.Salary, 'SALARY UPDATE'
UPDATE Employee SET Salary = 70000 WHERE Emp_ID = 101;

SELECT *
FROM Salary_Audit;

UPDATE Employee
SET Emp_Name = 'Rahul Kumar' WHERE Emp_ID = 101;
SELECT *
FROM Salary_Audit;

UPDATE Employee SET Salary = -1000 WHERE Emp_ID = 101;