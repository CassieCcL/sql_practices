-- WFM would like to segment the customers in each of their store brands into Low, 
-- Medium, and High segmentation. The segments are to be based on a customer's 
-- average basket size which is defined as (total sales / count of transactions), 
-- per customer.
-- The segment thresholds are as follows:
-- If average basket size is more than $30, then Segment is “High”.
-- If average basket size is between $20 and $30, then Segment is “Medium”.
-- If average basket size is less than $20, then Segment is “Low”.
-- Summarize the number of unique customers, the total number of transactions, 
-- total sales, and average basket size, grouped by store brand and segment for 2017.
-- Your output should include the brand, segment, number of customers, total transactions, 
-- total sales, and average basket size.

-- apply aggregation functions COUNT() and SUM() to get total sales and number of transactions, partitiob by store id and customer id as required. Also remember to filter the transactions only happened in 2017
WITH wfm_sales AS (
    SELECT 
        store_id,
        customer_id,
        SUM(sales) AS total_sales,
        COUNT(DISTINCT transaction_id) AS number_txns
-- noticed that the same transaction id has been used multiple times for different product_id, hence COUNT() was only applied to each unique transaction id
    FROM 
        wfm_transactions
    WHERE 
        EXTRACT (YEAR FROM transaction_date) = 2017
    GROUP BY store_id, customer_id
)
-- use case when to categorize the customers accordign to average basket size
SELECT 
    store_brand,
    customer_id,
    total_sales,
    number_txns,
    total_sales/ number_txns AS avg_basket,
    CASE 
        WHEN total_sales/ number_txns >30 THEN 'High'
        WHEN total_sales/ number_txns >= 20 THEN 'Medium'
        ELSE 'Low' END AS customer_segment
FROM 
    wfm_sales
JOIN 
    wfm_stores
ON 
    wfm_sales.store_id = wfm_stores.store_id