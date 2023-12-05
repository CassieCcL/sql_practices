-- Estimate the growth of Airbnb each year using the number 
-- of hosts registered as the growth metric. 
-- The rate of growth is calculated by taking 
-- ((number of hosts registered in the current year - number of hosts 
-- registered in the previous year) / the number of hosts registered in the 
-- previous year) * 100.
-- Output the year, number of hosts in the current year, 
-- number of hosts in the previous year, and the rate of growth. 
-- Round the rate of growth to the nearest percent and 
-- order the result in the ascending order based on the year.
-- Assume that the dataset consists only of unique hosts, 
-- meaning there are no duplicate hosts listed.

-- extract year from host_since column and since each host is unique, it is sensible to 
-- use COUNT(id) to calculate number of hosts each year
WITH host_year AS (
    SELECT 
        id,
        EXTRACT (YEAR FROM host_since) AS register_year
    FROM 
        airbnb_search_details
),
hosts_volume AS (
    SELECT 
        register_year,
        COUNT(*) AS host_number
    FROM 
        host_year
    GROUP BY 
        register_year
    ORDER BY 
        register_year
)
-- find the growth rate by using LAG() window function
SELECT 
    register_year,
    host_number,
    LAG(host_number,1,0) OVER (ORDER BY register_year ASC) AS previous_year_host,
    (host_number - LAG(host_number,1,0) OVER (ORDER BY register_year ASC))*1.0/ host_number * 100 AS growth_rate
FROM 
    hosts_volume
ORDER BY 
    register_year