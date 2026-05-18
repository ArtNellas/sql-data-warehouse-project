USE DataWarehouse;
GO

-- ============================================================
-- #4 Part-To-Whole Analysis
-- Shows what percentage each category contributes to total
-- ============================================================

-- Category Contribution to Total Sales
WITH category_sales AS (
    SELECT
        p.category,
        SUM(f.sales_amount)                 AS total_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    GROUP BY p.category
)

SELECT
    category,
    total_sales,

    -- Total sales across ALL categories
    SUM(total_sales) OVER ()                AS overall_sales,

    -- Percentage contribution of each category
    ROUND(
        CAST(total_sales AS FLOAT)
        / SUM(total_sales) OVER () * 100
    , 2)                                    AS pct_of_total

FROM category_sales
ORDER BY pct_of_total DESC;