SELECT TOP 5 *
FROM olist_orders_dataset

SELECT TOP 5 *
FROM olist_order_payments_dataset

SELECT TOP 5 *
FROM olist_order_items_dataset

SELECT TOP 5 *
FROM olist_customers_dataset

SELECT TOP 5 *
FROM olist_geolocation_dataset

SELECT TOP 5 *
FROM olist_order_reviews_dataset

SELECT TOP 5 *
FROM olist_sellers_dataset

SELECT TOP 5 *
FROM olist_products_dataset

SELECT TOP 5 *
FROM product_category_name_translation


-- Checking row count
SELECT COUNT(*)
FROM olist_orders_dataset

SELECT COUNT(*)
FROM olist_customers_dataset

SELECT COUNT(*)
FROM olist_geolocation_dataset

SELECT COUNT(*)
FROM olist_products_dataset

SELECT COUNT(*)
FROM olist_order_items_dataset

SELECT COUNT(*)
FROM olist_order_payments_dataset

SELECT COUNT(*)
FROM olist_order_reviews_dataset

SELECT COUNT(*)
FROM olist_sellers_dataset

SELECT COUNT(*)
FROM product_category_name_translation


-- Checking datatypes for all columns in all tables
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'olist_customers_dataset';

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'olist_geolocation_dataset';

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'olist_order_items_dataset';

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'olist_order_payments_dataset';

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'olist_order_reviews_dataset';

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'olist_orders_dataset';

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'olist_products_dataset';

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'olist_sellers_dataset';

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'product_category_name_translation';


--Checking distinct data values for columns that are supposed to be categorical
--Payment Type
SELECT payment_type, COUNT(payment_type) 
FROM olist_order_payments_dataset
GROUP BY payment_type

--Number of Instalments
SELECT payment_installments, COUNT(payment_installments) 
FROM olist_order_payments_dataset
GROUP BY payment_installments

--Customer State
SELECT customer_state, COUNT(customer_state)
FROM olist_customers_dataset
GROUP BY customer_state

--Order status
SELECT order_status, COUNT(order_status)
FROM olist_orders_dataset
GROUP BY order_status

SELECT 
    order_status,
    COUNT(*) AS total,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(5,2)) AS percentage
FROM olist_orders_dataset
GROUP BY order_status;

--Product Category name
SELECT product_category_name, COUNT(product_category_name)
FROM olist_products_dataset
GROUP BY product_category_name

--Seller state
SELECT seller_state, COUNT(seller_state)
FROM olist_sellers_dataset
GROUP BY seller_state

--Checking Number columns for range, outliers or implausible values
SELECT 
    MIN(price) AS min_price,
    MAX(price) AS max_price,
    MIN(freight_value) AS min_freight,
    MAX(freight_value) AS max_freight
FROM olist_order_items_dataset;

--Outliers
SELECT TOP 1000 * 
FROM olist_order_items_dataset
ORDER BY price DESC;

SELECT review_score, COUNT(*) AS count
FROM olist_order_reviews_dataset
GROUP BY review_score
ORDER BY review_score;

--Implausible values where the dat delivered will be before date that the order was made
SELECT COUNT(*)
FROM olist_orders_dataset
WHERE order_delivered_customer_date < order_purchase_timestamp;
