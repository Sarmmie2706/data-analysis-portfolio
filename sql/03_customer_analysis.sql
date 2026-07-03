----------------------------------------------------------
----------------------------------------------------------
--What are the revenues by cities?
SELECT 
    customers.customer_city,
    customers.customer_state,
    CAST(SUM(payments.payment_value) AS DECIMAL(10,2)) AS city_revenue,
	CAST(SUM(payments.payment_value) * 100/ SUM(SUM(payments.payment_value)) OVER () AS DECIMAL(5,2)) AS city_revenue_perc
FROM olist_customers_dataset customers
LEFT JOIN olist_orders_dataset orders
    ON customers.customer_id = orders.customer_id
LEFT JOIN olist_order_payments_dataset payments
    ON orders.order_id = payments.order_id
WHERE orders.order_status = 'delivered'
GROUP BY customers.customer_city, customers.customer_state
ORDER BY city_revenue DESC;


-------------------------------------------------------------
-------------------------------------------------------------
--What are the revenues by states?
SELECT 
    customers.customer_state,
    CAST(SUM(payments.payment_value) AS DECIMAL(10,2)) AS total_revenue,
	CAST(SUM(payments.payment_value) * 100 / SUM(SUM(payments.payment_value)) OVER () AS DECIMAL(5,2)) AS state_revenue_perc
FROM olist_customers_dataset customers
LEFT JOIN olist_orders_dataset orders
    ON customers.customer_id = orders.customer_id
LEFT JOIN olist_order_payments_dataset payments
    ON orders.order_id = payments.order_id
WHERE orders.order_status = 'delivered'
GROUP BY customers.customer_state
ORDER BY total_revenue DESC;


-----------------------------------------------------------
-----------------------------------------------------------
--What percent does each city contribute to their state?
WITH city_totals AS (
    SELECT 
        customers.customer_city,
        customers.customer_state,
        CAST(SUM(payments.payment_value) AS DECIMAL(10,2)) AS total_payment_by_city
    FROM olist_customers_dataset customers
    LEFT JOIN olist_orders_dataset orders
        ON customers.customer_id = orders.customer_id
    LEFT JOIN olist_order_payments_dataset payments
        ON orders.order_id = payments.order_id
    WHERE orders.order_status = 'delivered'
    GROUP BY customers.customer_city, customers.customer_state
),
city_with_state_totals AS (
    SELECT 
        customer_state,
        customer_city,
        total_payment_by_city,
        SUM(total_payment_by_city) OVER (PARTITION BY customer_state) AS total_payment_by_state
    FROM city_totals
)
SELECT
    customer_state,
    total_payment_by_state,
    customer_city,
    total_payment_by_city,
    CAST(total_payment_by_city * 100.0 / total_payment_by_state AS DECIMAL(5,2)) AS city_pct_of_state
FROM city_with_state_totals
ORDER BY total_payment_by_state DESC, total_payment_by_city DESC;


-----------------------------------------------------------------
-----------------------------------------------------------------
--What is the average order value by state?
SELECT 
    customers.customer_state,
    CAST(AVG(payments.payment_value) AS DECIMAL(10,2)) AS avg_revenue,
    COUNT(customers.customer_state) AS customers_in_state
FROM olist_customers_dataset customers
LEFT JOIN olist_orders_dataset orders
    ON customers.customer_id = orders.customer_id
LEFT JOIN olist_order_payments_dataset payments
    ON orders.order_id = payments.order_id
WHERE orders.order_status = 'delivered'
GROUP BY customers.customer_state
ORDER BY avg_revenue DESC;


---------------------------------------------------------------
---------------------------------------------------------------
-- What percentage of customers are one-time vs repeat?
WITH customer_count AS (
    SELECT 
        DISTINCT(customers.customer_unique_id),
        COUNT(customers.customer_unique_id) AS customer_order_count
    FROM olist_customers_dataset customers
    LEFT JOIN olist_orders_dataset orders
        ON customers.customer_id = orders.customer_id
    LEFT JOIN olist_order_payments_dataset payments
        ON orders.order_id = payments.order_id
    WHERE orders.order_status = 'delivered'
    GROUP BY customers.customer_unique_id
),
grouped AS (
    SELECT 
        customer_unique_id,
        customer_order_count,
        CASE
            WHEN customer_order_count =  1 THEN 'One-time' ELSE 'Repeat'
        END AS repeat_grouping
    FROM customer_count
),
grouped_count AS (
SELECT 
    repeat_grouping,
    COUNT(repeat_grouping) AS repeat_count
FROM grouped
GROUP BY repeat_grouping
)
SELECT
    repeat_grouping,
    repeat_count,
    CAST(repeat_count * 100.0 / SUM(repeat_count) OVER () AS DECIMAL(5,2)) AS repeat_count_perc
FROM grouped_count
GROUP BY repeat_grouping, repeat_count