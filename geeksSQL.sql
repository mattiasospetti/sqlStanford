create database geeksExdb;

CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary INT
);

INSERT INTO employees (id, name, salary) VALUES
(1, 'Alice', 3000),
(2, 'Bob', 4000),
(3, 'Charlie', 5000),
(4, 'Diana', 4000),
(5, 'Edward', 6000),
(6, 'Fiona', 6000),
(7, 'George', 2000);

select * from employees;

-- Write a query to find the second-highest salary of an employee in a table.
select max(salary) from employees
where salary < ( select max(salary) from employees);

-- Write a query to retrieve employees who earn more than the average salary.
select e.id, e.name, e.salary, floor(avg(salary)) from employees e
group by e.id
having e.salary >
(select avg(salary) from employees);

-- Write a query to fetch the duplicate values from a column in a table.

select salary from employees e1
    where salary in
    (select salary from employees e2 where e2.id <> e1.id);

drop procedure if exists procName;
delimiter //
create procedure procName(col CHAR(100))
begin
	select e1.col from employees e1
    where e1.col in
    (select col from employees e2 where e2.id <> e1.id);
end//

-- call procName(salary);  -- NON FUNZIONA --> NON SUPPORTATO IN MYSQL

SELECT salary, COUNT(*)
FROM employees
GROUP BY salary
HAVING COUNT(*) > 1;

-- Write a query to find the employees who joined in the last 30 days.

select * from employees
where datediff(curdate(),joiningDate) < 30;

-- Write a query to fetch top 3 earning employees.

select * from employees
order by salary desc
limit 3;

-- Write a query to delete duplicate rows in a table without using the ROWID keyword

INSERT INTO employees (id, name, salary) VALUES
(8, 'Alice', 3000),
(9, 'Bob', 4000);

with cte1 as (SELECT MIN(id)
   FROM employees
   GROUP BY name, salary)
DELETE FROM employees
WHERE id NOT IN (
select * from cte1
);


-- Write a query to fetch common records from two tables
CREATE TABLE employees2 (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary INT
);

INSERT INTO employees2 (id, name, salary) VALUES
(1, 'Alice', 3000),
(2, 'Bob', 4000),
(3, 'Charlie', 5000),
(4, 'Diana', 4000),
(5, 'Edward', 6000),
(6, 'Fiona', 6000),
(7, 'George', 2000);

select * from employees e1
join employees2 e2 on e1.name=e2.name and e1.salary=e2.salary;  -- supponendo che gli id siano diversi

-- Write a query to fetch employees whose names start and end with ‘A’.

select name from employees
where name like 'A%' and name like '%A';

-- Write a query to display all departments along with the number of employees in each.

ALTER TABLE employees
ADD COLUMN dept_id INT;

CREATE TABLE departments (
    id INT PRIMARY KEY,
    name VARCHAR(100)
);

INSERT INTO departments (id, name) VALUES
(1, 'HR'),
(2, 'Engineering'),
(3, 'Sales'),
(4, 'Marketing');

UPDATE employees SET dept_id = 2 WHERE name = 'Alice';
UPDATE employees SET dept_id = 2 WHERE name = 'Bob';
UPDATE employees SET dept_id = 1 WHERE name = 'Charlie';
UPDATE employees SET dept_id = 3 WHERE name = 'Diana';
UPDATE employees SET dept_id = 3 WHERE name = 'Edward';
UPDATE employees SET dept_id = 4 WHERE name = 'Fiona';
UPDATE employees SET dept_id = 1 WHERE name = 'George';

select * from departments;

select depts.name, count(*)
from employees
join departments depts on depts.id = employees.dept_id
group by depts.name;

-- Write a query to find employees who do not have managers.
alter table employees
add column manager_id INT;

UPDATE employees SET manager_id = 2 WHERE name = 'Alice';
UPDATE employees SET manager_id = 2 WHERE name = 'Bob';
UPDATE employees SET manager_id = 1 WHERE name = 'Charlie';
UPDATE employees SET manager_id = 3 WHERE name = 'Diana';
UPDATE employees SET manager_id = 3 WHERE name = 'Edward';
UPDATE employees SET manager_id = 4 WHERE name = 'Fiona';
UPDATE employees SET manager_id = 1 WHERE name = 'George';

select * from employees
where manager_id is null;

-- Write a query to fetch the 3rd and 4th highest salaries.

WITH SalaryRank AS (
    SELECT salary, RANK() OVER (ORDER BY salary DESC) AS miorank
    FROM employees
)
SELECT salary
FROM SalaryRank
WHERE miorank IN (3, 4);

-- Write a query to fetch records updated within the last hour.

DELIMITER //

CREATE TRIGGER nameTrigger
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    SET NEW.updateTime = NOW();  -- use procedures to avoid code repetition
END//

CREATE TRIGGER nameTrigger2
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
    SET NEW.updateTime = NOW();
END//

DELIMITER ;

select * from employees e
where datediff('hour', NOW(), e.updateTime) < 1;  -- NB: currdate is only the date, now gives also the time

-- Write a query to list employees in departments that have fewer than 5 employees.

select * from employees
where employees.dept_id in (
select dept_id from employees
group by employees.dept_id
having count(*)<5);

-- Write a query to check if a table contains any records.
delimiter //

create procedure proc1 (tableName CHAR(100))  -- NON FUNZIONA In SQL statico (come quello dentro le procedure), non puoi usare un parametro per rappresentare un nome di tabella o colonna.
begin
	select CASE
		when exists (select 1 from tableName) then True
		else False
	end as Status;
end//

create table tableName(
id INT primary key);

select CASE
	when exists (select 1 from tableName) then True
	else False
end as Status;

-- Write a query to find employees whose salaries are higher than their managers

CREATE TABLE managers (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary INT,
    department_id INT
);

INSERT INTO managers (id, name, salary, department_id) VALUES
(1, 'Francesca Rossi', 7000, 1),
(2, 'Luca Bianchi', 8000, 2),
(3, 'Giulia Verdi', 7500, 3),
(4, 'Marco Neri', 7200, 4),
(5, 'Elena Fontana', 7800, 5);

INSERT INTO managers (id, name, salary, department_id) VALUES
(6, 'AAA', 150, 3);

select * from managers;

update employees
set manager_id=6
where id=1;

select * from employees
join managers on managers.id=employees.manager_id
where employees.salary>managers.salary;

-- Write a query to fetch alternating rows from a table.

select id, name, salary, rank() over (order by id) as numero
from employees
where numero % 2 = 0; -- NUMERO NON VIENE VISTO --> LE WINDOW FUNCTIONS VENGONO CALCOLATE DOPO LA WHERE

with tmp as (
	select id, name, salary, rank() over (order by id) as numero
	from employees
    )
select * from tmp
where
numero % 2 = 0;

-- Write a query to find departments with the highest average salary.

SELECT DepartmentID
FROM Employee
GROUP BY DepartmentID
ORDER BY AVG(Salary) DESC
LIMIT 1;

-- Write a query to fetch the nth record from a table.

DELIMITER //

CREATE PROCEDURE procN (IN param INT)
BEGIN
    WITH tmp AS (
        SELECT id, name, salary, RANK() OVER (ORDER BY id) AS numero
        FROM employees
    )
    SELECT * FROM tmp
    WHERE numero = param;
END//

DELIMITER ;

call procN(10);

-- Write a query to find employees hired in the same month of any year.

select * from employees
where exists (
select 1 from employees e2
where month(e2.hiringDate)=month(employees.hiringDate) and e2.id <> employees.id);