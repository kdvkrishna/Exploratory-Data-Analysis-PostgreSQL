/*
===============================================================================
Script: Dimensions Exploration (EDA)
Project: E-commerce Exploratory Data Analysis (EDA)
Description: 
    Initial exploration of the Dimension tables (Customers and Products).
    The goal is to understand the scope of our catalog and the 
    geographical reach of our customer base.
===============================================================================
*/

-- 1. CUSTOMER GEOGRAPHY EXPLORATION
-- Question: Which countries do our customers come from?
SELECT DISTINCT 
    country 
FROM customers
ORDER BY country ASC;


-- 2. PRODUCT CATALOG EXPLORATION

-- Question: What are the high-level product categories?
SELECT DISTINCT 
    category 
FROM products
ORDER BY category;

-- Question: How many unique subcategories exist in our catalog?
SELECT 
    COUNT(DISTINCT subcategory) AS total_subcategories 
FROM products;

-- Question: What is the hierarchy of Category and Subcategory?
SELECT DISTINCT 
    category, 
    subcategory
FROM products
ORDER BY category, subcategory;


-- 3. PRODUCT LEVEL DETAIL

-- Question: What is the total count of unique products offered?
SELECT 
    COUNT(DISTINCT product_name) AS unique_product_count 
FROM products;

-- Question: Full Catalog View
SELECT DISTINCT 
    category, 
    subcategory, 
    product_name
FROM products
ORDER BY category, subcategory, product_name;