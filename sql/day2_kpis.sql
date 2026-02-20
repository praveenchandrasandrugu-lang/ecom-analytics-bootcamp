# Total orders
SELECT COUNT(*) AS total_orders
FROM `bigquery-public-data.thelook_ecommerce.orders`;

# Total sales
SELECT ROUND(SUM(sale_price), 2) AS total_revenue
FROM `bigquery-public-data.thelook_ecommerce.order_itmes`;

# AOV (Average Order Value)
WITH order_totals AS (
    SELECT
    order_id,
    SUM(sale_price) AS order_total
    FROM `bigquery-public-data.thelook_ecommerce.order_itmes`
    GROUP BY order_id
)
SELECT
   ROUND(AVE(order_total), 2) AS AOV
FROM order_totals;

# Revenue by month
SELECT
  DATE_TRUNC(DATE(created_at), MONTH) AS month,
  ROUND(SUM(sale_price), 2) AS revenue
FROM `bigquery-public-data.thelook_ecommerce.order_items`
GROUP BY month
ORDER BY month;

# Top 10 products by revenue
SELECT
  oi.product_id,
  ROUND(SUM(oi.sale_price), 2) AS revenue
FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
GROUP BY oi.product_id
ORDER BY revenue DESC
LIMIT 10;

# Top 10 products with product name
SELECT
   p.name AS product_name,
   ROUND(SUM(oi.sale_price), 2) AS revenue
FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
JOIN `bigquery-public-data.thelook_ecommerce.products` p
  ON oi.product_id = p.id
GROUP BY product_name
ORDER BY revenue DESC
LIMIT 10;

# Average itmes per order
SELECT
  ROUND(AVG(num_of_item), 2) AS avg_items_per_order
FROM `bigquery-public-data.thelook_ecommerce.orders`;


