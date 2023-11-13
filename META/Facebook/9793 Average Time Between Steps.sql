-- Find the average time (in seconds), per product, 
-- that needed to progress between steps. 
-- You can ignore products that were never used. 
-- Output the feature id and the average time.
WITH steps_per_user AS (
    SELECT 
        feature_id,
        user_id,
        timestamp - 
            LAG(timestamp) OVER(PARTITION BY feature_id, user_id ORDER BY user_id, step_reached) 
        AS time_diff
    FROM 
        facebook_product_features_realizations
)
SELECT 
    DISTINCT feature_id,
    AVG(time_diff) OVER(PARTITION BY feature_id)
FROM
    steps_per_user