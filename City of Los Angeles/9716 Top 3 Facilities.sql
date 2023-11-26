-- Find the top 3 facilities for each owner. 
-- The top 3 facilities can be identified using the highest 
-- average score for each owner name and facility address grouping.
-- The output should include 4 columns: 
-- owner name, top 1 facility address, top 2 facility address, 
-- and top 3 facility address. 
-- Order facilities with the same score alphabetically.

-- use AVG() window function for each owner name and facility address grouping.
WITH highest_score AS (
    SELECT 
        DISTINCT owner_name,
        facility_address,
        AVG(score) OVER(PARTITION BY owner_name,facility_address) AS avg_score
    FROM 
        los_angeles_restaurant_health_inspections
    ORDER BY 
        owner_name, avg_score DESC, facility_address
),
-- add ranking to the table
score_ranking AS (
    SELECT
        *,
        ROW_NUMBER()OVER(PARTITION BY owner_name ORDER BY avg_score DESC) AS ranking 
    FROM
        highest_score
)
-- lay out the owner name and the corresponding facility_address as top 1,2,3
SELECT
    owner_name,
    MAX(CASE WHEN ranking = 1 THEN facility_address END) AS top_1_facility,
    MAX(CASE WHEN ranking = 2 THEN facility_address ELSE NULL END) AS top_2_facility,
    MAX(CASE WHEN ranking = 3 THEN facility_address ELSE NULL END) AS top_3_facility
FROM 
    score_ranking
GROUP BY 
    owner_name
-- the use of MAX() and GROUP BY() to make sure the output for the same
-- ower are on the same row