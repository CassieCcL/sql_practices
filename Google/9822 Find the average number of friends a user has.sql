-- Find the average number of friends a user has.
WITH all_users AS(
    SELECT *
    FROM google_friends_network
    UNION ALL
    SELECT friend_id AS user_id1,
        user_id AS user_id2
    FROM google_friends_network
),  -- reverse the table and combine them together
friend_count AS (
    SELECT user_id,
        COUNT(*) AS num_friends
    FROM all_users
    GROUP BY user_id
)
SELECT AVG(num_friends)
FROM friend_count