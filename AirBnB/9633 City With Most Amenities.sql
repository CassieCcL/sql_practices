-- You're given a dataset of searches for properties on Airbnb. 
-- For simplicity, let's say that each search result (i.e., each row) 
-- represents a unique host. Find the city with the most amenities 
-- across all their host's properties. Output the name of the city.

-- utilize regexp_split() to retrieve all the amenities for one host
WITH all_amenities AS (
    SELECT 
        id, 
        city,
        TRIM (BOTH '"{}' FROM REGEXP_SPLIT_TO_TABLE(amenities, ',')) AS amentity
    FROM 
        airbnb_search_details
)
-- Due to hosts are unique, there should be no duplicates
SELECT 
    city
FROM (
    SELECT 
        city,
        COUNT(*) AS amenities_num
    FROM 
        all_amenities
    GROUP BY 
        city
    ORDER BY 
        amenities_num
) a 
LIMIT 1