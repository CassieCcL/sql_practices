-- You have been asked to investigate whether there is a correlation between 
-- the average total order value and the average time in minutes between 
-- placing an order and having it delivered per restaurant.
-- You have also been told that the column order_total represents the gross order 
-- total for each order. Therefore, you'll need to calculate the net order total.
-- The gross order total is the total of the order before adding the tip and deducting 
-- the discount and refund.

-- To calculate the average time in minutes between placing an order and having it delivered per restaurant, will need to use delivered_to_consumer_datetime subtract customer_placed_order_datetime. And the net order total need to be calculatec through order_total - discount_amount + tip_amount - refunded_amount.
WITH delivery_net AS (
    SELECT 
        (delivered_to_consumer_datetime - customer_placed_order_datetime)/60 AS delivery_interval,
        restaurant_id,
        order_total - discount_amount + tip_amount - refunded_amount AS net_total
    FROM 
        delivery_details
)
-- calculate average by each restaurant
SELECT
    DISTINCT restaurant_id,
    AVG(delivery_interval) OVER (PARTITION BY restaurant_id) AS avg_delivery,
    AVG(net_total) OVER(PARTITION BY restaurant_id) AS avg_total
FROM 
    delivery_net
ORDER BY avg_total, avg_delivery