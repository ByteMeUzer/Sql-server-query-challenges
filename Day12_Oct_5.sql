
use Practice

select * from Products with(nolock) order by Product_Id asc

select * from Sales with(nolock) order by Product_Id asc

select * from Products p with(nolock) 
left join Sales s on p.Product_Id = s.Product_Id


declare @empid int
set @empid = 102
select * from Employees with(nolock) 
where empid = @empid
order by empid desc


select fname from Employees with(nolock) 
union all
select fname from Employees with(nolock)


with cte as 
(
	select *,
	dense_rank() over(partition by department order by salary desc) dr
	from Employees with(nolock)
)
select department, salary from cte 
where dr = 2
order by salary desc


select e1.fname, e1.city, e1.department from Employees e1 with(nolock) 
join Employees e2 on e1.fname = e2.fname and e1.city = e2.city
where e1.department <> e2.department
order by e1.fname asc


select YEAR(hire_date)  as Years, count(empid) as Hiring_total from Employees with(nolock)
group by  YEAR(hire_date) 
order by Hiring_total desc


select 
avg(salary) over(),
 (salary - AVG(salary) OVER()) * 100.0 / AVG(salary) OVER() AS salary_percentage_variance, *
 from Employees with(nolock)

