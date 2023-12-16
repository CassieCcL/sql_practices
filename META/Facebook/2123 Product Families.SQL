-- The CMO is interested in understanding how the sales of different 
-- product families are affected by promotional campaigns. 
-- To do so, for each product family, show the total number of units sold, 
-- as well as the percentage of units sold that had a valid promotion 
-- among total units sold. If there are NULLS in the result, 
-- replace them with zeroes. Promotion is valid if it's not empty 
-- and it's contained inside promotions table.

-- Join facebook_products and facebook_sales to find out the number of units sold for each product family
WITH total_sales AS (
    SELECT 
        facebook_products.product_id,
        units_sold,
        product_family
    FROM 
        facebook_products 
    LEFT JOIN 
        facebook_sales
    ON 
        facebook_products.product_id = facebook_sales.product_id
),
products_total_units AS (
    SELECT 
        product_family,
        SUM(units_sold) AS products_units_sold
    FROM 
        total_sales
    GROUP by
        product_family
),
-- Join facebook_sales with facebook_sales_promotions to find the products with promotions 
promotion_units AS (
    SELECT 
        product_id,
        facebook_sales_promotions.promotion_id,
        units_sold
    FROM 
        facebook_sales
    LEFT JOIN 
        facebook_sales_promotions
    ON 
        facebook_sales.promotion_id = facebook_sales_promotions.promotion_id
),
-- Join promotion_units with total_sales to find out the promotional units sold in each family
promotional_sales AS (
    SELECT 
        product_family,
        SUM(units_sold) AS promotion_sold
    FROM (
        SELECT 
            promotion_units.product_id,
            promotion_id,
            product_family,
            promotion_units.units_sold
        FROM 
            facebook_products
        LEFT JOIN 
            promotion_units
        ON 
            promotion_units.product_id = facebook_products.product_id
        WHERE 
            promotion_id IS NOT NULL
    ) a
    GROUP BY 
        product_family
)
-- join products_total_units with promotional_sales to get the percentage
SELECT 
    products_total_units.product_family,
    products_units_sold,
    promotion_sold,
    promotion_sold *1.0 / products_units_sold * 100 as promotion_boost_percentage
FROM 
    products_total_units
JOIN 
    promotional_sales
ON 
    products_total_units.product_family = promotional_sales.product_family