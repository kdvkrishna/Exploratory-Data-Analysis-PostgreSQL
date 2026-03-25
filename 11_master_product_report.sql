/*
===============================================================================
Script: Product Performance Report (Master View)
Project: E-commerce Exploratory Data Analysis (EDA)
Description: 
    This script creates a comprehensive VIEW that aggregates all product 
    metrics. It calculates revenue, total units sold, gross profit, 
    and classifies products by their contribution to the business.
===============================================================================
*/

CREATE OR REPLACE VIEW report_products AS 

WITH product_aggregation AS (
    SELECT 
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.product_cost,
        -- Total Sales & Volume
        SUM(f.sales_amount) AS total_revenue,
        SUM(f.quantity) AS total_units_sold,
        COUNT(DISTINCT f.order_number) AS total_orders,
        -- Date Metrics
        MAX(f.order_date) AS last_sale_date,
        MIN(f.order_date) AS first_sale_date
    FROM products p
    LEFT JOIN fact f ON p.product_key = f.product_key
    GROUP BY p.product_key, p.product_name, p.category, p.subcategory, p.product_cost
)
SELECT 
    product_key,
    product_name,
    category,
    subcategory,
    total_revenue,
    total_units_sold,
    total_orders,
    -- 1. PROFITABILITY ANALYSIS
    -- Gross Profit = Revenue - (Cost * Quantity)
    (total_revenue - (product_cost * total_units_sold)) AS gross_profit,
    -- Margin %: (Profit / Revenue) * 100
    ROUND(
        ((total_revenue - (product_cost * total_units_sold))::numeric / 
        NULLIF(total_revenue, 0)) * 100, 2
    ) || '%' AS profit_margin_pct,

    -- 2. PRODUCT SEGMENTATION (Performance Logic)
    CASE 
        WHEN total_revenue > 50000 THEN 'Top Seller'
        WHEN total_revenue BETWEEN 10000 AND 50000 THEN 'Mid-Tier'
        WHEN total_revenue > 0 AND total_revenue < 10000 THEN 'Low Volume'
        ELSE 'No Sales'
    END AS performance_segment,

    -- 3. INVENTORY HEALTH (Recency)
    -- How many months since this product last sold? (Dataset end: Jan 2014)
    EXTRACT(MONTH FROM AGE('2014-01-28'::date, last_sale_date)) AS months_since_last_sale,

    -- 4. PRICING METRICS
    -- Average Selling Price (ASP)
    ROUND(total_revenue::numeric / NULLIF(total_units_sold, 0), 2) AS avg_selling_price,
    product_cost AS unit_cost

FROM product_aggregation;

-- VERIFICATION: Test the product report
SELECT * FROM report_products ORDER BY total_revenue LIMIT 10;