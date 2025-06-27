-- Get orders with product names
SELECT o.order_id, p.name AS product_name, o.quantity, o.order_date
FROM orders o
INNER JOIN products p ON o.product_id = p.product_id;
