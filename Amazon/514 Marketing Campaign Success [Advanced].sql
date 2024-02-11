-- You have a table of in-app purchases by user. Users that make their first in-app 
-- purchase are placed in a marketing campaign where they see call-to-actions 
-- for more in-app purchases. Find the number of users that made additional in-app 
-- purchases due to the success of the marketing campaign.
-- The marketing campaign doesn't start until one day after the initial in-app 
-- purchase so users that only made one or multiple purchases on the first day do not 
-- count, nor do we count users that over time purchase only the products they 
-- purchased on the first day.

-- Find the first purchase date and the products purchased
WITH first_purchase AS (
    SELECT 
        DISTINCT user_id,
        created_at AS earliest_purchase,
        product_id AS first_products
    FROM 
        marketing_campaign
    WHERE (user_id, created_at) IN 
        (
        SELECT 
            user_id,
            MIN (created_at) OVER (PARTITION BY user_id)
        FROM 
            marketing_campaign
        )
    ORDER BY 
        user_id
),
-- join CTE with marketing_campaign to help identify following purchases
campaign_purchases AS (
    SELECT
        marketing_campaign.user_id,
        created_at,
        product_id,
        earliest_purchase,
        first_products
    FROM 
        marketing_campaign
    JOIN 
        first_purchase
    ON 
        marketing_campaign.user_id = first_purchase.user_id
    WHERE 
        created_at != earliest_purchase
    AND (marketing_campaign.user_id, product_id) NOT IN 
        (
            SELECT 
                user_id,
                first_products
            FROM 
                first_purchase
        )
)
-- Filter in WHERE clause of the same day purchases and also the same products purchased
-- on the first day
SELECT  
    COUNT(DISTINCT user_id)
FROM 
    campaign_purchases