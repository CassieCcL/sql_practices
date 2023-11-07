-- Find the connection between the number of letters 
-- in the athlete's first name and the number of medals won 
-- for each type for medal, including no medals. 
-- Output the length of the name along with the corresponding number of 
-- no medals, bronze medals, silver medals, and gold medals.
WITH names_medals AS (
    SELECT SPLIT_PART (name, ' ', 1) AS first_name,
        medal
    FROM olympics_athletes_events
), -- use split_part() to extract the first names
length_medals AS (
    SELECT LENGTH (first_name) AS name_length,
        medal
    FROM names_medals
)  -- get the first names's length
SELECT name_length,
    SUM(CASE WHEN medal IS NULL THEN 1 ELSE 0 END) AS no_medal,
    SUM(CASE WHEN medal = 'Bronze' THEN 1 ELSE 0 END) as bronze_medals,
    SUM(CASE WHEN medal = 'Silver' THEN 1 ELSE 0 END) as silver_medals,
    SUM(CASE WHEN medal = 'Gold' THEN 1 ELSE 0 END) as gold_medals
FROM length_medals
GROUP BY name_length
ORDER BY name_length ASC