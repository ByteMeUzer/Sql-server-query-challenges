
use Practice

select * from Employees with(nolock) 
order by empid asc


with cte as (
select empid, department, salary,
case 
	when salary < 50000 then 'Junior'
	when salary between  50000 and 100000 then 'Mid'
	else 'Senior'
end as Category
from employees with(nolock)
)
select  department, Category, count(empid) as Total_emp  from cte 
group by department , Category
order by Category, Total_emp desc



select e1.fname, e1.department, e2.department from Employees e1 with(nolock)
join Employees e2 with(nolock) on e1.fname = e2.fname
where e1.department <> e2.department
order by fname desc

with cte as 
(
	select *,
	DENSE_RANK() over(partition by city order by hire_date desc) as dr
	from Employees  with(nolock)
)
select * from cte 
where dr = 1
order by hire_date desc


select department, salary, hire_date,
lag(salary) over(partition by department order by hire_date asc) as L
from Employees with(nolock)


with cte as 
(
	select avg(salary) as avgsalcity, city  from employees with(nolock)
	group by city
),
cte2 as
(
	select top 3 avg(salary) as avgsaldept, department  from employees with(nolock)
	group by department order by avgsaldept desc
)
select c.city, c.avgsalcity from cte c
where c.avgsalcity > (select max(c1.avgsaldept) from cte2 c1)