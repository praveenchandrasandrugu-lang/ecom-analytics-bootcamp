SELECT COUNT(*) AS orders_rows
FROM `bigquery-public-data.thelook_ecommerce.orders`;

# 124611 is the count of rows in the orders table

SELECT COUNT(*) AS joined_rows
FROM `bigquery-public-data.thelook_ecommerce.orders` o
JOIN `bigquery-public-data.thelook_ecommerce.order_items` oi
  ON o.order_id = oi.order_id;

# 180503 is the count of rows in the joined orders and order_items tables
# If you do COUNT(*) after joining, you are counting items, not orders.

WITH order_totals AS (
  SELECT
    order_id,
    user_id,
    SUM(sale_price) AS order_total,
    MIN(created_at) AS order_created_at
  FROM `bigquery-public-data.thelook_ecommerce.order_items`
  GROUP BY order_id, user_id
)
SELECT *
FROM order_totals
LIMIT 10;

# we are creating a customer summary table that aggregates the order totals, average spending, max order value, first order date and last order date for each user.
# This will allow us to analyze customer behavior and identify trends in their purchasing patterns.

WITH order_totals AS (
  SELECT
    order_id,
    user_id,
    SUM(sale_price) AS order_total,
    MIN(created_at) AS order_created_at
  FROM `bigquery-public-data.thelook_ecommerce.order_items`
  GROUP BY order_id, user_id
),
customer_summary AS (
  SELECT
    user_id,
    COUNT(*) AS num_orders,
    ROUND(SUM(order_total), 2) AS total_spend,
    ROUND(AVG(order_total), 2) AS avg_order_value,
    ROUND(MAX(order_total), 2) AS max_order_value,
    MIN(DATE(order_created_at)) AS first_order_date,
    MAX(DATE(order_created_at)) AS last_order_date
  FROM order_totals
  GROUP BY user_id
)
SELECT *
FROM customer_summary
ORDER BY total_spend DESC
LIMIT 20;


WITH order_totals AS (
  SELECT
    order_id,
    user_id,
    SUM(sale_price) AS order_total,
    MIN(created_at) AS order_created_at
  FROM `bigquery-public-data.thelook_ecommerce.order_items`
  GROUP BY order_id, user_id
),
max_date AS (
  SELECT MAX(DATE(order_created_at)) AS max_order_date
  FROM order_totals
),
customer_summary AS (
  SELECT
    user_id,
    COUNT(*) AS num_orders,
    ROUND(SUM(order_total), 2) AS total_spend,
    ROUND(AVG(order_total), 2) AS avg_order_value,
    MAX(DATE(order_created_at)) AS last_order_date
  FROM order_totals
  GROUP BY user_id
)
SELECT
  cs.*,
  DATE_DIFF(md.max_order_date, cs.last_order_date, DAY) AS days_since_last_order
FROM customer_summary cs
CROSS JOIN max_date md
ORDER BY total_spend DESC
LIMIT 20;

# Order count after a join

SELECT
  COUNT(DISTINCT o.order_id) AS distinct_orders_after_join,
  COUNT(*) AS rows_after_join
FROM `bigquery-public-data.thelook_ecommerce.orders` o
JOIN `bigquery-public-data.thelook_ecommerce.order_items` oi
  ON o.order_id = oi.order_id;

# building order_totals (order-level revenue) and sanity check

WITH order_totals AS (
  SELECT
    order_id,
    user_id,
    SUM(sale_price) AS order_total
  FROM `bigquery-public-data.thelook_ecommerce.order_items`
  GROUP BY order_id, user_id
)
SELECT
  COUNT(*) AS order_total_rows,
  ROUND(SUM(order_total), 2) AS revenue_from_order_totals
FROM order_totals;

-- ML-ready customer summary (features table)

WITH order_totals AS (
  SELECT
    order_id,
    user_id,
    SUM(sale_price) AS order_total,
    MIN(created_at) AS order_created_at
  FROM `bigquery-public-data.thelook_ecommerce.order_items`
  GROUP BY order_id, user_id
),
max_date AS (
  SELECT MAX(DATE(order_created_at)) AS max_order_date
  FROM order_totals
),
customer_summary AS (
  SELECT
    user_id,
    COUNT(*) AS num_orders,
    ROUND(SUM(order_total), 2) AS total_spend,
    ROUND(AVG(order_total), 2) AS avg_order_value,
    ROUND(MAX(order_total), 2) AS max_order_value,
    MIN(DATE(order_created_at)) AS first_order_date,
    MAX(DATE(order_created_at)) AS last_order_date
  FROM order_totals
  GROUP BY user_id
)
SELECT
  cs.*,
  DATE_DIFF(md.max_order_date, cs.last_order_date, DAY) AS days_since_last_order
FROM customer_summary cs
CROSS JOIN max_date md
ORDER BY total_spend DESC
LIMIT 50;