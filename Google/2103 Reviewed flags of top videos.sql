-- For the video (or videos) that received the most user flags, 
-- how many of these flags were reviewed by YouTube? Output the video ID 
-- and the corresponding number of reviewed flags.

-- identify the numbers of reviews for each flag
WITH yt_flag AS (
    SELECT 
        flag_id,
        COUNT(*) AS reviewed_number
    FROM 
        flag_review
    WHERE 
        reviewed_by_yt = true
    GROUP BY 
        flag_id
)
-- join flag_review with CTE to get video and its corresponding flag id
SELECT 
    video_id,
    SUM(reviewed_number) AS total_reviews
FROM 
    user_flags
JOIN 
    yt_flag
ON 
    user_flags.flag_id = yt_flag.flag_id
GROUP BY 
    video_id