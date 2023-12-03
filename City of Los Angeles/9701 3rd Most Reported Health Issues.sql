-- Each record in the table is a reported health issue 
-- and its classification is categorized by the facility type, 
-- size, risk score which is found in the pe_description column.
-- If we limit the table to only include businesses with Cafe, 
-- Tea, or Juice in the name, 
-- find the 3rd most common category (pe_description). 
-- Output the name of the facilities that contain 3rd most common category.

-- filter the table with Cafe, Tea, or Juice in the name
WITH filtered_business AS (
    SELECT 
        facility_name,
        pe_description
    FROM 
        los_angeles_restaurant_health_inspections
    WHERE 
        facility_name ILIKE '%cafe%'
    OR 
        facility_name ILIKE '%tea%'
    OR 
        facility_name ILIKE '%juice%'
),
-- 3rd most common category should be located by using COUNT()
description_ranking AS (
    SELECT 
        pe_description,
        facility_num,
        RANK() OVER(ORDER BY facility_num  DESC) as ranking
    FROM (
        SELECT
            pe_description,
            COUNT(*) AS facility_num
        FROM 
            filtered_business
        GROUP BY 
            pe_description
        ) a 
)
-- Choose the facilities in the 3rd ranking position
SELECT
    facility_name,
    pe_description
FROM 
    filtered_business
WHERE 
    pe_description IN (
        SELECT 
            pe_description
        FROM 
            description_ranking
        WHERE 
            ranking = 3
    )