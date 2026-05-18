USE DataWarehouse;
GO

-- ============================================================
-- #5 Data Segmentation
-- Groups customers and products into meaningful segments
-- ============================================================

-- Product Cost Segmentation
WITH product_segments AS (
    SELECT
        product_key,
        product_name,
        cost,
        CASE
            WHEN cost < 100  THEN '1 - Affordable'
            WHEN cost < 500  THEN '2 - Mid Range'
            WHEN cost < 1000 THEN '3 - Expensive'
            ELSE                  '4 - Very Expensive'
        END                                 AS cost_segment
    FROM gold.dim_products
)

SELECT
    cost_segment,
    COUNT(product_key)                      AS total_products
FROM product_segments
GROUP BY cost_segment
ORDER BY cost_segment;

-- ============================================================
-- Customer Segmentation by Spending
-- ============================================================

WITH customer_spending AS (
    SELECT
        c.customer_key,
        c.first_name,
        c.last_name,
        c.country,
        SUM(f.sales_amount)                 AS total_spending,
        MIN(f.order_date)                   AS first_order,
        MAX(f.order_date)                   AS last_order,
        DATEDIFF(month, MIN(f.order_date),
                        MAX(f.order_date))  AS lifespan_months
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c
        ON f.customer_key = c.customer_key
    GROUP BY
        c.customer_key,
        c.first_name,
        c.last_name,
        c.country
),

customer_segments AS (
    SELECT
        customer_key,
        first_name,
        last_name,
        country,
        total_spending,
        lifespan_months,
        CASE
            WHEN lifespan_months >= 12
                 AND total_spending > 5000  THEN '1 - VIP'
            WHEN lifespan_months >= 12
                 AND total_spending <= 5000 THEN '2 - Regular'
            WHEN lifespan_months < 12       THEN '3 - New Customer'
            ELSE                                 '4 - Unknown'
        END                                 AS customer_segment
    FROM customer_spending
)

SELECT
    customer_segment,
    COUNT(customer_key)                     AS total_customers,
    SUM(total_spending)                     AS total_spending
FROM customer_segments
GROUP BY customer_segment
ORDER BY customer_segment;