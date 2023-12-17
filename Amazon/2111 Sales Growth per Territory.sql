-- Write a query to return Territory and corresponding Sales Growth. Compare growth between periods Q4-2021 vs Q3-2021.
-- If Territory (say T123) has Sales worth $100 in Q3-2021 and Sales worth $110 in Q4-2021, 
-- then the Sales Growth will be 10% [ i.e. = ((110 - 100)/100) * 100 ]
-- Output the ID of the Territory and the Sales Growth. Only output these territories that had any sales in both quarters.

-- join fct_cutomer_sales with map_customer_territory to find out the territory of each customer 
-- extract year and month for order_date, Q3 - 7,8,9, Q4 - 10, 11,12
WITH sales_territory AS (
    SELECT 
        fct_customer_sales.cust_id,
        territory_id,
        order_value,
        EXTRACT (YEAR FROM order_date) AS sales_year,
        EXTRACT (MONTH FROM order_date) AS sales_month
    FROM 
        fct_customer_sales
    JOIN 
        map_customer_territory
    ON 
        fct_customer_sales.cust_id = map_customer_territory.cust_id
),
sale_quarter AS (
    SELECT 
        cust_id,
        territory_id,
        order_value,
        (CASE
            WHEN sales_month < 10 THEN 'Q3'
            ELSE 'Q4'
        END) AS order_quarter
    FROM 
        sales_territory
    WHERE 
        sales_year=2021
    AND 
        sales_month>6
),
territory_sale_quarter AS (
    SELECT 
        DISTINCT territory_id,
        order_quarter,
        SUM(order_value) OVER (PARTITION BY territory_id, order_quarter) AS total_quarter_sales
    FROM 
        sale_quarter
)
SELECT * FROM territory_sale_quarter