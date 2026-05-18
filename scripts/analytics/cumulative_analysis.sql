USE DataWarehouse;
GO

-- ============================================================
-- #2 Cumulative Analysis
-- Running totals and moving averages over time
-- ============================================================

-- Cumulative Sales and Moving Average Price Over Time
SELECT
    order_date,
    total_sales,

    -- Running total of sales over time
    SUM(total_sales) OVER (
        PARTITION BY YEAR(order_date)
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    )                                       AS cumulative_sales,

    -- Moving average of price over time
    AVG(avg_price) OVER (
        PARTITION BY YEAR(order_date)
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    )                                       AS moving_avg_price

FROM (
    -- Subquery: aggregate by month first
    SELECT
        DATEFROMPARTS(YEAR(order_date), MONTH(order_date), 1)   AS order_date,
        SUM(sales_amount)                                        AS total_sales,
        AVG(price)                                               AS avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY
        YEAR(order_date),
        MONTH(order_date)
) monthly_sales
ORDER BY order_date;