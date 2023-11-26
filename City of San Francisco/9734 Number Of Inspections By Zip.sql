-- Find the number of inspections that happened 
-- in the municipality with postal code 94102 during January, 
-- May or November in each year.
-- Output the count of each month separately.

-- extract the year and month, filter the business postal code with the requirement.
WITH inspections_months AS(
    SELECT
        EXTRACT (YEAR FROM inspection_date) AS year,
        EXTRACT (MONTH FROM inspection_date) AS month,
        inspection_id
    FROM 
        sf_restaurant_health_violations
    WHERE 
        business_postal_code = 94102
)
-- filter January, May and November in each year
SELECT 
    year,
    month,
    COUNT(*) OVER (PARTITION BY year, month) AS inspection_times
FROM
    inspections_months
WHERE 
    month IN (1,5,11)