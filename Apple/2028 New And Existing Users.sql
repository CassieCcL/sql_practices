-- Calculate the share of new and existing users for each month in the table. Output 
-- the month, share of new users, and share of existing users as a ratio.
-- New users are defined as users who started using services in the current month 
-- (there is no usage history in previous months). Existing users are users who used 
-- services in current month, but they also used services in any previous month.
-- Assume that the dates are all from the year 2020.
-- HINT: Users are contained in user_id column

-- since all the data is from year 2020, extract the month and find the active months for each user,then the earliest active month of each user can be identified by using aggregation function.
WITH user_month AS (
    SELECT 
        DISTINCT user_id,
        EXTRACT (MONTH FROM time_id) AS active_month
    FROM 
        fact_events
    ORDER BY 
        user_id, active_month
),
user_first_month AS (
    SELECT
        *,
        MIN(active_month) OVER(PARTITION BY user_id) AS first_month 
    FROM 
        user_month
)
SELECT 
    DISTINCT a.active_month,
    new_user* 1.0 / total_user AS share_new_user,
    (total_user-new_user) * 1.0 / total_user AS share_existing_user
FROM (
    (SELECT 
        active_month,
        COUNT(user_id) OVER(PARTITION BY active_month) AS total_user
    FROM 
        user_first_month) a
    JOIN 
    (SELECT 
        active_month,
        COUNT(user_id) OVER(PARTITION BY active_month) AS new_user
    FROM 
        user_first_month
    WHERE 
        active_month = first_month) b
    ON 
        a.active_month = b.active_month
)