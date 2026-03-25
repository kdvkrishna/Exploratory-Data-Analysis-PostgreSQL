/*
===============================================================================
Script: Customer Behavior Report (Master View)
Project: E-commerce Exploratory Data Analysis (EDA)
Description: 
    This script creates a comprehensive VIEW that aggregates all customer 
    metrics into a single table. It includes demographics (Age Groups), 
    lifecycle metrics (Lifespan, Recency), and value metrics (AOV, Segments).
===============================================================================
*/

CREATE OR REPLACE VIEW report_customers AS 

WITH base_query AS (
    SELECT
        f.order_number,
        f.product_key,
        f.order_date,
        f.sales_amount,
        f.quantity,
        c.customer_key,
        c.customer_number, -- Fixed typo: 'custonmer' -> 'customer'
        c.first_name || ' ' || c.last_name AS customer_name,
        EXTRACT(YEAR FROM AGE(c.birthdate))::int AS age
    FROM fact f
    LEFT JOIN customers c ON c.customer_key = f.customer_key
    WHERE f.order_date IS NOT NULL
),
customer_aggregation AS (
    SELECT
        customer_key,
        customer_number,
        customer_name,
        age,
        COUNT(DISTINCT order_number) AS total_orders,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        COUNT(DISTINCT product_key) AS total_products,
        MIN(order_date) AS first_order_date,
        MAX(order_date) AS last_order_date,
        -- Total lifespan in months (Years * 12 + remaining months)
        EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) * 12 + 
        EXTRACT(MONTH FROM AGE(MAX(order_date), MIN(order_date))) AS lifespan_months
    FROM base_query
    GROUP BY customer_key, customer_number, customer_name, age
)
SELECT
    customer_key,
    customer_number,
    customer_name,
    age,
    -- Demographic Segmentation
    CASE 
         WHEN age < 20 THEN 'Under 20'
         WHEN age BETWEEN 20 AND 29 THEN '20-29'
         WHEN age BETWEEN 30 AND 39 THEN '30-39'
         WHEN age BETWEEN 40 AND 49 THEN '40-49'
         ELSE '50 and above'
    END AS age_group,
    -- Loyalty & Value Segmentation
    CASE 
        WHEN lifespan_months >= 12 AND total_sales > 5000 THEN 'VIP'
        WHEN lifespan_months >= 12 AND total_sales <= 5000 THEN 'Regular'
        ELSE 'New'
    END AS customer_segment,
    last_order_date,
    -- Recency: Months since last purchase relative to the end of the dataset (Jan 2014)
    EXTRACT(MONTH FROM AGE('2014-01-28'::date, last_order_date)) AS recency_months,
    total_orders,
    total_sales,
    total_quantity,
    total_products,
    lifespan_months,
    -- Compute Average Order Value (AOV)
    CASE WHEN total_orders = 0 THEN 0
         ELSE ROUND(total_sales::numeric / total_orders, 2)
    END AS avg_order_value,
    -- Compute Average Monthly Spend
    CASE WHEN lifespan_months = 0 THEN total_sales
         ELSE ROUND(total_sales::numeric / lifespan_months, 2)
    END AS avg_monthly_spend
FROM customer_aggregation;

-- VERIFICATION: Test the view
SELECT * FROM report_customers LIMIT 10;