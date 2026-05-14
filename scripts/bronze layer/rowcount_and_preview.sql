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