-- Write a query to find the Market Share at the Product Brand level for each Territory, 
-- for Time Period Q4-2021. Market Share is the number of Products of a certain Product Brand brand sold in a territory, 
-- divided by the total number of Products sold in this Territory.
-- Output the ID of the Territory, name of the Product Brand and the corresponding Market Share in percentages. 
-- Only include these Product Brands that had at least one sale in a given territory.

-- set Q4-2021 as Oct-2021, Nov-2021 and Dec-2021
-- join fct_customer_sales with map_customer_territory to find the territory of each client, join 
-- fct_customer_sales with dim_product to find the brand of each product sku
WITH sales_customer_territory AS (
    SELECT 
        fct_customer_sales.cust_id,
        prod_brand,
        territory_id,
        order_value,
        EXTRACT(MONTH FROM order_date) AS sales_month,
        EXTRACT(YEAR FROM order_date) AS sales_year
    FROM 
        fct_customer_sales
    JOIN
        map_customer_territory
    ON 
        fct_customer_sales.cust_id = map_customer_territory.cust_id
    JOIN 
        dim_product
    ON 
        fct_customer_sales.prod_sku_id = dim_product.prod_sku_id
)
SELECT 
    prod_brand,
    territory_id,
    brandsales_per_territory * 1.0 / SUM(brandsales_per_territory)OVER(PARTITION BY territory_id) AS market_share
FROM (
    SELECT 
        prod_brand,
        territory_id,
        SUM(order_value) AS brandsales_per_territory
    FROM 
        sales_customer_territory
    WHERE 
        sales_month <= 10
    AND 
        sales_year = 2021
    GROUP BY 
        prod_brand, territory_id
) a