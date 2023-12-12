
-- An event is logged in the events table with a timestamp 
-- each time a new rider attempts a signup (with an event name 'attempted_su') 
-- or successfully signs up (with an event name of 'su_success').
-- For each city and date, determine the percentage of 
-- successful signups in the first 7 days of 2022 that 
-- completed a trip within 168 hours of the signup date. 
-- HINT: driver id column corresponds to rider id column

-- Filter the successful sign-ups withihin the first 7 days
WITH signup_success AS (
    SELECT 
        rider_id,
        city_id,
        timestamp AS signup_date
    FROM 
        signup_events
    WHERE 
        timestamp < '2022-01-08 00:00:00'
    AND 
        event_name = 'su_success'
),
-- Now filter the successful signups also completed a trip within 168 hours of the signup date by join 
-- signup_success with trip_details. actual_time_of_arrival will be used as the completion time.
completion_results AS (
    SELECT 
        rider_id,
        signup_success.city_id,
        signup_date,
        completion_time
    FROM 
        signup_success
    LEFT JOIN (
        SELECT 
            driver_id,
            city_id, 
            actual_time_of_arrival AS completion_time
        FROM 
            trip_details
        WHERE 
            status = 'completed'
    ) b 
    ON 
        b.driver_id = signup_success.rider_id
    AND
        EXTRACT (EPOCH FROM completion_time - signup_date)/3600.0 <= 168
)
SELECT 
    city_id,
    DATE(signup_date) AS date,
    COUNT(DISTINCT rider_id) FILTER(WHERE completion_time IS NOT NULL) *1.0/ COUNT(DISTINCT rider_id) AS rate
FROM 
    completion_results
GROUP BY
    1,2
ORDER BY 
    1,2