USE DataWarehouse;
GO

-- ============================================================
-- #3 Performance Analysis
-- Compares each product's performance against benchmarks
-- ============================================================

-- Year over Year Performance by Product
WITH yearly_product_sales AS (
    SELECT
        YEAR(f.order_date)                  AS order_year,
        p.product_name,
        SUM(f.sales_amount)                 AS total_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY
        YEAR(f.order_date),
        p.product_name
)

SELECT
    order_year,
    product_name,
    total_sales,

    -- Average sales across all years for this product
    AVG(total_sales) OVER (
        PARTITION BY product_name
    )                                       AS avg_sales,

    -- Difference from the average
    total_sales - AVG(total_sales) OVER (
        PARTITION BY product_name
    )                                       AS diff_from_avg,

    -- Performance vs average
    CASE
        WHEN total_sales > AVG(total_sales) OVER (PARTITION BY product_name)
            THEN 'Above Average'
        WHEN total_sales < AVG(total_sales) OVER (PARTITION BY product_name)
            THEN 'Below Average'
        ELSE 'Average'
    END                                     AS avg_performance,

    -- Previous year sales using LAG
    LAG(total_sales) OVER (
        PARTITION BY product_name
        ORDER BY order_year
    )                                       AS prev_year_sales,

    -- Year over year change
    total_sales - LAG(total_sales) OVER (
        PARTITION BY product_name
        ORDER BY order_year
    )                                       AS yoy_change,

    -- Year over year performance
    CASE
        WHEN total_sales > LAG(total_sales) OVER (
                PARTITION BY product_name ORDER BY order_year)
            THEN 'Increase'
        WHEN total_sales < LAG(total_sales) OVER (
                PARTITION BY product_name ORDER BY order_year)
            THEN 'Decrease'
        ELSE 'No Change'
    END                                     AS yoy_performance

FROM yearly_product_sales
ORDER BY product_name, order_year;