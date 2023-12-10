-- Given the users' sessions logs on a particular day, 
-- calculate how many hours each user was active that day.
-- Note: The session starts when state=1 and ends when state=0.

-- In cases where not all the sessions were ordered like this, and where the state of sessions were
-- not marked as "0"s and "1"s, necessary to give find the beginning and end of each session. 
-- Give them 0s and 1s will be easier for calculating for the next steps.
WITH start_end AS (
    SELECT 
        cust_id,
        state,
        timestamp,
        CASE
            WHEN state = 1 AND LAG(state) OVER (PARTITION BY cust_id ORDER BY timestamp) IS DISTINCT FROM 1 THEN 1
            ELSE 0
        END AS session_start
    FROM
        cust_tracking
),
session_tracking AS (
    SELECT 
        cust_id,
        state,
        timestamp,
        SUM (session_start) OVER (PARTITION BY cust_id ORDER BY timestamp) AS session_group
    FROM 
        start_end
),
-- calculate the time duration for each session 
session_duration AS (
    SELECT 
        cust_id,
        EXTRACT (EPOCH FROM MAX (timestamp:: time) - MIN (timestamp :: time)) /3600.0 AS duration
    FROM 
        session_tracking
    GROUP BY 
        cust_id, session_group
)
-- add the duration together for each user
SELECT 
    cust_id,
    SUM(duration) AS total_time
FROM 
    session_duration
GROUP BY 
    cust_id
ORDER BY 
    total_time