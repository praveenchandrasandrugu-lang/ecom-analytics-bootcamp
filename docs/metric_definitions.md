# Metric Definitions

## Total Orders
Count of orders (1 row per order) from  `orders` table.

## Total Revenue
Sum of `sale_price` from `order_items` (1 row per item).

## AOV (Average Order Value)
Average of order totals.
Computed by summing `sale_price`, then averaging those totals.

## Revenue by month
Monthly sum of `sale_price` from `order_items`, grouped by month of `created_at`.

## Top Products by Revenue
Sum of `sale_price` from `order_items`, grouped by product. Joined to `products` to show names.

## Average items per order
Average of `num_of_item` from `orders`
