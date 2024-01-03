-- The column 'perc_viewed' in the table 'post_views' denotes the percentage 
-- of the session duration time the user spent viewing a post. 
-- Using it, calculate the total time that each post was viewed by users. 
-- Output post ID and the total viewing time in seconds, 
-- but only for posts with a total viewing time of over 5 seconds.

-- calculate the session duration for each session then the time spent on viewing the post can be calculated by multiplying the session duration with perc_viewed
WITH session_duration AS (
    SELECT
        user_sessions.session_id,
        post_id,
        perc_viewed * EXTRACT(EPOCH FROM (session_endtime - session_starttime))/ 100.0 AS time_on_post
    FROM 
        user_sessions
    JOIN 
        post_views
    ON 
        user_sessions.session_id = post_views.session_id
)
-- use SUM() for total time on each post
SELECT 
    post_id,
    SUM(time_on_post) AS total_time
FROM 
    session_duration
GROUP BY 
    post_id
HAVING 
    SUM(time_on_post) > 5