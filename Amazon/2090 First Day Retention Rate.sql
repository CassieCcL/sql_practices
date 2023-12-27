-- Calculate the first-day retention rate of a group of video game players. 
-- The first-day retention occurs when a player logs in 1 day after their first-ever log-in.
-- Return the proportion of players who meet this definition divided by 
-- the total number of players.

-- find the next dates then decide if it equals to the next log in date, if yes then we have a retention
WITH next_logins AS (
    SELECT  
        player_id,
        login_date+1 AS next_date
    FROM 
        players_logins
),
logins_match AS (
    SELECT 
        next_logins.player_id AS retention_player,
        login_date,
        next_date
    FROM 
        players_logins
    JOIN 
        next_logins
    ON 
        players_logins.player_id = next_logins.player_id
    AND 
        players_logins.login_date = next_logins.next_date
)
-- Find the number of players who logged in on the next day divided by total players
SELECT 
    COUNT(DISTINCT retention_player)*1.0 / COUNT(DISTINCT player_id) AS retention_ratio
FROM 
    players_logins a
LEFT JOIN 
    logins_match b
ON 
    a.player_id = b.retention_player