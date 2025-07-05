
-- 1. List all customers
SELECT * FROM customers;

-- 2. Find all orders with their customer names
SELECT 
    o.order_id,
    c.name AS customer_name,
    o.order_date,
    o.total_amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

-- 3. Get total sales amount grouped by country
SELECT 
    c.country,
    SUM(o.total_amount) AS total_sales
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.country
ORDER BY total_sales DESC;

-- 4. Find top 5 customers by total amount spent
SELECT 
    c.name,
    SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 5;

-- 5. Show all order items for a specific order
SELECT 
    oi.order_id,
    oi.product_name,
    oi.quantity,
    oi.price,
    (oi.quantity * oi.price) AS item_total
FROM order_items oi
WHERE oi.order_id = 1001;

-- 6. Calculate average order value
SELECT 
    AVG(total_amount) AS avg_order_value
FROM orders;

-- 7. Create a view for customer orders
CREATE VIEW customer_order_summary AS
SELECT 
    c.customer_id,
    c.name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

-- 8. Query the view
SELECT * FROM customer_order_summary;

-- 9. Use a subquery to find customers who spent more than average
SELECT 
    name, email
FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING SUM(total_amount) > (
        SELECT AVG(total_amount) FROM orders
    )
);

-- 10. Index creation to speed up queries on foreign keys
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
