-- ======================================================
-- Database: Hard_Level_DB / PracticeDB
-- Topic: ALL JOINS - Practice
-- Author: Practice for 3 Years Exp Level
-- ======================================================


-- ------------------------------------------------------
-- 0. Check Databases & Tables
-- ------------------------------------------------------
SELECT name, database_id, create_date
FROM sys.databases
ORDER BY database_id DESC;

SELECT TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
ORDER BY TABLE_SCHEMA ASC, TABLE_NAME ASC;

-- ------------------------------------------------------
-- 1. INNER JOIN
-- Only employees who have a department
-- Manish Tiwari will NOT come (dept_id is NULL)
-- ------------------------------------------------------
SELECT
    e.fname,
    e.lname,
    d.dept_name,
    e.city,
    e.salary
FROM dbo.Employees AS e
INNER JOIN dbo.Departments AS d
    ON e.dept_id = d.dept_id
ORDER BY e.salary DESC;

-- ------------------------------------------------------
-- 2. RIGHT JOIN
-- All departments, even with no employees
-- Legal department will come with NULL employee
-- ------------------------------------------------------
SELECT
    e.fname,
    e.lname,
    d.dept_name,
    e.city,
    e.salary,
    d.dept_id
FROM dbo.Employees AS e
RIGHT JOIN dbo.Departments AS d
    ON e.dept_id = d.dept_id
ORDER BY e.salary DESC;

-- ------------------------------------------------------
-- 3. Departments With NO Project
-- Clean version - No need of Employees table here
-- ------------------------------------------------------
SELECT
    d.dept_id,
    d.dept_name,
    d.location
FROM dbo.Departments AS d
LEFT JOIN dbo.Projects AS p
    ON d.dept_id = p.dept_id
WHERE p.project_id IS NULL;

-- ------------------------------------------------------
-- 4. FULL OUTER JOIN
-- a) Employees with no department
-- b) Departments with no employee
-- Both in one query
-- ------------------------------------------------------
SELECT
    e.fname,
    e.lname,
    d.dept_name,
    e.city,
    e.salary,
    e.dept_id AS emp_dept_id,
    d.dept_id AS dept_dept_id
FROM dbo.Employees AS e
FULL OUTER JOIN dbo.Departments AS d
    ON e.dept_id = d.dept_id
ORDER BY e.salary DESC;

-- ------------------------------------------------------
-- 5. CROSS JOIN
-- Every Department x Every Active Project
-- 6 Departments x 3 Active Projects = 18 Rows
-- ------------------------------------------------------
SELECT
    d.dept_name,
    p.project_name,
    p.status
FROM dbo.Departments AS d
CROSS JOIN dbo.Projects AS p
WHERE p.status = 'Active';

-- ------------------------------------------------------
-- 6. SELF JOIN - Employee + Manager
-- LEFT JOIN is must, else top 5 bosses will disappear
-- ------------------------------------------------------
SELECT
    CONCAT(e2.fname, ' ', e2.lname) AS manager_name,
    CONCAT(e1.fname, ' ', e1.lname) AS emp_name,
    e2.salary AS manager_salary,
    e1.salary AS emp_salary
FROM dbo.Employees AS e1
LEFT JOIN dbo.Employees AS e2
    ON e1.manager_id = e2.emp_id
ORDER BY manager_name DESC;

-- ------------------------------------------------------
-- 7. SELF JOIN - Same City + Same Dept Pair
-- e1.emp_id < e2.emp_id stops duplicate pairs
-- (A,B) will come, (B,A) will NOT come
-- ------------------------------------------------------
SELECT
    e1.fname AS emp1_fname,
    e2.fname AS emp2_fname,
    e1.city,
    e1.dept_id
FROM dbo.Employees AS e1
INNER JOIN dbo.Employees AS e2
    ON e1.city = e2.city
    AND e1.dept_id = e2.dept_id
WHERE e1.emp_id < e2.emp_id;