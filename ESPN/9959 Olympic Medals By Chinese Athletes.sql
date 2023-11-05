-- Find the number of medals earned in each category by Chinese athletes 
-- from the 2000 to 2016 summer Olympics. For each medal category, 
-- calculate the number of medals for each olympic games along 
-- with the total number of medals across all years. 
-- Sort records by total medals in descending order.
WITH chinese_medals AS (
    SELECT year,
        event,
        medal
    FROM olympics_athletes_events
    WHERE year > 1999
    AND year < 2017
    AND season = 'Summer'
    AND team = 'China'
)
SELECT event,
    COUNT(*) AS medal_num
FROM chinese_medals
GROUP BY event
ORDER BY medal_num desc