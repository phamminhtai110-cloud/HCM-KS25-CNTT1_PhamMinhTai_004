DROP DATABASE IF EXISTS CompanyDB;

CREATE DATABASE CompanyDB;
USE CompanyDB;

CREATE TABLE Department (
    dept_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    dept_name VARCHAR(100) NOT NULL,
    location VARCHAR(100)
);

CREATE TABLE Employee (
    emp_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    emp_name VARCHAR(100) NOT NULL,
    gender INT DEFAULT 1,
    birth_date DATE,
    salary DECIMAL(10,2),
    dept_id INT,
    FOREIGN KEY (dept_id)
        REFERENCES Department(dept_id)
        ON UPDATE CASCADE
);

CREATE TABLE Project (
    project_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    project_name VARCHAR(150) NOT NULL,
    emp_id INT,
    start_date DATE DEFAULT (CURRENT_DATE),
    end_date DATE,
    FOREIGN KEY (emp_id)
        REFERENCES Employee(emp_id)
);


ALTER TABLE Employee
ADD email VARCHAR(100) UNIQUE;

ALTER TABLE Project
MODIFY project_name VARCHAR(200);

ALTER TABLE Project
ADD CONSTRAINT chk_project_date
CHECK (end_date >= start_date);

INSERT INTO Department(dept_id, dept_name, location)
VALUES
(1, 'IT', 'Ha Noi'),
(2, 'HR', 'HCM'),
(3, 'Marketing', 'Da Nang');

SELECT * FROM Department;

INSERT INTO Employee(emp_id, emp_name, gender, birth_date, salary, dept_id, email)
VALUES
(1, 'Nguyen Van A', 1, '1990-01-15', 1500, 1, 'a@gmail.com'),
(2, 'Tran Thi B', 0, '1995-05-20', 1200, 1, 'b@gmail.com'),
(3, 'Le Minh C', 1, '1988-10-10', 2000, 2, 'c@gmail.com'),
(4, 'Pham Thi D', 0, '1992-12-05', 1800, 3, 'd@gmail.com');

SELECT * FROM Employee;

INSERT INTO Project(project_id, project_name, emp_id, start_date, end_date)
VALUES
(101, 'Website Redesign', 1, '2024-01-01', '2024-06-01'),
(102, 'Recruitment System', 3, '2024-02-01', '2024-08-01'),
(103, 'Marketing Campaign', 4, '2024-03-01', NULL);

SELECT * FROM Project;

UPDATE Employee
SET salary = salary + 200
WHERE dept_id = 1
AND emp_id > 0;

SELECT * FROM Employee;

UPDATE Project
SET end_date = '2024-12-31'
WHERE end_date IS NULL
AND project_id > 0;

SELECT * FROM Project;

DELETE FROM Project
WHERE start_date < '2024-02-01'
AND project_id > 0;

SELECT * FROM Project;

SELECT
    emp_name,
    email,
    CASE
        WHEN gender = 1 THEN 'Nam'
        ELSE 'Nu'
    END AS gender_name
FROM Employee;

SELECT
    UPPER(emp_name) AS employee_name,
    YEAR(CURDATE()) - YEAR(birth_date) AS age
FROM Employee;

SELECT
    e.emp_name,
    e.salary,
    d.dept_name
FROM Employee e
INNER JOIN Department d
ON e.dept_id = d.dept_id;

SELECT *
FROM Employee
ORDER BY salary DESC
LIMIT 2;

SELECT
    d.dept_name,
    COUNT(e.emp_id) AS total_employee
FROM Department d
INNER JOIN Employee e
ON d.dept_id = e.dept_id
GROUP BY d.dept_name
HAVING COUNT(e.emp_id) >= 2;

SELECT *
FROM Employee
WHERE salary > (
    SELECT AVG(salary)
    FROM Employee
);

SELECT *
FROM Employee
WHERE emp_id IN (
    SELECT emp_id
    FROM Project
);

SELECT *
FROM Employee e1
WHERE salary = (
    SELECT MAX(e2.salary)
    FROM Employee e2
    WHERE e1.dept_id = e2.dept_id
);