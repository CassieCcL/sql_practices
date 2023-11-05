-- Find how the average male height changed between each Olympics 
-- from 1896 to 2016.
-- Output the Olympics year, average height, previous average height, 
-- and the corresponding average height difference.
-- Order records by the year in ascending order.
-- If avg height is not found, assume that the average height 
-- of an athlete is 172.73.
WITH RECURSIVE olympics_years AS (
    SELECT 1896 AS year
    UNION ALL
    SELECT year + 4
    FROM olympics_years
    WHERE year < 2016
), -- use recursive CTE to generate all the years from 1896 to 2016
avg_height AS (
    SELECT year,
        COALESCE(AVG(height), 172.73) as male_avg_height
    FROM olympics_athletes_events
    WHERE sex = 'M'
    GROUP BY year
), -- calculate the avg height, coalesce was used to fill any null values
height_diff AS (
    SELECT olympics_years.year AS year,
        COALESCE(avg_height.male_avg_height, 172.73) AS current_year_height,
        COALESCE(LAG(avg_height.male_avg_height) OVER (ORDER BY olympics_years.year), 172.73) AS previous_year_height
    FROM olympics_years LEFT JOIN avg_height
    ON olympics_years.year = avg_height.year
)
SELECT year,
    current_year_height,
    previous_year_height,
    current_year_height - previous_year_height AS avg_height_diff
FROM height_diff
ORDER BY year ASC