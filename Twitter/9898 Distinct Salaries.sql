-- Find the top three distinct salaries for each department. 
-- Output the department name and the top 3 distinct salaries 
-- by each department. Order your results alphabetically 
-- by department and then by highest salary to lowest.
WITH distinct_salaries AS (
    SELECT DISTINCT department,
        salary
    FROM twitter_employee
) -- filter the duplicates first
SELECT department,
    salary
FROM (
    SELECT department,
        salary,
        RANK() OVER(PARTITION BY department ORDER BY salary DESC) as ranking
    FROM distinct_salaries
) a
WHERE ranking < 4
ORDER BY department ASC, salary DESC
-- limit will not be working in this case