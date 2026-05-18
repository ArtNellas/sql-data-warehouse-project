USE DataWarehouse;
GO

-- ============================================================
-- #1 Changes Over Time Analysis
-- Analyzes how sales metrics trend across months and years
-- ============================================================

-- Monthly Sales Trend
SELECT
    YEAR(order_date)                        AS order_year,
    MONTH(order_date)                       AS order_month,
    DATENAME(month, order_date)             AS month_name,
    SUM(sales_amount)                       AS total_sales,
    COUNT(DISTINCT customer_key)            AS total_customers,
    SUM(quantity)                           AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY
    YEAR(order_date),
    MONTH(order_date),
    DATENAME(month, order_date)
ORDER BY
    order_year,
    order_month;