USE DataWarehouse;
GO

-- ============================================================
-- Product Report
-- Summarizes key product metrics and segments
-- ============================================================

CREATE OR ALTER VIEW gold.report_products AS

WITH base_query AS (
-- ----------------------------------------
-- 1) Base Query: Retrieve core columns
-- ----------------------------------------
    SELECT
        f.order_number,
        f.order_date,
        f.sales_amount,
        f.quantity,
        p.product_key,
        p.product_number,
        p.product_name,
        p.category,
        p.subcategory,
        p.product_line,
        p.cost,
        p.maintenance
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
),

product_aggregates AS (
-- ----------------------------------------
-- 2) Aggregate: Calculate product metrics
-- ----------------------------------------
    SELECT
        product_key,
        product_number,
        product_name,
        category,
        subcategory,
        product_line,
        cost,
        maintenance,
        COUNT(DISTINCT order_number)        AS total_orders,
        SUM(sales_amount)                   AS total_sales,
        SUM(quantity)                       AS total_quantity,
        AVG(sales_amount)                   AS avg_order_value,
        MIN(order_date)                     AS first_order_date,
        MAX(order_date)                     AS last_order_date,
        DATEDIFF(month, MIN(order_date),
                        MAX(order_date))    AS lifespan_months,
        DATEDIFF(month, MAX(order_date),
                        GETDATE())          AS months_since_last_order
    FROM base_query
    GROUP BY
        product_key,
        product_number,
        product_name,
        category,
        subcategory,
        product_line,
        cost,
        maintenance
),

product_segments AS (
-- ----------------------------------------
-- 3) Segment: Classify products
-- ----------------------------------------
    SELECT
        product_key,
        product_number,
        product_name,
        category,
        subcategory,
        product_line,
        cost,
        maintenance,
        total_orders,
        total_sales,
        total_quantity,
        avg_order_value,
        first_order_date,
        last_order_date,
        lifespan_months,
        months_since_last_order,

        -- Product Performance Segmentation
        CASE
            WHEN total_sales >= 50000 THEN 'High Performer'
            WHEN total_sales >= 10000 THEN 'Mid Performer'
            ELSE 'Low Performer'
        END AS product_segment,

        -- Recency Segmentation
        CASE
            WHEN months_since_last_order <= 12  THEN 'Recently Ordered'
            WHEN months_since_last_order <= 24  THEN 'Ordered 1-2 Years Ago'
            ELSE 'Not Ordered Recently'
        END AS recency_segment,

        -- Cost Range Segmentation
        CASE
            WHEN cost >= 500  THEN 'Expensive'
            WHEN cost >= 100  THEN 'Mid Range'
            ELSE 'Affordable'
        END AS cost_segment

    FROM product_aggregates
)

-- ----------------------------------------
-- 4) Final Output
-- ----------------------------------------
SELECT
    product_key,
    product_number,
    product_name,
    category,
    subcategory,
    product_line,
    cost,
    cost_segment,
    maintenance,
    total_orders,
    total_sales,
    total_quantity,
    avg_order_value,
    first_order_date,
    last_order_date,
    lifespan_months,
    months_since_last_order,
    product_segment,
    recency_segment
FROM product_segments;
GO