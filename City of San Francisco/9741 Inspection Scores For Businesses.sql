-- Find the median inspection score of each business and output 
-- the result along with the business name. 
-- Order records based on the inspection score in descending order.
-- Try to come up with your own precise median calculation.
-- In Postgres there is percentile_disc function available, 
-- however it's only approximation.
WITH inspection_ranking AS (
    SELECT 
        business_name,
        inspection_score,
        ROW_NUMBER () OVER(PARTITION BY business_name ORDER BY inspection_score asc) AS number,
        COUNT(*) OVER(PARTITION BY business_name) AS total_count
    FROM
        sf_restaurant_health_violations
)
SELECT
    business_name,
    AVG(inspection_score) AS median
FROM
    inspection_ranking
WHERE
    number = CEIL(total_count/2.0)
OR 
    number = FLOOR(total_count/2.0) +1
GROUP BY
    business_name
ORDER BY
    median DESC 