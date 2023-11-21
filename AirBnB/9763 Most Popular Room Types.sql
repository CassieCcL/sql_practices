-- Find the room types that are searched by most people. 
-- Output the room type alongside the number of searches for it. 
-- If the filter for room types has more than one room type, 
-- consider each unique room type as a separate row. 
-- Sort the result based on the number of searches in descending order.

-- fix room types for it to contain only 1 type per row
-- It was noticed some entries have repetitive types, hense add in DISTINCT id_user to remove the repetitive ones
WITH airbnb_room_searches AS (
    SELECT 
        DISTINCT id_user,
        REGEXP_SPLIT_TO_TABLE(filter_room_types, ',') AS room_types,
        n_searches
    FROM
        airbnb_searches
)
SELECT
    DISTINCT room_types,
    SUM(n_searches) OVER(PARTITION BY room_types) AS total_searches
FROM
    airbnb_room_searches
WHERE 
    room_types NOT LIKE ''