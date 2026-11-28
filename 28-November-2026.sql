

use Hard_Level_DB
 


select * from INFORMATION_SCHEMA.TABLES order by TABLE_SCHEMA desc

select * from Employees with(nolock)
where dept_id in (select dept_id from Departments with(nolock)
where dept_id in (select top 1  dept_id from Projects with(nolock)
order by budget desc ))

with cte as 
(
select d1.dept_name, 
sum(e1.salary) as total_salary, 
count(e1.emp_id) as total_emp,
avg(salary) as avg_salary
from Employees e1 with(nolock)
inner join Departments d1 on e1.dept_id = d1.dept_id
group by d1.dept_name
having sum(e1.salary) > 200000
)
select * from cte 


with nums as
(
select 100 as n
union all
select 100 + n from nums
where n < 105
)
select n from  nums


CREATE VIEW Max_Allocation
as
(
select sum(ep1.allocation_pct) as total_allocation, p1.project_name from Projects p1 with(nolock)
inner join  Employee_Projects ep1 with(nolock) on p1.project_id = ep1.project_id
group by p1.project_name
having sum(ep1.allocation_pct) > 100
)
go

select * from Max_Allocation
order by total_allocation desc



select d1.dept_name, p1.project_name from Departments d1 with(nolock)
inner join  Projects p1 with(nolock) on d1.dept_id = p1.dept_id
union 
select d1.dept_name, p1.project_name from Departments d1 with(nolock)
inner join  Projects p1 with(nolock) on d1.dept_id = p1.dept_id


SELECT dept_name AS item_name
FROM Departments WITH (NOLOCK)
WHERE dept_name IS NOT NULL

UNION

SELECT project_name AS item_name
FROM Projects WITH (NOLOCK)
WHERE project_name IS NOT NULL;





SELECT dept_name AS item_name
FROM Departments WITH (NOLOCK)

UNION all

SELECT project_name AS item_name
FROM Projects WITH (NOLOCK)


with cte as 
(
	select (round((sh.new_salary - sh.old_salary) / sh.old_salary  * 100, 2) ) as hike_salary,
	e.emp_id
	from Employees e with(nolock)
	inner join Salary_History sh with(nolock) on e.emp_id = sh.emp_id
)
select * from cte 
left join Employees e on cte.emp_id = e.emp_id
where hike_salary > 20