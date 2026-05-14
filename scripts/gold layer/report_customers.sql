USE DataWarehouse;
GO

-- ============================================================
-- Customer Report
-- Summarizes key customer metrics and segments
-- ============================================================

CREATE OR ALTER VIEW gold.report_customers AS

WITH base_query AS (
-- ----------------------------------------
-- 1) Base Query: Retrieve core columns
-- ----------------------------------------
    SELECT
        f.order_number,
        f.order_date,
        f.sales_amount,
        f.quantity,
        c.customer_key,
        c.customer_number,
        c.first_name,
        c.last_name,
        c.country,
        c.gender,
        c.marital_status,
        c.birthdate,
        c.create_date
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c
        ON f.customer_key = c.customer_key
    WHERE f.order_date IS NOT NULL
),

customer_aggregates AS (
-- ----------------------------------------
-- 2) Aggregate: Calculate customer metrics
-- ----------------------------------------
    SELECT
        customer_key,
        customer_number,
        first_name,
        last_name,
        country,
        gender,
        marital_status,
        birthdate,
        create_date,
        MIN(order_date)                     AS first_order_date,
        MAX(order_date)                     AS last_order_date,
        DATEDIFF(month, MIN(order_date),
                        MAX(order_date))    AS lifespan_months,
        DATEDIFF(month, MAX(order_date),
                        GETDATE())          AS months_since_last_order,
        COUNT(DISTINCT order_number)        AS total_orders,
        SUM(sales_amount)                   AS total_sales,
        SUM(quantity)                       AS total_quantity,
        AVG(sales_amount)                   AS avg_order_value
    FROM base_query
    GROUP BY
        customer_key,
        customer_number,
        first_name,
        last_name,
        country,
        gender,
        marital_status,
        birthdate,
        create_date
)

-- ----------------------------------------
-- 3) Final Output: Add segments
-- ----------------------------------------
SELECT
    customer_key,
    customer_number,
    first_name,
    last_name,
    country,
    gender,
    marital_status,
    birthdate,
    DATEDIFF(year, birthdate, GETDATE())    AS age,
    create_date,
    first_order_date,
    last_order_date,
    lifespan_months,
    months_since_last_order,
    total_orders,
    total_sales,
    total_quantity,
    avg_order_value,

    -- Customer Segmentation
    CASE
        WHEN months_since_last_order <= 12
             AND total_sales > 5000  THEN 'VIP'
        WHEN months_since_last_order <= 12
             AND total_sales <= 5000 THEN 'Regular'
        ELSE 'Inactive'
    END AS customer_segment,

    -- Age Group Segmentation
    CASE
        WHEN DATEDIFF(year, birthdate, GETDATE()) < 30 THEN 'Under 30'
        WHEN DATEDIFF(year, birthdate, GETDATE()) BETWEEN 30 AND 44 THEN '30-44'
        WHEN DATEDIFF(year, birthdate, GETDATE()) BETWEEN 45 AND 60 THEN '45-60'
        ELSE 'Over 60'
    END AS age_group

FROM customer_aggregates;
GO