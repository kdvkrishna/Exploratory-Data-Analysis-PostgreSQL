/*
===============================================================================
Script: Data Segmentation & Customer Profiling
Project: E-commerce Exploratory Data Analysis (EDA)
Description: 
    This script categorizes products and customers into distinct tiers 
    based on cost, spending behavior, and tenure. This is a foundational 
    step for targeted marketing and inventory management.
===============================================================================
*/

-- 1. PRODUCT COST SEGMENTATION
-- Question: How is our product catalog distributed across price points?
WITH product_segments AS (
    SELECT 
        product_key,
        product_cost,
        CASE 
            WHEN product_cost > 0 AND product_cost <= 100 THEN 'Budget (<$100)'
            WHEN product_cost > 100 AND product_cost <= 400 THEN 'Economy ($100-$400)'
            WHEN product_cost > 400 AND product_cost <= 1200 THEN 'Mid-Range ($400-$1200)'
            ELSE 'Premium (>$1200)'
        END AS cost_bracket
    FROM products
    WHERE product_cost != 0 -- Excluding items with no cost data
) 
SELECT 
    cost_bracket,
    COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_bracket
ORDER BY MIN(product_cost) ASC;


-- 2. CUSTOMER SPENDING SEGMENTATION
-- Question: What percentage of our customers fall into High-Value tiers?
WITH customer_spending AS (
    SELECT 
        c.customer_key,
        SUM(f.sales_amount) AS total_spent
    FROM customers c
    JOIN fact f ON c.customer_key = f.customer_key
    GROUP BY c.customer_key
)
SELECT 
    CASE 
        WHEN total_spent < 1000 THEN 'Standard'
        WHEN total_spent BETWEEN 1000 AND 4999 THEN 'Silver'
        WHEN total_spent BETWEEN 5000 AND 9999 THEN 'Gold'
        ELSE 'Diamond'
    END AS spending_segment,
    COUNT(customer_key) AS customer_count
FROM customer_spending
GROUP BY 1
ORDER BY MIN(total_spent) ASC;


-- 3. THE MASTER SEGMENTATION QUERY (Combined Metrics)
-- Question: How many customers do we have in each tenure (loyalty) bracket?
WITH customer_raw_metrics AS (
    SELECT 
        c.customer_key,
        c.first_name || ' ' || c.last_name AS customer_name,
        SUM(f.sales_amount) AS total_revenue,
        COUNT(f.customer_key) AS total_orders,
        -- Average Order Value (AOV)
        ROUND(SUM(f.sales_amount)::numeric / NULLIF(COUNT(f.customer_key), 0), 2) AS aov,
        -- Tenure: Total days from first to last purchase
        (MAX(f.order_date) - MIN(f.order_date)) AS tenure_days
    FROM customers c
    JOIN fact f ON c.customer_key = f.customer_key
    GROUP BY c.customer_key, customer_name
)
SELECT 
    CASE 
        WHEN tenure_days <= 180 THEN 'New (<6 Months)'
        WHEN tenure_days BETWEEN 181 AND 365 THEN 'Developing (<1 Year)'
        WHEN tenure_days BETWEEN 366 AND 730 THEN 'Regular (1-2 Years)'
        ELSE 'Loyal Veteran (>2 Years)'
    END AS tenure_segment,
    COUNT(customer_key) AS total_customers
FROM customer_raw_metrics
GROUP BY tenure_segment
ORDER BY MIN(tenure_days) ASC;