-- Get product count by category
SELECT category, COUNT(*) AS num_products
FROM products
GROUP BY category;
