------------------------------------------------------------
------------------------------------------------------------
-- WHich product categories generate the most revenue?
SELECT 
    TOP 15 translation.product_category_name_english,
    CAST(SUM(ordersitems.price) AS DECIMAL(10,2)) AS revenue_per_category
FROM olist_order_items_dataset ordersitems
LEFT JOIN olist_products_dataset products
    ON ordersitems.product_id = products.product_id
LEFT JOIN product_category_name_translation translation
    ON products.product_category_name = translation.product_category_name
GROUP BY translation.product_category_name_english
ORDER BY revenue_per_category DESC

-------------------------------------------------------------
-------------------------------------------------------------
--Which product categories have high freight to price ratio
SELECT 
    TOP 15 translation.product_category_name_english,
    CAST(AVG(ordersitems.freight_value/ordersitems.price) AS DECIMAL(10,2)) AS freight_to_price_ratio
FROM olist_order_items_dataset ordersitems
LEFT JOIN olist_products_dataset products
    ON ordersitems.product_id = products.product_id
LEFT JOIN product_category_name_translation translation
    ON products.product_category_name = translation.product_category_name
GROUP BY translation.product_category_name_english
ORDER BY freight_to_price_ratio DESC