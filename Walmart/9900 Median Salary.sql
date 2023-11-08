
-- Find the median employee salary of each department.
-- Output the department name along with the corresponding salary 
-- rounded to the nearest whole dollar.
WITH department_salaries AS (
    SELECT department,
        salary,
        ROW_NUMBER() OVER(PARTITION BY department ORDER BY salary DESC) AS rows,
        COUNT(*) OVER(PARTITION BY department) AS total_num_employees
    FROM employee
)  -- There is no median window function. Rank the salaries by using ROW_NUMBER() instead of
-- RANK() to avoid ties in the ranking, which will be difficult 
-- to locate the middle rows.
SELECT department,
    ROUND(AVG(salary)) AS median_salary
FROM department_salaries
WHERE rows = CEIL(total_num_employees/2.0)
OR rows = FLOOR(total_num_employees/2.0) + 1
GROUP BY department