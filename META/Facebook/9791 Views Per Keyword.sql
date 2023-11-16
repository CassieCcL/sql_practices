-- Create a report showing how many views each keyword has. 
-- Output the keyword and the total views, 
-- and order records with highest view count first.

-- Key words that showed up in each post
WITH keywords_post AS (
    SELECT 
        post_id,
        trim(both '[' FROM trim(both ']' FROM REGEXP_SPLIT_TO_TABLE(post_keywords, ','))) AS words
    FROM 
        facebook_posts
),
-- How many times a post got looked at 
post_views AS (
    SELECT 
        DISTINCT post_id,
        COUNT(viewer_id) OVER(PARTITION BY post_id) AS post_counts
    FROM 
        facebook_post_views
),
-- join the 2 CTE to get the total views of each word
words_views AS (
    SELECT
        keywords_post.post_id,
        words,
        post_counts
    FROM 
        keywords_post LEFT JOIN post_views
    ON 
        keywords_post.post_id = post_views.post_id
)
-- add up the counts, partition by words
SELECT 
    words,
    SUM(post_counts) OVER(PARTITION BY words) AS view_of_words
FROM words_views
WHERE post_counts IS NOT NULL
ORDER BY view_of_words desc