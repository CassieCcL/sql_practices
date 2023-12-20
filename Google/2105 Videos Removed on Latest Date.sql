-- For each unique user in the dataset, find the latest date when their flags got reviewed. 
-- Then, find total number of distinct videos that were removed on that date (by any user).
-- Output the the first and last name of the user (in two columns), 
-- the date and the number of removed videos. Only include these users who had at least 
-- one of their flags reviewed by Youtube. If no videos got removed on a certain date, output 0.

--- Locate the the last day for each flag_id that has videos removed
WITH lastday_flags AS (
    SELECT 
        flag_id,
        reviewed_outcome,
        MAX(reviewed_date) AS last_review_date
    FROM 
        flag_review
    WHERE 
        reviewed_by_yt = true
    GROUP BY 
        flag_id, reviewed_outcome
),
-- join CTE lastday_flags with user_flags
videos_outcome AS (
    SELECT 
        user_firstname,
        user_lastname,
        video_id,
        lastday_flags.flag_id,
        reviewed_outcome,
        last_review_date
    FROM 
        user_flags
    JOIN 
        lastday_flags
    ON 
        user_flags.flag_id = lastday_flags.flag_id
)
SELECT 
    user_firstname,
    user_lastname,
    last_review_date,
    SUM(
        CASE 
            WHEN reviewed_outcome = 'REMOVED' THEN 1
            ELSE 0
        END ) AS totel_video_removed
FROM 
    videos_outcome
GROUP BY 
    user_firstname, user_lastname, last_review_date
-- Note: case when can be used within aggregation functions