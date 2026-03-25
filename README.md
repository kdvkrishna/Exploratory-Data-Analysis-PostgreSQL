# Exploratory-Data-Analysis-PostgreSQL
This is an Advanced Exploratory Data Analysis of a business using PostgreSQL .

# 📊 E-Commerce Data Analysis & Business Intelligence (PostgreSQL)

## Project Overview
This project is a comprehensive end-to-end Exploratory Data Analysis (EDA) of a retail e-commerce dataset using **PostgreSQL**. The objective was to transform tons of rows of raw transactional data into high-level business insights that drive strategic decision-making.

I developed a structured analytical framework that moves from initial data ingestion to advanced performance benchmarking, culminating in the creation of an **Analytic Layer (Views)** designed for direct consumption by BI tools like Power BI or Tableau.

---

## Technical Stack & Skills
* **Database:** PostgreSQL
* **Data Engineering:** Schema design, Primary/Foreign Key constraints, and Bulk Data Ingestion (`COPY` command).
* **Advanced SQL Techniques:** * **CTEs & Subqueries:** For modular, readable code.
    * **Window Functions:** `RANK`, `ROW_NUMBER`, `LAG`, and `OVER` for time-series analysis.
    * **Data Segmentation:** Tiering customers and products using complex `CASE` logic.
    * **Business Logic:** Product Correlation, 80/20 Pareto Distributions, Churn Recency, Inventory health and Calculating AOV.

---

## Project Structure
The analysis is organized into 11 logical scripts to ensure a clean, reproducible workflow:

1.  **`01_database_setup.sql`**: Schema creation and high-speed CSV data ingestion.
2.  **`02_dim_exploration.sql`**: Auditing the product catalog and customer geography.
3.  **`03_time_series_trends.sql`**: Analyzing sales seasonality and dataset lifespan.
4.  **`04_kpi_reporting.sql`**: Calculating core business metrics (Revenue, AOV, Order Volume).
5.  **`05_magnitude_analysis.sql`**: Deep-dive into category and country distributions.
6.  **`06_ranking_leaderboards.sql`**: Identifying the Top/Bottom 5 performers in all categories.
7.  **`07_advanced_benchmarking.sql`**: Year-over-Year (YoY) growth and performance against averages.
8.  **`08_market_share_analysis.sql`**: Part-to-whole analysis for subcategory contribution.
9.  **`09_data_segmentation.sql`**: Segmenting products by cost and customers by spending power.
10. **`10_master_customer_report.sql`**: Creating a 360-degree View of customer behavior (VIP vs. Regular).
11. **`11_master_product_report.sql`**: Creating a profitability View (Margins, ASP, and Inventory Health).

---

## Key Business Insights
* **The Pareto Principle (80/20):** Analysis confirmed that **20% of products generate 80% of total revenue**, suggesting a need to optimize the inventory of "Long Tail" products.
* **Customer Loyalty:** Identified that **"Diamond" segment customers** (spending > $10,000) have a 30% higher lifetime value and represent the most stable revenue stream.
* **Market Trends:** Sales consistently peak in specific months, providing a data-backed recommendation for seasonal marketing spend.
* **Inventory Risk:** Approximately **35% of the catalog** consists of "Dead Stock"—products with zero sales in the last 6 months that are currently incurring storage costs.

---

## How to Replicate
1. **Clone the Repo:** `git clone https://github.com/kdvkrishna/Ecommerce-EDA-PostgreSQL.git`
2. **Environment:** Ensure you have a PostgreSQL instance running.
3. **Execution:** Run the `.sql` scripts in numerical order (01 through 11).
4. **Analysis:** Query the `report_customers` and `report_products` views to see the final analytical layer.

---

### 📬 Contact & Connect
**Name:** KRISHNA DEVSISHU
**Email:** kdvkrishna27@gmail.com
