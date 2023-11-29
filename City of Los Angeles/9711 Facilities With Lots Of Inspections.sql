-- Find the facility that got the highest number of inspections 
-- in 2017 compared to other years. 
-- Compare the number of inspections per year and output 
-- only facilities that had the number of inspections greater 
-- in 2017 than in any other year.
-- Each row in the dataset represents an inspection. 
-- Base your solution on the facility name and activity date fields.

-- Extract the year
WITH inspection_peryear AS (
    SELECT 
        EXTRACT (YEAR FROM activity_date) AS activity_year,
        facility_name
    FROM 
        los_angeles_restaurant_health_inspections
),
-- Decide the number of inspections per year for each facility
inspection_counts AS (
    SELECT
        DISTINCT activity_year,
        facility_name,
        COUNT(*) OVER(PARTITION BY activity_year, facility_name) AS inspection_num
    FROM
        inspection_peryear
),
-- Identify those facilities with highest numbers of inspections in 2017
highest_year AS (
    SELECT 
        activity_year,
        facility_name,
        inspection_num,
        RANK() OVER(PARTITION BY facility_name ORDER BY inspection_num DESC) AS ranking
    FROM
        inspection_counts
)
SELECT 
    facility_name,
    inspection_num
FROM 
    highest_year
WHERE
    activity_year = 2017
AND 
    ranking = 1