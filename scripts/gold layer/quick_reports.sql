-- Customer report
SELECT TOP 10 * FROM gold.report_customers;

-- Product report
SELECT TOP 10 * FROM gold.report_products;

-- Sales report
SELECT * FROM gold.report_sales
ORDER BY order_year, order_month;