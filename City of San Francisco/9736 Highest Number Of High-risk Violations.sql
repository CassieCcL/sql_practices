-- Find details of the business with the highest number of 
-- high-risk violations. Output all columns from the dataset 
-- considering business_id which consist 'high risk' phrase 
-- in risk_category column.

-- Locate all the high-risk violations along with corresponding businesses
WITH highrisk_violation AS (
    SELECT 
        *,
        COUNT(*) OVER(PARTITION BY business_id) AS number_violations
    FROM 
        sf_restaurant_health_violations
    WHERE 
        risk_category = 'High Risk'
)
-- Order the results, and select the highest
SELECT *
FROM 
    highrisk_violation
ORDER BY 
    number_violations DESC
LIMIT 1