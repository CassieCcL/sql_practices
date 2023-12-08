-- Find products which are exclusive to only Amazon and therefore 
-- not sold at Top Shop and Macy's. Your output should include 
-- the product name, brand name, price, and rating.
-- Two products are considered equal if they have the same product name 
-- and same maximum retail price (mrp column).

-- Find out the same products that are sold in Topshop and Macy's
WITH all_sold AS (
    SELECT 
        DISTINCT c.product_name,
        c.mrp
    FROM 
        innerwear_macys_com a 
    JOIN 
        innerwear_topshop_com b 
    ON 
        a.product_name = b.product_name
    AND 
        a.mrp = b.mrp
    JOIN 
        innerwear_amazon_com c 
    ON
        a.product_name = c.product_name
    AND 
        a.mrp = c.mrp
)
SELECT 
    product_name,
    brand_name,
    price,
    rating
FROM 
    innerwear_amazon_com
WHERE 
    (product_name, mrp) NOT IN (
        SELECT 
            product_name,
            mrp
        FROM 
            all_sold
    )