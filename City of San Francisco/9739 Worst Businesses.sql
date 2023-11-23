-- For every year, find the worst business in the dataset. 
-- The worst business has the most violations during the year. 
-- You should output the year, 
-- business name, and number of violations.

-- Extract year first
-- Also noticed some visits do not have scores, those are not for inspection
WITH business_violation AS (
    SELECT 
        EXTRACT (YEAR FROM inspection_date) AS inspection_year,
        business_name,
        inspection_score
    FROM 
        sf_restaurant_health_violations
    WHERE
        inspection_score IS NOT NULL
    AND 
        inspection_score != 100
),
violation_count AS (
    SELECT
        inspection_year,
        business_name,
        COUNT(*)OVER(PARTITION BY inspection_year, business_name) AS violation_times
    FROM
        business_violation
),
violation_ranking AS (
    SELECT
        inspection_year,
        business_name,
        violation_times,
        RANK () OVER (PARTITION BY inspection_year ORDER BY violation_times DESC) as ranking 
    FROM
        violation_count
)
SELECT
    DISTINCT inspection_year,
    business_name,
    violation_times
FROM
    violation_ranking
WHERE 
    ranking = 1