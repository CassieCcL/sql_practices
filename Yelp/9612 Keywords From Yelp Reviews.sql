-- Find Yelp food reviews containing any of the keywords: 
-- 'food', 'pizza', 'sandwich', or 'burger'. 
-- List the business name, address, and the state which satisfies 
-- the requirement.

-- split the reviews into strings first
WITH reviews_table AS (
    SELECT 
        business_name,
        trim (BOTH ',.' FROM REGEXP_SPLIT_TO_TABLE(review_text, ' ')) AS key_words
    FROM 
        yelp_reviews
),
-- filter the key_words
relevant_reviews AS (
    SELECT 
        DISTINCT business_name
    FROM 
        reviews_table
    WHERE 
        key_words ILIKE '%FOOD%'
    OR 
        key_words ILIKE '%PIZZA%'
    OR 
        key_words ILIKE '%SANDWICH%'
    OR 
        key_words ILIKE '%BURGER%'
)
SELECT 
    name,
    address,
    state
FROM 
    yelp_business
WHERE 
    name IN (
        SELECT 
            business_name
        FROM 
            relevant_reviews
    )