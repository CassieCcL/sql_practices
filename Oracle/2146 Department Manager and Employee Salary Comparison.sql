-- Oracle is comparing the monthly wages of their employees 
-- in each department to those of their managers and co-workers.
-- You have been tasked with creating a table that compares an employee's 
-- salary to that of their manager and to the average salary 
-- of their department.
-- It is expected that the department manager's salary and 
-- the average salary of employee's from that department are in their 
-- own separate column.
-- Order the employee's salary from highest to lowest based on 
-- their department.
-- Your output should contain the department, employee id, 
-- salary of that employee, salary of that employee's manager and 
-- the average salary from employee's within that department rounded 
-- to the nearest whole number.
-- Note: Oracle have requested that you not include the department 
-- manager's salary in the average salary for that department 
-- in order to avoid skewing the results. 
-- Managers of each department do not report to anyone higher up; 
-- they are their own manager.

-- Filter out the managers first, then calculate the average of each deparment
WITH avg_salary AS (
    SELECT 
        department,
        ROUND(AVG(salary) OVER (PARTITION BY department)) AS department_avg
    FROM 
        employee_o
    WHERE 
        employee_title NOT LIKE '%Manager%'
),
-- Filter the regular empolyee salary
regular_salary AS (
    SELECT
        DISTINCT id,
        department,
        salary
    FROM 
        employee_o
    WHERE 
        employee_title <> 'Manager'
)
-- use join to join the average table with the original table
SELECT 
    DISTINCT avg_salary.department,
    id,
    salary,
    department_avg,
    manager_salary
FROM 
    regular_salary
JOIN 
    avg_salary
ON 
    regular_salary.department = avg_salary.department
JOIN 
    (SELECT
        department,
        salary AS manager_salary
    FROM 
        employee_o
    WHERE 
        employee_title = 'Manager'
    ) a 
ON 
    regular_salary.department = a.department
ORDER BY 
    department_avg DESC 