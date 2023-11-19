-- Count the subpopulations across datasets. 
-- Assume that a subpopulation is a group of users sharing a common interest 
-- (ex: Basketball, Food). Output the percentage of overlapping interests 
-- for two posters along with those poster's IDs. 
-- Calculate the percentage from the number of poster's interests. 
-- The poster column in the dataset refers to the user that posted 
-- the comment.

-- change the column post_keywords into array, and filter spam posts out
WITH interest_posts AS (
    SELECT 
        poster,
        trim(both '][' FROM REGEXP_SPLIT_TO_TABLE(post_keywords, ',')) AS interests
    FROM 
        facebook_posts
    WHERE 
        post_keywords NOT LIKE '%spam%'
),
-- self-join but use poster1 != poster2 to find the same interests
poster_posts AS (
    SELECT 
        ip1.poster AS poster1,
        ip2.poster AS poster2,
        ip1.interests AS interest1,
        ip2.interests AS interest2
    FROM
        interest_posts ip1
    JOIN
        interest_posts ip2 ON ip1.poster != ip2.poster
)
SELECT 
    poster1,
    poster2,
    COUNT(CASE WHEN interest1 = interest2 THEN TRUE END) * 1.0/
        GREATEST (COUNT(DISTINCT interest1), COUNT(DISTINCT interest2)) * 100 AS overlap_percentage
FROM 
    poster_posts
GROUP BY 
    poster1, poster2