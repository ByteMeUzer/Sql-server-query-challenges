select * from sys.databases order by database_id asc

use Practice

select * from Employees with(nolock) order by empid desc


select concat(fname,'',lname) as fullName, hire_date, datediff(month, hire_date, GETDATE()) / 12 as Years
from Employees with(nolock)
where month(hire_date) = 10  
order by hire_date asc


select * from Employees with(nolock) 
where salary % 1 <> 0


select city, sum(salary) as totalsalary
from Employees with(nolock) 
group by city
having count(empid) > 2
order by totalsalary desc


select * from Employees with(nolock)
where fname like '[aeiou]%'
order by fname asc


select Job_title, count(Job_title) as TotalEmp from Employees with(nolock)
where year(hire_date) between 2020 and 2022
group by Job_title
order by TotalEmp asc

with cte as 
(
	select substring(email, 1, CHARINDEX('@', email) -1) as beforusernae 
	from Employees with(nolock)
)
select * from cte
where len(beforusernae) >= 15


select fname, salary,avg(salary) over() as avgsalary, 
rank() over(partition by salary order by salary desc) as rk
from Employees with(nolock)

with cte as 
(
	select * from Employees with(nolock)
	where department in ('Tech', 'IT', 'Data', 'Engineering')
)
select fname,  department, salary from cte
order by salary desc


WITH CTE AS (
    SELECT 
        CASE WHEN department IN ('Tech', 'IT', 'Data', 'Engineering') THEN 'Core_Tech' ELSE 'Support' END AS Dept_Group,
        salary
    FROM Employees WITH(NOLOCK)
)
SELECT 
    MAX(CASE WHEN Dept_Group = 'Core_Tech' THEN salary END) AS Max_Core_Tech_Sal,
    MAX(CASE WHEN Dept_Group = 'Support' THEN salary END) AS Max_Support_Sal
FROM CTE;


with cte as 
(
	select *,
	lag(hire_date) over(order by hire_date desc) as previous_date
	from Employees with(nolock) 
	where department = 'Tech'
)
select datediff(DAY, hire_date, previous_date) as total_days, 
hire_date, previous_date, department
from cte



with cte as 
(
	select fname, city, salary,
	DENSE_RANK() over(partition by city order by salary desc) as dr
	from Employees with(nolock)
)
select * from cte
where dr = 1
order by salary desc
