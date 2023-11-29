-- Find the latest inspection date for the most sanitary restaurant(s). 
-- Assume the most sanitary restaurant is the one with the highest number 
-- of points received in any inspection (not just the last one). 
-- Only businesses with 'restaurant' in the name should be 
-- considered in your analysis.
-- Output the corresponding facility name, inspection score, 
-- latest inspection date, previous inspection date, 
-- and the difference between the latest and previous inspection dates. 
-- And order the records based on the latest inspection date 
-- in ascending order.

-- calculate the 4 quartile for each business
WITH business_quartile AS (
    SELECT 
        facility_name,
        score,
        NTILE(4) OVER (PARTITION BY facility_name ORDER BY score ASC) AS quartiles
    FROM 
        los_angeles_restaurant_health_inspections
),
score_quartile AS (
    SELECT 
        facility_name,
        MIN(score) AS mini,
        MAX (CASE WHEN quartiles = 1 THEN score END) AS first_quartile,
        MAX (CASE WHEN quartiles = 2 THEN score END) AS median,
        MAX (CASE WHEN quartiles = 3 THEN score END) AS third_quartile,
        MAX(score) AS maxi
    FROM 
        business_quartile
    GROUP BY 
        facility_name
)
-- Get the average
SELECT 
    *,
    (mini+first_quartile+median+third_quartile+maxi)/6.0 AS avg_score
FROM 
    score_quartile
ORDER BY 
    avg_score ASC