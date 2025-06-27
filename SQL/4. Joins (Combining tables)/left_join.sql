-- Get all products and their orders (if any)
SELECT p.name, o.order_id, o.quantity
FROM products p
LEFT JOIN orders o ON p.product_id = o.product_id;
