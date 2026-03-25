/*
===============================================================================
Script: Ranking & Leaderboard Analysis
Project: E-commerce Exploratory Data Analysis (EDA)
Description: 
    This script identifies high-performers and under-performers across 
    products, subcategories, and customers. It utilizes Window Functions 
    and Aggregations to rank business entities by revenue and volume.
===============================================================================
*/

-- 1. PRODUCT PERFORMANCE RANKINGS

-- Top 5 Products by Revenue
SELECT 
    p.product_name, 
    SUM(f.sales_amount) AS total_revenue
FROM products p
JOIN fact f ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC
LIMIT 5;

-- Worst 5 Products by Revenue (Candidate for discontinuation or promotion)
SELECT 
    p.product_name, 
    SUM(f.sales_amount) AS total_revenue
FROM products p
JOIN fact f ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue ASC
LIMIT 5;

-- Advanced Ranking: Using Window Functions to find the bottom 5 products
-- This approach is more flexible for complex filtering.
SELECT *
FROM (
    SELECT 
        p.product_name, 
        SUM(f.sales_amount) AS total_revenue,
        ROW_NUMBER() OVER(ORDER BY SUM(f.sales_amount) ASC) AS product_rank
    FROM products p
    JOIN fact f ON p.product_key = f.product_key
    GROUP BY p.product_name
) AS ranked_products
WHERE product_rank <= 5;


-- 2. SUBCATEGORY LEADERBOARDS

-- Top 5 Subcategories by Revenue
SELECT 
    p.subcategory, 
    SUM(f.sales_amount) AS total_revenue
FROM products p
JOIN fact f ON p.product_key = f.product_key
GROUP BY p.subcategory
ORDER BY total_revenue DESC
LIMIT 5;

-- Worst 5 Subcategories by Revenue
SELECT 
    p.subcategory, 
    SUM(f.sales_amount) AS total_revenue
FROM products p
JOIN fact f ON p.product_key = f.product_key
GROUP BY p.subcategory
ORDER BY total_revenue ASC
LIMIT 5;


-- 3. CUSTOMER ENGAGEMENT RANKINGS

-- Top 10 High-Value Customers (Highest Revenue Contributors)
SELECT 
    c.customer_key, 
    c.first_name || ' ' || c.last_name AS customer_name, 
    SUM(f.sales_amount) AS total_revenue
FROM customers c
JOIN fact f ON c.customer_key = f.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY total_revenue DESC
LIMIT 10;

-- One-Time Buyers (Candidates for Re-engagement Campaigns)
SELECT 
    c.customer_key, 
    c.first_name || ' ' || c.last_name AS customer_name, 
    COUNT(f.order_number) AS total_orders
FROM customers c
JOIN fact f ON c.customer_key = f.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
HAVING COUNT(f.order_number) = 1;

-- Loyalists: Customers with 10 or More Orders
SELECT 
    c.customer_key, 
    c.first_name || ' ' || c.last_name AS customer_name, 
    COUNT(f.order_number) AS total_orders
FROM customers c
JOIN fact f ON c.customer_key = f.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
HAVING COUNT(f.order_number) >= 10 
ORDER BY total_orders DESC;