-- Find the IDs of the drivers who completed at least one trip a month for 
-- at least two months in a row.

-- date manipulation, extract year and month and filter the completed trips
WITH completed_trips AS (
    SELECT 
        EXTRACT (YEAR FROM trip_date) AS trip_year,
        EXTRACT (MONTH FROM trip_date) AS trip_month,
        driver_id
    FROM 
        uber_trips
    WHERE 
        is_completed = TRUE
    ORDER BY 
        driver_id, trip_year, trip_month
),
-- find the consecutive months, be aware of the months that are at the end of the year and the beginning of the next.
consecutive_criteria AS (
    SELECT 
        driver_id,
        CASE WHEN 
            LEAD(trip_month) OVER(PARTITION BY driver_id ORDER BY trip_year, trip_month ASC) = trip_month +1
        AND 
            LEAD(trip_year) OVER(PARTITION BY driver_id ORDER BY trip_year, trip_month ASC) = trip_year
        OR 
            LEAD(trip_year) OVER(PARTITION BY driver_id ORDER BY trip_year, trip_month ASC) = trip_year + 1
        AND 
            trip_month = 12
        THEN 1 
        ELSE 0 END AS consecutive_met
    FROM 
        completed_trips
)
SELECT 
    DISTINCT driver_id
FROM 
    consecutive_criteria
WHERE 
    consecutive_met = 1