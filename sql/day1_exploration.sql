-- List tables in theLook eCommerce dataset
SELECT table_name
FROM `bigquery-public-data.thelook_ecommerce.INFORMATION_SCHEMA.TABLES`
ORDER BY table_name;

-- Basic row counts
SELECT COUNT(*) AS orders
FROM `bigquery-public-data.thelook_ecommerce.orders`;

SELECT COUNT(*) AS order_items
FROM `bigquery-public-data.thelook_ecommerce.order_items`;