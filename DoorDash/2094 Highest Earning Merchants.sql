-- For each day, you have been asked to find a merchant who earned the most 
-- money on the day before.
-- Before comparing totals between merchants, round the total amounts 
-- to the nearest 2 decimals places.
-- Your output should include the date in the format 'YYYY-MM-DD' and 
-- the merchant's name, but only for days where data from the previous day is available.
-- Note: In the case of multiple merchants having the same highest shared amount, 
-- your output should include all the names in different rows.

-- the "merchant_id" in order_details is the same "id" in merchant_details
-- extract date from order_timestamp, and sum up to get the totals for each merchant on each day
WITH merchant_dates AS (
    SELECT 
        merchant_id,
        DATE(order_timestamp) AS order_date,
        SUM(total_amount_earned) AS total_amount
    FROM 
        order_details
    GROUP BY 
        merchant_id, DATE(order_timestamp)
    ORDER BY 
        DATE(order_timestamp)
),
-- rank the sales amount per day
sales_ranking AS (
    SELECT 
        order_date,
        merchant_id,
        total_amount,
        RANK() OVER(PARTITION BY order_date ORDER BY total_amount DESC) AS day_rank
    FROM 
        merchant_dates
),
-- only include the dates where the previous day's sale is available
previous_day_sale AS (
    SELECT 
        order_date,
        merchant_id,
        total_amount,
        LAG(total_amount) OVER (ORDER BY order_date ASC) AS previous_sale
    FROM 
        sales_ranking
    WHERE 
        day_rank = 1
)
-- exclude the data where previous_day_sale is NULL and join with merchant_details to find the merchant's name
SELECT 
    order_date,
    name
FROM
    previous_day_sale
JOIN 
    merchant_details
ON 
    previous_day_sale.merchant_id = merchant_details.id
WHERE 
    previous_sale IS NOT NULL