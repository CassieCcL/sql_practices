-- Select the most popular client_id based on a count of the number of users 
-- who have at least 50% of their events from the following list: 'video call received', 
-- 'video call sent', 'voice call received', 'voice call sent'.

-- First step: find out the users who have at least 50% of their events in 'video call received', 'video call sent', 'voice call received', 'voice call sent'.
WITH user_event AS (
    SELECT
        user_id,
        COUNT(user_id) FILTER(WHERE event_type IN ('video call received', 'video call sent', 'voice call received', 'voice call sent'))*1.0/ COUNT(*) AS event_percentage
    FROM 
        fact_events
    GROUP BY 
        user_id
    HAVING 
        COUNT(user_id) FILTER(WHERE event_type IN ('video call received', 'video call sent', 'voice call received', 'voice call sent'))*1.0/ COUNT(*) >= 0.5
)
SELECT 
    client_id,
    COUNT(*) AS count_client
FROM 
    fact_events
WHERE
    user_id IN (
        SELECT
            user_id
        FROM 
            user_event
    )
GROUP BY 
    client_id
ORDER BY 
    count_client DESC
LIMIT 1