-- Write a query to find the number of days between the longest and least 
-- tenured employee still working for the company. Your output should include 
-- the number of employees with the longest-tenure, the number of employees 
-- with the least-tenure, and the number of days between both the 
-- longest-tenured and least-tenured hiring dates.

-- since it is asking to find employees still working for the company, step 1 is to filter out the employees with termination_date.The next step is to locate the ealiest hire_date and the latest hire_date
WITH current_employees AS (
    SELECT 
        id,
        MIN(hire_date) OVER() AS date_hired
    FROM 
        uber_employees
    WHERE 
        termination_date IS NULL
    UNION ALL
    SELECT 
        id,
        MAX(hire_date) OVER()
    FROM 
        uber_employees
),
tenure_ranking AS (
    SELECT 
        id,
        date_hired,
        RANK() OVER(ORDER BY date_hired) AS ranking
    FROM 
        current_employees
)
SELECT 
    COUNT(*) FILTER(WHERE ranking = 1) AS least_tenured,
    COUNT(*) FILTER(WHERE ranking <> 1) AS most_tenured,
    MAX(date_hired) - MIN(date_hired) AS diff_in_days
FROM 
    tenure_ranking