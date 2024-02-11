-- Which countries have risen in the rankings based on the number of comments 
-- between Dec 2019 vs Jan 2020? Hint: Avoid gaps between ranks when ranking countries.

-- Extract date for Dec 2019 and Jan 2020 and the countries as well as their correspondent number of comments
WITH comments_2019 AS (
    SELECT 
        DISTINCT country,
        CONCAT(EXTRACT (YEAR FROM created_at), EXTRACT (MONTH FROM created_at)) AS comment_time,
        SUM(number_of_comments) OVER(PARTITION BY country) AS total_comments
    FROM 
        fb_comments_count
    JOIN 
        fb_active_users
    ON 
        fb_comments_count.user_id = fb_active_users.user_id
    WHERE 
        EXTRACT (YEAR FROM created_at) = 2019
    AND 
        EXTRACT (MONTH FROM created_at) = 12
),
comments_2020 AS (
    SELECT 
        DISTINCT country,
        CONCAT(EXTRACT (YEAR FROM created_at), EXTRACT (MONTH FROM created_at)) AS comment_time,
        SUM(number_of_comments) OVER(PARTITION BY country) AS total_comments
    FROM 
        fb_comments_count
    JOIN 
        fb_active_users
    ON 
        fb_comments_count.user_id = fb_active_users.user_id
    WHERE 
        EXTRACT (YEAR FROM created_at) = 2020
    AND 
        EXTRACT (MONTH FROM created_at) = 01
),
-- Join 2 CTEs together to compare the comments
comments_compare AS (
    SELECT 
        a.country,
        b.total_comments - a.total_comments AS comments_increase
    FROM 
        comments_2019 a
    JOIN 
        comments_2020 b 
    ON
        a.country = b.country
)
SELECT 
    country,
    DENSE_RANK() OVER (ORDER BY comments_increase DESC) AS ranking
FROM 
    comments_compare