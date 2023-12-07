-- You’re given a table of rental property searches by users. 
-- The table consists of search results and outputs host information 
-- for searchers. Find the minimum, average, maximum rental prices 
-- for each host’s popularity rating. 
-- The host’s popularity rating is defined as below:
-- 0 reviews: New
-- 1 to 5 reviews: Rising
-- 6 to 15 reviews: Trending Up
-- 16 to 40 reviews: Popular
-- more than 40 reviews: Hot
-- Tip: The id column in the table refers to the search ID. 
-- You'll need to create your own host_id by concating price, 
-- room_type, host_since, zipcode, and number_of_reviews.
-- Output host popularity rating and their minimum, average 
-- and maximum rental prices.

-- The same price, room_type, host_since date, zipcode and number_of_reviews will be 
-- considered as the same host.
WITH unique_hosts AS (
    SELECT
        DISTINCT price,
        room_type,
        host_since,
        zipcode,
        number_of_reviews
    FROM 
        airbnb_host_searches
),
review_classification AS (
    SELECT 
        CASE 
            WHEN number_of_reviews = 0 THEN 'New'
            WHEN number_of_reviews <= 5 THEN 'Rising'
            WHEN number_of_reviews <= 15 THEN 'Trending Up'
            WHEN number_of_reviews <= 40 THEN 'Popular'
            ELSE 'Hot'
        END AS popular_rating,
        price
    FROM 
        unique_hosts
)
SELECT 
    DISTINCT popular_rating,
    MIN(price) OVER (PARTITION BY popular_rating) AS minimum,
    MAX(price) OVER (PARTITION BY popular_rating) AS maximum,
    AVG(price) OVER (PARTITION BY popular_rating) AS average
FROM 
    review_classification