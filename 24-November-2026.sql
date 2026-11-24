
use Hard_Level_DB

select * from INFORMATION_SCHEMA.TABLES order by TABLE_NAME asc


select * from Employees with(nolock) 
where salary > (select avg(salary) from Employees with(nolock))
order by salary asc


select concat(e1.fname, e1.lname) as full_name, d.dept_name, salary, 
(SELECT AVG(e2.salary) 
        FROM Employees e2 WITH (NOLOCK) 
        WHERE e2.dept_id = e1.dept_id) as avg_salary
from Employees e1 with(nolock)
inner join Departments d on e1.dept_id = d.dept_id
order by salary, d.dept_name asc


select  * from Employees e1 with(nolock) 
inner join Departments d on e1.dept_id = d.dept_id
where salary > (SELECT AVG(e2.salary) as avg_salary
        FROM Employees e2 WITH (NOLOCK) 
        WHERE e2.dept_id = e1.dept_id)




SELECT d.dept_id, d.dept_name
FROM Departments d WITH (NOLOCK)
WHERE EXISTS (
    SELECT 1 
    FROM Employees e WITH (NOLOCK) 
    WHERE e.dept_id = d.dept_id
);


select p.* from Employees e with(nolock)
right join Projects p with(nolock) on e.dept_id = p.dept_id
where e.dept_id is null




