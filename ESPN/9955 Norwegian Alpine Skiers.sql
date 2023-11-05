-- Find all Norwegian alpine skiers who participated in 1992 
-- but didn't participate in 1994. Output unique athlete names.
WITH Norwegian_skiiers_1992 AS (
    SELECT name
    FROM olympics_athletes_events
    WHERE sport = 'Alpine Skiing'
    AND team = 'Norway'
    AND year = 1992
),
Norwegian_skiiers_1994 AS (
    SELECT name
    FROM olympics_athletes_events
    WHERE sport = 'Alpine Skiing'
    AND team = 'Norway'
    AND year = 1994
)
SELECT DISTINCT name 
FROM Norwegian_skiiers_1992
WHERE name NOT IN (
    SELECT name
    FROM Norwegian_skiiers_1994
)