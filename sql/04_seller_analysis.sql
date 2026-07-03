----------------------------------------------------------
----------------------------------------------------------
--Who are the top 10 sellers by revenue?
SELECT 
    sellers.seller_id,
    CAST(SUM(ordersitems.price) AS DECIMAL(10,2)) AS seller_revenue
FROM olist_sellers_dataset sellers
LEFT JOIN olist_order_items_dataset ordersitems
    ON sellers.seller_id = ordersitems.seller_id
GROUP BY sellers.seller_id
ORDER BY seller_revenue DESC


---------------------------------------------------------------------
---------------------------------------------------------------------
--Who are the sellers with highest late delivery rates? Using sellers with at least 10 delivered orders
WITH delivery_speed AS (
    SELECT 
    sellers.seller_id,
    CASE
        WHEN orders.order_estimated_delivery_date > orders.order_delivered_customer_date THEN 'Early' ELSE 'Late'
    END AS early_or_late_delivery
    FROM olist_sellers_dataset sellers
    LEFT JOIN olist_order_items_dataset ordersitems
        ON sellers.seller_id = ordersitems.seller_id
    LEFT JOIN olist_orders_dataset orders
        ON ordersitems.order_id = orders.order_id
    WHERE orders.order_status = 'delivered'
),
delivery_speed_count AS (
    SELECT 
        seller_id,
        early_or_late_delivery,
        COUNT(*) AS early_or_late_count
    FROM delivery_speed
    GROUP BY seller_id, early_or_late_delivery
),
ordered_delivery_speed_perc AS (
SELECT
    seller_id,
    early_or_late_count,
    early_or_late_delivery,
    CAST(early_or_late_count * 100.0 / SUM(early_or_late_count) OVER (PARTITION BY seller_id) AS DECIMAL(5,2)) AS speed_delivery_perc
FROM delivery_speed_count
)
SELECT 
    TOP 10 seller_id,
    speed_delivery_perc
FROM ordered_delivery_speed_perc
WHERE early_or_late_delivery = 'Late' AND early_or_late_count > 10
ORDER BY speed_delivery_perc DESC


---------------------------------------------------
---------------------------------------------------
--Which sellers have the best reviews?
SELECT 
    TOP 20 sellers.seller_id,
    CAST(AVG(1.0 * reviews.review_score) AS DECIMAL(3,2)) AS avg_score
FROM olist_sellers_dataset sellers
LEFT JOIN olist_order_items_dataset ordersitems
    ON sellers.seller_id = ordersitems.seller_id
LEFT JOIN olist_order_reviews_dataset reviews
    ON ordersitems.order_id = reviews.order_id
GROUP BY sellers.seller_id
HAVING COUNT(sellers.seller_id) > 10
ORDER BY avg_score DESC