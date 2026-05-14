-- ============================================================
-- BRONZE LAYER VERIFICATION
-- ============================================================

-- Check row counts for all bronze tables
SELECT COUNT(*) AS row_count FROM bronze.crm_cust_info;
SELECT COUNT(*) AS row_count FROM bronze.crm_prd_info;
SELECT COUNT(*) AS row_count FROM bronze.crm_sales_details;
SELECT COUNT(*) AS row_count FROM bronze.erp_cust_az12;
SELECT COUNT(*) AS row_count FROM bronze.erp_loc_a101;
SELECT COUNT(*) AS row_count FROM bronze.erp_px_cat_g1v2;

-- Preview raw data
SELECT TOP 5 * FROM bronze.crm_cust_info;
SELECT TOP 5 * FROM bronze.crm_prd_info;
SELECT TOP 5 * FROM bronze.crm_sales_details;
SELECT TOP 5 * FROM bronze.erp_cust_az12;
SELECT TOP 5 * FROM bronze.erp_loc_a101;
SELECT TOP 5 * FROM bronze.erp_px_cat_g1v2;

-- ============================================================
-- SILVER LAYER VERIFICATION
-- ============================================================

-- Check row counts for all silver tables
SELECT COUNT(*) AS row_count FROM silver.crm_cust_info;
SELECT COUNT(*) AS row_count FROM silver.crm_prd_info;
SELECT COUNT(*) AS row_count FROM silver.crm_sales_details;
SELECT COUNT(*) AS row_count FROM silver.erp_cust_az12;
SELECT COUNT(*) AS row_count FROM silver.erp_loc_a101;
SELECT COUNT(*) AS row_count FROM silver.erp_px_cat_g1v2;

-- Preview cleaned data
SELECT TOP 5 * FROM silver.crm_cust_info;
SELECT TOP 5 * FROM silver.crm_prd_info;
SELECT TOP 5 * FROM silver.crm_sales_details;
SELECT TOP 5 * FROM silver.erp_cust_az12;
SELECT TOP 5 * FROM silver.erp_loc_a101;
SELECT TOP 5 * FROM silver.erp_px_cat_g1v2;

-- ============================================================
-- GOLD LAYER VERIFICATION
-- ============================================================

-- Preview gold views
SELECT TOP 5 * FROM gold.dim_customers;
SELECT TOP 5 * FROM gold.dim_products;
SELECT TOP 5 * FROM gold.fact_sales;

-- ============================================================
-- REPORTS VERIFICATION
-- ============================================================

-- Customer report
SELECT TOP 10 * FROM gold.report_customers;

-- Product report
SELECT TOP 10 * FROM gold.report_products;

-- Sales report
SELECT * FROM gold.report_sales
ORDER BY order_year, order_month;