USE DataWarehouse;
GO

-- ============================================================
-- Sales Report
-- Summarizes key sales metrics and trends over time
-- ============================================================

CREATE OR ALTER VIEW gold.report_sales AS

WITH base_query AS (
-- ----------------------------------------
-- 1) Base Query: Retrieve core columns
-- ----------------------------------------
    SELECT
        f.order_number,
        f.order_date,
        f.sales_amount,
        f.quantity,
        f.price,
        f.product_key,
        f.customer_key,
        YEAR(f.order_date)                  AS order_year,
        MONTH(f.order_date)                 AS order_month
    FROM gold.fact_sales f
    WHERE f.order_date IS NOT NULL
),

monthly_aggregates AS (
-- ----------------------------------------
-- 2) Aggregate: Calculate monthly metrics
-- ----------------------------------------
    SELECT
        order_year,
        order_month,
        SUM(sales_amount)                   AS total_sales,
        COUNT(DISTINCT order_number)        AS total_orders,
        COUNT(DISTINCT customer_key)        AS total_customers,
        COUNT(DISTINCT product_key)         AS total_products,
        SUM(quantity)                       AS total_quantity,
        AVG(sales_amount)                   AS avg_order_value
    FROM base_query
    GROUP BY
        order_year,
        order_month
)

-- ----------------------------------------
-- 3) Final Output: Add running totals
-- ----------------------------------------
SELECT
    order_year,
    order_month,
    total_sales,
    total_orders,
    total_customers,
    total_products,
    total_quantity,
    avg_order_value,

    -- Running cumulative total of sales
    SUM(total_sales) OVER (
        PARTITION BY order_year
        ORDER BY order_month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    )                                       AS cumulative_sales,

    -- Previous month sales for comparison
    LAG(total_sales) OVER (
        ORDER BY order_year, order_month
    )                                       AS prev_month_sales,

    -- Month over month change
    total_sales - LAG(total_sales) OVER (
        ORDER BY order_year, order_month
    )                                       AS mom_change,

    -- Year to date average sales
    AVG(total_sales) OVER (
        PARTITION BY order_year
        ORDER BY order_month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    )                                       AS ytd_avg_sales

FROM monthly_aggregates
GO