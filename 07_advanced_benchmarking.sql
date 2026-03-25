/*
===============================================================================
Script: Advanced Performance Analysis (Benchmarking)
Project: E-commerce Exploratory Data Analysis (EDA)
Description: 
    This script performs complex time-series benchmarking. It compares 
    each product's yearly sales against its own historical average and 
    calculates Year-over-Year (YoY) growth using Window Functions.
===============================================================================
*/

-- 1. YEARLY PRODUCT PERFORMANCE & GROWTH
-- Question: Is a product trending up or down compared to its past?

WITH yearly_product_sales AS (
    SELECT 
        EXTRACT(YEAR FROM f.order_date) AS year_of_sales,
        p.product_name,
        SUM(f.sales_amount) AS total_sales
    FROM fact f
    JOIN products p ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY 1, 2
)
SELECT
    year_of_sales,
    product_name,
    total_sales,
    
    -- BENCHMARK 1: Comparison vs. Product's Lifetime Average
    ROUND(AVG(total_sales) OVER(PARTITION BY product_name), 0) AS lifetime_avg_sales,
    CASE 
        WHEN total_sales > AVG(total_sales) OVER(PARTITION BY product_name) THEN 'Above Avg'
        WHEN total_sales < AVG(total_sales) OVER(PARTITION BY product_name) THEN 'Below Avg'
        ELSE 'Average'
    END AS performance_status,

    -- BENCHMARK 2: Year-over-Year (YoY) Growth
    -- Using LAG to fetch the previous year's sales
    LAG(total_sales) OVER w AS previous_year_sales,
    
    -- Absolute Growth
    (total_sales - LAG(total_sales) OVER w) AS yearly_revenue_delta,
    
    -- Percentage Growth (Handled with NULLIF to prevent division by zero)
    ROUND(
        ((total_sales - LAG(total_sales) OVER w)::numeric / 
        NULLIF(LAG(total_sales) OVER w, 0)) * 100, 
    2) || '%' AS growth_percentage

FROM yearly_product_sales
-- Defining a named window for better readability and maintenance
WINDOW w AS (PARTITION BY product_name ORDER BY year_of_sales)
ORDER BY product_name, year_of_sales;

-- 2. Identifying High-Value Customers who have stopped purchasing
-- Which "VIP" customers (those who spent > $5,000) haven't bought anything in the last 6 months of the dataset?
-- (Reference Date: 2014-01-28)
SELECT 
    customer_name,
    total_sales,
    last_order_date,
    ('2014-01-28'::date - last_order_date) AS days_since_last_purchase
FROM report_customers -- Using the VIEW we created earlier
WHERE customer_segment = 'VIP' 
  AND ('2014-01-28'::date - last_order_date) > 180
ORDER BY days_since_last_purchase DESC;


-- 3. Product Correlation
-- Question: Which products are most frequently purchased in the same order?
SELECT 
    p1.product_name AS product_a, 
    p2.product_name AS product_b, 
    COUNT(*) AS times_bought_together
FROM fact f1
JOIN fact f2 ON f1.order_number = f2.order_number AND f1.product_key < f2.product_key
JOIN products p1 ON f1.product_key = p1.product_key
JOIN products p2 ON f2.product_key = p2.product_key
GROUP BY 1, 2
ORDER BY times_bought_together DESC
LIMIT 10;

-- 4. Pareto Analysis
-- Problem: Prove the 80/20 rule. Does the top 20% of our products generate 80% of our revenue?

-- Calculating the Cumulative Percentage of Revenue by Product
WITH product_revenue AS (
    SELECT 
        p.product_name, 
        SUM(f.sales_amount) AS revenue
    FROM fact f
    JOIN products p ON f.product_key = p.product_key
    GROUP BY 1
),
running_revenue AS (
    SELECT 
        product_name,
        revenue,
        SUM(revenue) OVER (ORDER BY revenue DESC) AS cumulative_revenue,
        SUM(revenue) OVER () AS total_revenue
    FROM product_revenue
)
SELECT 
    product_name,
    revenue,
    ROUND((cumulative_revenue / total_revenue) * 100, 2) AS pct_of_total_revenue
FROM running_revenue
ORDER BY revenue DESC;


-- 5. INVENTORY HEALTH (NON-PERFORMING PRODUCTS)
-- Question: Which products in our catalog have NEVER been sold?
SELECT 
    p.category,
    p.product_name,
    p.product_cost
FROM products p
LEFT JOIN fact f ON p.product_key = f.product_key
WHERE f.product_key IS NULL -- This finds products with no matches in the Sales table
ORDER BY p.category, p.product_name;