-- Write a query that returns every employee that has ever worked for the company. 
-- For each employee, calculate the greatest number of employees that worked for 
-- the company during their tenure and the first date that number was reached. 
-- The termination date of an employee should not be counted as a working day.
-- Your output should have the employee ID, greatest number of employees that 
-- worked for the company during the employee's tenure, and first date 
-- that number was reached.

-- find the number of employees at a certain date
WITH number_employees AS (
    SELECT 
        DISTINCT aqdate,
        SUM(number) OVER (ORDER BY aqdate) AS employee_no
    FROM (
        SELECT 
            hire_date AS aqdate,
            1 AS number
        FROM 
            uber_employees
        UNION ALL
        SELECT 
            termination_date,
            -1
        FROM 
            uber_employees
        WHERE 
            termination_date IS NOT NULL 
    ) a
    ORDER BY aqdate
),
-- join with uber_employees to have aqdate falls within hire_date and termination_date
max_employee AS (
    SELECT 
        DISTINCT id,
        aqdate,
        MAX(employee_no) OVER(PARTITION BY id ORDER BY aqdate) AS employee_no
    FROM 
        number_employees
    JOIN 
        uber_employees
    ON 
        aqdate BETWEEN hire_date AND COALESCE(termination_date, '2999-01-01')
    ORDER BY 
        id 
),
unique_max AS (
    SELECT 
        id,
        MAX(employee_no) AS max_emp
    FROM 
        max_employee
    GROUP BY 
        id
)
SELECT 
    DISTINCT unique_max.id,
    MIN(aqdate) OVER(PARTITION BY unique_max.id),
    max_emp
FROM 
    unique_max
JOIN 
    max_employee
ON 
    unique_max.id = max_employee.id
AND 
    max_emp = employee_no