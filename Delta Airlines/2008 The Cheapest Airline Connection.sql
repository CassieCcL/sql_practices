-- COMPANY X employees are trying to find the cheapest flights to upcoming conferences. 
-- When people fly long distances, a direct city-to-city flight is often more expensive 
-- than taking two flights with a stop in a hub city. Travelers might save even more money 
-- by breaking the trip into three flights with two stops. But for the purposes of this 
-- challenge, let's assume that no one is willing to stop three times! You have a table 
-- with individual airport-to-airport flights, which contains the following columns:
-- • id - the unique ID of the flight;
-- • origin - the origin city of the current flight;
-- • destination - the destination city of the current flight;
-- • cost - the cost of current flight.
-- Your task is to produce a trips table that lists all the cheapest possible trips that 
-- can be done in two or fewer stops. This table should have the columns origin, 
-- destination and total_cost (cheapest one). Sort the output table by origin, 
-- then by destination. The cities are all represented by an abbreviation composed of 
-- three uppercase English letters. Note: A flight from SFO to JFK is considered to be 
-- different than a flight from JFK to SFO.
-- Example of the output:
-- origin | destination | total_cost
-- DFW | JFK | 200

-- self-join is needed for the second and third trips.
-- the orgin and the final destination cannot be the same 
-- the trip with 0 stopover
WITH da_trip_0 AS (
    SELECT
        origin,
        destination,
        cost AS total_cost,
        0 AS stopover
    FROM 
        da_flights
),
-- trips with 1 stopover
da_trips_1 AS (
    SELECT
        df1.origin,
        df2.destination,
        df1.cost + df2.cost AS total_cost,
        1 AS stopover
    FROM 
        da_flights df1
    LEFT JOIN 
        da_flights df2
    ON
        df1.destination = df2.origin
    WHERE 
        df1.origin != df2.destination
),
-- trips with 2 stopovers
da_trips_2 AS (
    SELECT 
        df1.origin,
        df3.destination,
        df1.cost + df2.cost + df3.cost AS total_cost,
        2 AS stopover
    FROM 
        da_flights df1
    LEFT JOIN 
        da_flights df2
    ON 
        df1.destination = df2.origin
    LEFT JOIN 
        da_flights df3
    ON 
        df2.destination = df3.origin
    WHERE 
        df1.origin != df3.destination
),
-- Union all 3 tables to get all the origins, destinations and stopovers, then apply rank() to get the trip with the least fees
trip_ranking AS(
    SELECT 
        origin,
        destination,
        total_cost,
        stopover,
        DENSE_RANK()OVER(PARTITION BY CONCAT(origin, destination) ORDER BY (total_cost, stopover)) AS ranking
    FROM 
        (SELECT 
            *
        FROM 
            da_trip_0
        UNION ALL 
        SELECT 
            *
        FROM
            da_trips_1
        UNION ALL 
        SELECT 
            *
        FROM 
            da_trips_2) a
)
SELECT
    origin,
    destination,
    total_cost,
    stopover
FROM
    trip_ranking
WHERE 
    ranking = 1