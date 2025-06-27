-- Update stock for a product
UPDATE products
SET stock = stock + 10
WHERE name = 'Laptop';
