-- Find the number of processed and non-processed complaints of each type.
-- Replace NULL values with 0s.
-- Output the complaint type along with the number of 
-- processed and not-processed complaints.

-- Number of processed complaints
WITH processed_complaints AS (
    SELECT
        DISTINCT type,
        COUNT(*) OVER(PARTITION BY type) AS number_processed
    FROM 
        facebook_complaints
    WHERE
        processed = TRUE
),
-- Number of non-processed complaints 
nonprocessed_complaints AS (
    SELECT
        DISTINCT type,
        COUNT(*) OVER(PARTITION BY type) AS number_nonprocessed
    FROM
        facebook_complaints
    WHERE
        processed = FALSE
)
-- join the 2 tables
SELECT
    processed_complaints.type,
    number_processed,
    number_nonprocessed
FROM 
    processed_complaints
JOIN 
    nonprocessed_complaints
ON 
    processed_complaints.type = nonprocessed_complaints.type