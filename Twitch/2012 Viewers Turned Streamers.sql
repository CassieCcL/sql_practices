-- From users who had their first session as a viewer, how many streamer sessions 
-- have they had? Return the user id and number of sessions in descending order. 
-- In case there are users with the same number of sessions, order them by ascending 
-- user id.

-- locate users who's first sessions as a viewer
WITH user_sessions AS (
    SELECT 
        user_id,
        session_type,
        RANK() OVER(PARTITION BY user_id ORDER BY session_start ASC) AS session_order
    FROM 
        twitch_sessions
)
SELECT 
    user_id,
    COUNT(*) AS number_streamer
FROM 
    user_sessions
WHERE 
    user_id IN (
        SELECT 
        user_id
    FROM 
        user_sessions
    WHERE 
        session_order = 1
    AND 
        session_type = 'viewer'
    )
AND 
    session_type = 'streamer'
GROUP BY 
    user_id
ORDER BY 
    number_streamer DESC, user_id ASC