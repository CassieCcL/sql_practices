-- Find the variance of scores that have grade A using 
-- the formula AVG((X_i - mean_x) ^ 2).
-- Output the result along with the corresponding standard deviation.

-- Filter the grade A rating and get the avg
WITH gradeA_rest AS (
    SELECT 
        facility_name,
        score,
        AVG (score) OVER(PARTITION BY grade) AS avg_score
    FROM
        los_angeles_restaurant_health_inspections
    WHERE 
        grade = 'A'
),
variance_score AS (
    SELECT 
        (score - avg_score) ^ 2 AS a 
    FROM 
        gradeA_rest
)
-- find the variance and the standard deviation
SELECT 
    AVG(a) AS variance,
    AVG(a)^0.5 AS standard_dev
FROM 
    variance_score