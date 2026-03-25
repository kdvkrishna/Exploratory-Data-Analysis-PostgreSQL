/*
===============================================================================
Script: Date and Time Exploration
Project: E-commerce Exploratory Data Analysis (EDA)
Description: 
    Time-series analysis focusing on sales trends, customer demographics,
    and cumulative growth. This script identifies the lifespan of the 
    dataset and the seasonality of sales.
===============================================================================
*/

-- 1. DATASET LIFESPAN
-- Question: What is the date range of our transactional data?
SELECT 
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    AGE(MAX(order_date), MIN(order_date)) AS total_timespan
FROM fact;


-- 2. CUSTOMER DEMOGRAPHICS
-- Question: What is the age range of our customer base?
SELECT
    MIN(birthdate) AS oldest_customer_birth,
    MAX(birthdate) AS youngest_customer_birth,
    -- Calculating the total age range using the AGE function
    EXTRACT(YEAR FROM AGE(MAX(birthdate), MIN(birthdate))) AS age_range_years
FROM customers;


-- 3. YEARLY SALES PERFORMANCE
-- Question: How has revenue and customer acquisition evolved year-over-year?
SELECT 
    EXTRACT(YEAR FROM order_date) AS order_year, 
    SUM(sales_amount) AS total_revenue,  
    COUNT(DISTINCT customer_key) AS active_customers
FROM fact
WHERE order_date IS NOT NULL
GROUP BY order_year
ORDER BY order_year;


-- 4. MONTHLY TRENDS & SEASONALITY
-- Question: Are there specific months where sales consistently spike?
SELECT
    EXTRACT(YEAR FROM order_date) AS order_year,
    EXTRACT(MONTH FROM order_date) AS order_month,
    SUM(sales_amount) AS total_revenue,  
    COUNT(DISTINCT customer_key) AS active_customers
FROM fact
WHERE order_date IS NOT NULL
GROUP BY order_year, order_month
ORDER BY order_year, order_month;


-- 5. CUMULATIVE GROWTH ANALYSIS (RUNNING TOTAL)
-- Question: What is the total revenue growth over the entire project timeline?

WITH monthly_sales AS (
    -- First, we aggregate sales by month-year
    SELECT
        DATE_TRUNC('month', order_date) AS raw_month,
        SUM(sales_amount) AS monthly_revenue
    FROM fact
    WHERE order_date IS NOT NULL
    GROUP BY raw_month
)
SELECT
	TO_CHAR(raw_month, 'Mon-YYYY') AS sales_month,
    monthly_revenue,
    -- Window Function to calculate the Running Total over time
    SUM(monthly_revenue) OVER (ORDER BY raw_month) AS running_total_revenue
FROM monthly_sales
ORDER BY raw_month;