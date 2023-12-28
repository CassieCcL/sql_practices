-- Find stores that were opened in the second half of 2021 with more than 20% 
-- of their reviews being negative. A review is considered negative 
-- when the score given by a customer is below 5. 
-- Output the names of the stores together with the ratio of negative reviews 
-- to positive ones.

-- Find the number of total reviews and the number of negative reviews
WITH negative_total AS (
    SELECT 
        store_id,
        COUNT(*) AS total_reviews,
        COUNT(*) FILTER(WHERE score<5) AS negative_reviews,
        COUNT(*) FILTER(WHERE score<5)* 1.0 / COUNT(*) AS negative_ratio
    FROM 
        instacart_reviews
    GROUP BY 
        store_id
)
-- locate stores with more than 20% negative reviews and join with instacart_reviews to find the store names
SELECT 
    name,
    negative_reviews * 1.0 / (total_reviews - negative_reviews) AS negative_positive_ratio
FROM 
    negative_total
JOIN 
    instacart_stores
ON 
    negative_total.store_id = instacart_stores.id
WHERE 
    negative_ratio > 0.2