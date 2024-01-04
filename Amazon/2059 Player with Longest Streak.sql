-- You are given a table of tennis players and their matches that they could either 
-- win (W) or lose (L). Find the longest streak of wins. A streak is a set 
-- of consecutive won matches of one player. The streak ends once a player loses 
-- their next match. Output the ID of the player or players and the length of the streak.

-- find the start of a streak then assign a group ID for each streak
-- COALESCE() is helpful to condense the code
WITH start_streak AS (
    SELECT 
        player_id,
        match_date,
        match_result,
        CASE 
            WHEN match_result = 'W' AND COALESCE (LAG(match_result) OVER (PARTITION BY player_id ORDER BY match_date), 'L') = 'L' THEN 1
        ELSE 0 END AS new_streak
    FROM 
        players_results
),
-- By sum the new_streak will assign a unique group ID for each streak
streak_group AS (
    SELECT 
        player_id,
        match_date,
        match_result,
        SUM(new_streak) OVER (PARTITION BY player_id ORDER BY match_date) AS grp
    FROM 
        start_streak
    WHERE 
        match_result = 'W'
)
SELECT 
    player_id,
    MAX(winning_streak) AS max_winning_streak
FROM (
    SELECT 
        player_id,
        COUNT(*) AS winning_streak
    FROM 
        streak_group
    GROUP BY 
        player_id, grp 
) a 
GROUP BY 
    player_id