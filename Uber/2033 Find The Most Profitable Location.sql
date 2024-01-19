-- Find the most profitable location. Write a query that calculates the average 
-- signup duration and average transaction amount for each location, and then 
-- compare these two measures together by taking the ratio of the average transaction 
-- amount and average duration for each location.
-- Your output should include the location, average duration, average transaction amount,
--  and ratio. Sort your results from highest ratio to lowest.

-- join needs to be applied on both signup_id and transaction_start_date falls within signup_start_date and signup_stop_date
WITH signup_amount AS (
    SELECT
        location,
        signups.signup_id,
        signup_stop_date - signup_start_date AS signup_duration,
        amt 
    FROM 
        signups
    JOIN 
        transactions
    ON 
        signups.signup_id = transactions.signup_id
    AND 
        transactions.transaction_start_date BETWEEN signup_start_date AND signup_stop_date
),
transaction_details AS (
    SELECT
        DISTINCT location,
        AVG(signup_duration) OVER(PARTITION BY location) AS avg_duration,
        AVG(amt) OVER(PARTITION BY amt) AS avg_amt
    FROM 
        signup_amount
)
SELECT 
    *,
    avg_amt/ avg_duration AS ratio 
FROM 
    transaction_details