-- Meta/Facebook's web logs capture every action from users 
-- starting from page loading to page scrolling. 
-- Find the user with the least amount of time between a page load 
-- and their scroll down. Your output should include the user id, 
-- page load time, scroll down time, 
-- and time between the two events in seconds.

-- In case there are multiple page_load, only consider the latest.
-- When there are multiple scroll_down, only consider the earliest.
-- First step to separate date and time as the same user can load facebook in different days
WITH facebook_user_log AS (
    SELECT
        user_id,
        timestamp::date AS activity_date,
        CAST(timestamp AS TIME) AS activity_time,
        action
    FROM 
        facebook_web_log
    WHERE 
        action IN ('page_load', 'scroll_down')
),
-- SELECT the earliest scroll down and the latest load on the same day, use case when to make calculating time difference easier on the next step
action_log AS(
    SELECT
        activity_date,
        user_id,
        MAX(CASE WHEN action = 'page_load' THEN activity_time ELSE NULL END) AS load_ts,
        MIN(CASE WHEN action = 'scroll_down' THEN activity_time ELSE NULL END) AS scroll_ts
    FROM facebook_user_log
    GROUP BY activity_date, user_id
)
SELECT *,
    scroll_ts - load_ts AS time_lapse
FROM 
    action_log