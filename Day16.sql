
select * from sys.databases order by database_id desc

use Hard_Level_DB

select * from INFORMATION_SCHEMA.COLUMNS
where COLUMN_NAME like '%allocation_pct%'

select * from INFORMATION_SCHEMA.TABLES 
order by TABLE_NAME desc

select * from Employees with(nolock)


select  d.dept_name, sum(e.salary) as total_salary from Departments d with(nolock)
inner join  Employees e with(nolock) on d.dept_id = e.dept_id
where e.is_active = 1
group by d.dept_name
order  by total_salary desc


select e1.manager_id, count(e1.emp_id) total_emp from Employees e1 with (nolock)
 join Employees e2 on e1.emp_id = e2.manager_id
 group by e1.manager_id, e1.emp_id
 having count(*) > 2


 select * from Employees with(nolock)

 select e1.emp_id, e2.manager_id, * from Employees e1 with (nolock)
  join Employees e2 on e1.emp_id = e2.manager_id
 where e1.salary > e2.salary


 select emp_id  from Employee_Projects with(nolock)
 group by emp_id
 having sum(allocation_pct)  > 100


 with cte as 
 (
	 select e.fname, e.lname, e.salary, d.dept_name,
	 DENSE_RANK() over(partition by d.dept_name order by e.salary desc) as dr
	 from Employees e with (nolock)
	 inner join Departments d on e.dept_id = d.dept_id
 )
 select * from cte 
 where dr <= 2


with cte  as (
select e.fname, e.lname, e.salary, d.dept_name,
    max(e.salary) over(partition by d.dept_name) as max_salary,
	DENSE_RANK() over(partition by d.dept_name order by e.salary desc) as rank_salary
	 from Employees e with (nolock)
	 inner join Departments d on e.dept_id = d.dept_id

)
select salary - max_salary as salary_diff, *
from cte 
order by dept_name, salary desc


--For each employee in Salary_History, show new_salary, 
--previous new_salary, and % hike. Use LAG()

select sh.new_salary, 
lag(new_salary) over(partition by e.emp_id order by new_salary asc) as previous_history_salarys
from Employees e with (nolock)
inner join Salary_History sh on e.emp_id = sh.emp_id



WITH SalaryHistoryCTE AS (
    SELECT 
        e.emp_id,
        e.fname, -- Added for readability
        e.lname,  -- Added for readability
        sh.new_salary,
        -- Pulls the previous salary for the specific employee based on chronological order
        LAG(sh.new_salary) OVER (
            PARTITION BY e.emp_id 
            ORDER BY sh.change_date ASC -- Replace change_date with your actual history date column
        ) AS previous_new_salary
    FROM Employees e WITH (NOLOCK)
    INNER JOIN Salary_History sh ON e.emp_id = sh.emp_id
)
SELECT 
    emp_id,
    fname,
    lname,
    new_salary,
    previous_new_salary,
    -- Calculates percentage hike, converting to float to avoid integer division truncation
    CASE 
        WHEN previous_new_salary IS NULL THEN 0.0
        ELSE ((new_salary - previous_new_salary) / CAST(previous_new_salary AS FLOAT)) * 100.0 
    END AS percent_hike
FROM SalaryHistoryCTE;


--Find the latest salary change for every employee who has history. 
--Then compare if it matches current Employees.salary — find mismatches.

select * from Employees e with (nolock)
inner join Salary_History sh with (nolock) on e.emp_id = sh.emp_id
order by e.emp_id asc


WITH LatestHistory AS (
    SELECT 
        emp_id,
        new_salary AS latest_history_salary,
        -- Filters down to the most recent change date per employee
        ROW_NUMBER() OVER (PARTITION BY emp_id ORDER BY change_date DESC) as rn
    FROM Salary_History WITH (NOLOCK)
)
SELECT 
    e.emp_id,
    e.salary AS current_employee_table_salary,
    lh.latest_history_salary
FROM Employees e WITH (NOLOCK)
INNER JOIN LatestHistory lh ON e.emp_id = lh.emp_id
-- Filters for only the absolute latest history record
WHERE lh.rn = 1 
  -- Evaluates if the master salary fails to match the history log
  AND e.salary <> lh.latest_history_salary
ORDER BY e.emp_id ASC;


--Running total of project budgets per department ordered by start_date. 
--SUM(budget) OVER (PARTITION BY dept_id ORDER BY start_date)

select 
 d.dept_id,
    d.dept_name,
    p.project_id,
    p.project_name,
    p.start_date,
    p.budget,
sum(p.budget) over(partition by d.dept_id order by start_date) as running_budget
from Departments d with (nolock)
inner join  Projects  p with (nolock) on d.dept_id = p.dept_id