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