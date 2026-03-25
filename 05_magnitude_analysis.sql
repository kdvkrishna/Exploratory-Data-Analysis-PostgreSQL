/*
===============================================================================
Script: Customer & Catalog Distribution
Project: E-commerce Exploratory Data Analysis (EDA)
Description: 
    This script provides a granular look at our customer demographics 
    and product catalog structure. 
===============================================================================
*/

-- 1. GEOGRAPHIC & DEMOGRAPHIC CONCENTRATION
-- Question: Which countries have our largest customer bases?
SELECT 
    country, 
    COUNT(customer_id) AS total_customers
FROM customers
WHERE country != 'n/a'
GROUP BY country
ORDER BY total_customers DESC;

-- Question: What is the gender distribution of our users?
SELECT 
    gender, 
    COUNT(customer_id) AS total_customers
FROM customers
GROUP BY gender
ORDER BY total_customers DESC;


-- 2. CATALOG MAGNITUDE
-- Question: Which categories offer the most variety of unique products?
SELECT 
    category, 
    COUNT(product_id) AS total_unique_products
FROM products
GROUP BY category
ORDER BY total_unique_products DESC;

-- Question: What is the average production cost across different categories?
SELECT 
    category, 
    ROUND(AVG(product_cost), 2) AS avg_category_cost
FROM products
GROUP BY category
ORDER BY avg_category_cost DESC;


-- 3. SALES VOLUME DISTRIBUTION
-- Question: Which countries are moving the most physical inventory?
SELECT 
    c.country, 
    SUM(f.quantity) AS total_items_sold
FROM fact f
LEFT JOIN customers c ON c.customer_key = f.customer_key
WHERE c.country != 'n/a'
GROUP BY c.country
ORDER BY total_items_sold DESC;