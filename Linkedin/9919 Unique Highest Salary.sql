-- Find the highest salary among salaries that appears only once.
WITH unique_salaries AS (
    SELECT salary,
        COUNT(salary)
    FROM employee
    GROUP BY salary
)
SELECT MAX(salary)
FROM (SELECT salary
        FROM unique_salaries
        WHERE count=1) a