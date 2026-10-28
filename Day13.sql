
use Practice

select * from Employees with(nolock)
order by empid desc


select department, avg(salary) as avg_salary, count(empid) as total_emp
from Employees with(nolock)
group by department
having avg(salary) > 90000
order by total_emp, avg_salary asc



select email from Employees with(nolock)
group by email
having count(email) > 1



WITH CTE AS 
(
	SELECT *,
	DENSE_RANK() OVER(PARTITION BY CITY ORDER BY SALARY DESC) DR
	FROM EMPLOYEES WITH(NOLOCK)
)
SELECT * FROM CTE 
WHERE DR = 2
ORDER BY CITY DESC



select department, count(empid) as total_emp from Employees with(nolock)
where year(hire_date) = 2025
group  by department 
order by total_emp desc



select * from Employees e1 with(nolock)
where salary > (select AVG(salary) from Employees e2 where  e1.department = e2.department )