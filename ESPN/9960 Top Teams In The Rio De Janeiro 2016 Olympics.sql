-- Find the top 3 medal-winning teams by counting the total number of 
-- medals for each event in the Rio De Janeiro 2016 olympics. In case 
-- there is a tie, order the countries by name in ascending order. 
-- Output the event name along with the top 3 teams as the 
-- 'gold team', 'silver team', and 'bronze team', with the team name 
-- and the total medals under each column in format
--  "{team} with {number of medals} medals". Replace NULLs with "No Team" 
--  string.
WITH olympics_2016 AS (
    SELECT team,
        event,
        COUNT(*) OVER (PARTITION BY team, event) AS medals_count
    FROM olympics_athletes_events
    WHERE year = 2016
    AND city = 'Rio de Janeiro'
    ORDER BY event, medals_count DESC
),
olympics_ranking AS (
    SELECT *,
        RANK () OVER (PARTITION BY team, event ORDER BY medals_count DESC) AS ranking
    FROM olympics_2016
    ORDER BY team ASC
)
SELECT event,
    (CASE WHEN ranking=1 THEN team || ' with ' || medals_count || ' medals' ELSE 'No Team' END) AS gold_team,
    (CASE WHEN ranking=2 THEN team || ' with ' || medals_count || ' medals' ELSE 'No Team' END) AS silver_team,
    (CASE WHEN ranking=3 THEN team || ' with ' || medals_count || ' medals' ELSE 'No Team' END) AS bronze_team
FROM olympics_ranking

