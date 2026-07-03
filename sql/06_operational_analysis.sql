--------------------------------------------------------
--------------------------------------------------------
--What are the average days for approval and dispatch?
WITH avg_approval_dispatch AS (
	SELECT
		order_id,
		AVG(DATEDIFF(day, order_purchase_timestamp, order_approved_at)) AS days_for_approval,
		AVG(DATEDIFF(day, order_approved_at, order_delivered_carrier_date)) AS days_for_dispatch
	FROM olist_orders_dataset
	GROUP BY order_id
)
SELECT 
	AVG(days_for_approval) AS avg_days_for_approval,
	AVG(days_for_dispatch) AS avg_days_for_dispatch
FROM avg_approval_dispatch


--------------------------------------------------------
--------------------------------------------------------
--Which sellers took the longest time to dispatch
SELECT 
	TOP 20 sellers.seller_id,
	AVG(DATEDIFF(day, order_approved_at, order_delivered_carrier_date)) AS days_for_dispatch
FROM olist_orders_dataset orders
LEFT JOIN olist_order_items_dataset ordersitems
    ON orders.order_id = ordersitems.order_id
LEFT JOIN olist_sellers_dataset sellers
    ON ordersitems.seller_id = sellers.seller_id
GROUP BY sellers.seller_id
HAVING COUNT(sellers.seller_id) > 10
ORDER BY days_for_dispatch DESC


--------------------------------------------------------
--------------------------------------------------------
--What is the delivery rate by state?
SELECT 
	customers.customer_state,
	CAST(AVG(1.0 * DATEDIFF(day,  order_delivered_customer_date, order_estimated_delivery_date)) AS DECIMAL(5,2)) AS days_for_delivery
FROM olist_orders_dataset orders
LEFT JOIN olist_customers_dataset customers
    ON orders.customer_id = customers.customer_id
GROUP BY customers.customer_state
ORDER BY days_for_delivery DESC