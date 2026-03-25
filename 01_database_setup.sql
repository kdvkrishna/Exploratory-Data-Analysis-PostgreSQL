/*
===============================================================================
Script: Table Creation and Data Import
Project: E-commerce Exploratory Data Analysis (EDA)
Database: PostgreSQL
Description: 
    This script initializes the database schema by creating the 
    Dimensions (Customers, Products) and Fact (Sales) tables. 
    It also handles the bulk data ingestion from CSV files.
===============================================================================
*/

-- 1. CLEANUP: Remove tables if they already exist
DROP TABLE IF EXISTS fact;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;

-- 2. CREATE DIMENSION TABLES

-- Customer Dimension: Stores demographic and identity data
CREATE TABLE customers (
    customer_key    INT PRIMARY KEY,
    customer_id     INT,
    customer_number VARCHAR(50), 
    first_name      VARCHAR(50),
    last_name       VARCHAR(50),
    country         VARCHAR(50),
    marital_status  VARCHAR(20),
    gender          VARCHAR(10),
    birthdate       DATE,
    create_date     DATE
);

-- Product Dimension: Stores product catalog details
CREATE TABLE products (
    product_key     INT PRIMARY KEY, -- Primary Key defined at creation
    product_id      INT,
    product_number  VARCHAR(50),
    product_name    VARCHAR(100),
    category_id     VARCHAR(50),
    category        VARCHAR(50),
    subcategory     VARCHAR(50),
    maintenance     BOOLEAN,
    product_cost    DECIMAL(10, 2),
    product_line    VARCHAR(50),
    start_date      DATE
);

-- 3. CREATE FACT TABLE

-- Sales Fact: Stores transactional data
CREATE TABLE fact (
    order_number    VARCHAR(50),
    product_key     INT,
    customer_key    INT,
    order_date      DATE,
    shipping_date   DATE,
    due_date        DATE,
    sales_amount    INT, 
    quantity        INT,
    price           DECIMAL(10, 2),
    -- Foreign Key constraints (Optional but recommended for data integrity)
    CONSTRAINT fk_product FOREIGN KEY (product_key) REFERENCES products(product_key),
    CONSTRAINT fk_customer FOREIGN KEY (customer_key) REFERENCES customers(customer_key)
);

-- 4. DATA INGESTION (Importing CSVs)
-- Note: Ensure PostgreSQL has read permissions for these file paths.

COPY customers 
FROM 'E:/AAKDV/PROJECT1_EDA_SQL/Dataset/sql-data-analytics-project/datasets/flat-files/dim_customers.csv' 
WITH (FORMAT csv, HEADER TRUE);

COPY products 
FROM 'E:/AAKDV/PROJECT1_EDA_SQL/Dataset/sql-data-analytics-project/datasets/flat-files/dim_products.csv' 
WITH (FORMAT csv, HEADER TRUE);

COPY fact 
FROM 'E:/AAKDV/PROJECT1_EDA_SQL/Dataset/sql-data-analytics-project/datasets/flat-files/fact_sales.csv' 
WITH (FORMAT csv, HEADER TRUE);

-- 5. VERIFICATION: Checking the record counts
SELECT 'customers' AS table_name, COUNT(*) FROM customers
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'fact', COUNT(*) FROM fact;