/*
===============================================================================
Script: Key Performance Indicators (KPIs)
Project: E-commerce Exploratory Data Analysis (EDA)
Description: 
    Aggregation and high-level metric calculation. This script summarizes 
    total revenue, order volumes, customer demographics, and business 
    efficiency metrics (AOV, Average Price).
===============================================================================
*/

-- 1. SALES PERFORMANCE METRICS

-- Total Revenue Generated
SELECT SUM(sales_amount) AS total_revenue FROM fact;

-- High-Volume Markets: Countries with over $2M in sales
SELECT 
    c.country, 
    SUM(f.sales_amount) AS total_sales
FROM customers c
JOIN fact f ON c.customer_key = f.customer_key
WHERE c.country != 'n/a'
GROUP BY c.country
HAVING SUM(f.sales_amount) > 2000000
ORDER BY total_sales DESC;

-- Inventory Movement: Total items sold
SELECT SUM(quantity) AS total_items_sold FROM fact;

-- Order Volume: Comparison of raw row count vs. unique transaction IDs
SELECT
    COUNT(order_number) AS total_transaction_rows,
    COUNT(DISTINCT order_number) AS total_unique_orders
FROM fact;

-- Price Analysis: Average unit price sold
SELECT ROUND(AVG(price), 2) AS avg_unit_price FROM fact;

-- Business Efficiency: Average Order Value (AOV)
SELECT 
    ROUND(SUM(sales_amount)::numeric / COUNT(DISTINCT order_number), 2) AS avg_order_value 
FROM fact;


-- 2. CUSTOMER BASE OVERVIEW

-- Total Customer Reach
SELECT COUNT(customer_id) AS total_registered_customers FROM customers;


-- 3. EXECUTIVE SUMMARY REPORT
-- Question: Can we see all top-level KPIs in a single view?
/* This query uses UNION ALL to pivot multiple different metrics into 
     a single vertical list for easier reporting.
*/

SELECT 'Total Revenue' AS kpi_name, SUM(sales_amount) AS kpi_value FROM fact 
UNION ALL
SELECT 'Total Items Sold', SUM(quantity) FROM fact 
UNION ALL
SELECT 'Total Unique Orders', COUNT(DISTINCT order_number) FROM fact
UNION ALL
SELECT 'Average Unit Price', ROUND(AVG(price), 2) FROM fact
UNION ALL
SELECT 'Average Order Value', ROUND(SUM(sales_amount)::numeric / COUNT(DISTINCT order_number), 2) FROM fact
UNION ALL
SELECT 'Total Customers', COUNT(customer_id) FROM customers;