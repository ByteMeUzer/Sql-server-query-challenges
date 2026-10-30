
use Hard_Level_DB

select * from INFORMATION_SCHEMA.PARAMETERS


select e.emp_id, sh.emp_id, * from Employees e with(nolock)
inner  join Salary_History sh with(nolock) on e.emp_id = sh.emp_id
inner join Employee_Projects ep with(nolock) on e.emp_id = ep.emp_id
where sh.emp_id = 105
order by sh.change_date desc



select dept_name, count(emp_id) as total_emp, CAST(ROUND(AVG(salary), 2) AS float) as avg_salary
 from Departments d with (nolock)
left join Employees e with(nolock) on d.dept_id = e.dept_id
group by dept_name
order by total_emp desc

select * from Employees with(nolock)

select * from sys.indexes

exec sp_helpindex Employees

select e.emp_id, fname, lname, d.dept_name from Employees e with(nolock)
left join Employee_Projects ep with(nolock) on  e.emp_id = ep.emp_id
left join Departments d with(nolocK) on e.dept_id = d.dept_id
where ep.emp_id is null


select e.* from Projects p with(nolock)
right join Employees e with(nolock) on p.dept_id = e.dept_id 
where p.dept_id is null


SELECT p.* 
FROM Projects p WITH(NOLOCK)
LEFT JOIN Employees e WITH(NOLOCK) ON p.dept_id = e.dept_id 
WHERE e.dept_id IS NULL


select * from Employees e with(nolock) 
full outer join  Departments d with(nolock) on e.dept_id = d.dept_id
where d.dept_id is null
or e.dept_id is null




