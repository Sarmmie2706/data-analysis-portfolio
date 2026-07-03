-- Creating the database
CREATE DATABASE olist_ecommerce;
GO

-- Selecting the database
USE olist_ecommerce;
GO

-- After running this script, import the following CSV files
-- using SSMS Import Flat File wizard (Tasks > Import Flat File):
-- 1. olist_orders_dataset.csv
-- 2. olist_order_items_dataset.csv
-- 3. olist_order_payments_dataset.csv
-- 4. olist_order_reviews_dataset.csv
-- 5. olist_products_dataset.csv
-- 6. olist_customers_dataset.csv
-- 7. olist_sellers_dataset.csv
-- 8. olist_geolocation_dataset.csv
-- 9. product_category_name_translation.csv

--Defining Relationships Between Tables
--Orders table referencing customers table
ALTER TABLE olist_orders_dataset
ADD CONSTRAINT fk_orders_customers
FOREIGN KEY (customer_id)
REFERENCES olist_customers_dataset(customer_id);

--Order Items referencing orders table
ALTER TABLE olist_order_items_dataset
ADD CONSTRAINT fk_orderitems_orders
FOREIGN KEY (order_id)
REFERENCES olist_orders_dataset(order_id)

--Order Items referencing product table
ALTER TABLE olist_order_items_dataset
ADD CONSTRAINT fk_orderitems_products
FOREIGN KEY (product_id)
REFERENCES olist_products_dataset(product_id)

--Order Items referencing sellers table
ALTER TABLE olist_order_items_dataset
ADD CONSTRAINT fk_orderitems_sellers
FOREIGN KEY (seller_id)
REFERENCES olist_sellers_dataset(seller_id)

--Order payments referencing orders table
ALTER TABLE olist_order_payments_dataset
ADD CONSTRAINT fk_payments_orders
FOREIGN KEY (order_id)
REFERENCES olist_orders_dataset(order_id)

--Order reviews referencing orders table
ALTER TABLE olist_order_reviews_dataset
ADD CONSTRAINT fk_reviews_orders
FOREIGN KEY (order_id)
REFERENCES olist_orders_dataset(order_id)

-- Products referencing category translation
ALTER TABLE olist_products_dataset
ADD CONSTRAINT fk_products_category
FOREIGN KEY (product_category_name)
REFERENCES product_category_name_translation(product_category_name)
--This threw an error as there are rows in the products table without corresponding rows in the translation table

--Checking those rows by joining and filtering
SELECT DISTINCT p.product_category_name
FROM olist_products_dataset p
LEFT JOIN product_category_name_translation t
    ON p.product_category_name = t.product_category_name
WHERE t.product_category_name IS NULL;

--There were two categories not present in the translation table as well as NULL rows
--Checking the count of the NULL rows
SELECT COUNT(*)
FROM olist_products_dataset
WHERE product_category_name IS NULL

--Converting the NULL rows to a text value that is then inserted into the translation tables with the other non-matching values
UPDATE olist_products_dataset
SET product_category_name = 'uncategorised'
WHERE product_category_name IS NULL

INSERT INTO product_category_name_translation (product_category_name, product_category_name_english)
VALUES 
    ('portateis_cozinha_e_preparadores_de_alimentos', 'portable_kitchen_and_food_preparers'),
    ('pc_gamer', 'gaming_pc'),
    ('uncategorised', 'uncategorised')

--Run code on line 66 again to check if there are still non-matching rows
--Run the foreign key constraint command on line 59