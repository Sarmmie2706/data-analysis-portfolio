-------------------------------------------------------
-------------------------------------------------------
--What is the rank of each seller in terms of revenue?
WITH ranks AS (
SELECT 
    sellers.seller_id,
    CAST(SUM(ordersitems.price) AS DECIMAL(10,2)) AS seller_revenue
FROM olist_sellers_dataset sellers
LEFT JOIN olist_order_items_dataset ordersitems
    ON sellers.seller_id = ordersitems.seller_id
GROUP BY sellers.seller_id
)
SELECT 
    seller_id,
    seller_revenue,
    RANK() OVER (ORDER BY seller_revenue DESC) AS seller_ranks
FROM ranks
ORDER BY seller_ranks;

---------------------------------------------------------
---------------------------------------------------------
--What is the percentage change in revenue per month?
WITH monthly_revenue AS (
SELECT 
    YEAR(orders.order_purchase_timestamp) AS year_,
    MONTH(orders.order_purchase_timestamp) AS month_,
    CAST(SUM(payments.payment_value) AS DECIMAL(10,2)) AS current_month_revenue
FROM olist_orders_dataset orders
LEFT JOIN olist_order_payments_dataset payments
    ON orders.order_id = payments.order_id
WHERE orders.order_status = 'delivered'
GROUP BY YEAR(orders.order_purchase_timestamp), MONTH(orders.order_purchase_timestamp)
),
previous_month AS (
SELECT
    year_,
    month_,
    current_month_revenue,
    LAG(current_month_revenue) OVER (ORDER BY year_, month_) AS previous_month_revenue
FROM monthly_revenue
)
SELECT
    year_,
    month_,
    current_month_revenue,
    previous_month_revenue,
    CAST((current_month_revenue - previous_month_revenue) * 100 / previous_month_revenue AS DECIMAL(10,2)) AS monthly_change_perc
FROM previous_month;


------------------------------------------------------------
------------------------------------------------------------
--Which products generated most revenue per state?
WITH revenue_per_state_product AS (
    SELECT 
        translation.product_category_name_english,
        customers.customer_state,
        CAST(SUM(ordersitems.price) AS DECIMAL(10,2)) AS revenue
    FROM olist_orders_dataset orders
    JOIN olist_customers_dataset customers
        ON orders.customer_id = customers.customer_id
    JOIN olist_order_items_dataset ordersitems
        ON orders.order_id = ordersitems.order_id
    JOIN olist_products_dataset products
        ON ordersitems.product_id = products.product_id
    JOIN product_category_name_translation translation
        ON products.product_category_name = translation.product_category_name
    GROUP BY translation.product_category_name_english, customers.customer_state
),
ranked_products_in_states AS (
    SELECT 
        product_category_name_english,
        customer_state,
        revenue,
        RANK() OVER (PARTITION BY customer_state ORDER BY revenue DESC) AS product_rank_per_state
    FROM revenue_per_state_product
)
SELECT *
FROM ranked_products_in_states
WHERE product_rank_per_state <= 3
ORDER BY customer_state, product_rank_per_state