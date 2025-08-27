-- ============================================================
-- This script performs data quality checks across multiple domains:
-- 1. Customer Information: Ensures primary key integrity, removes whitespace, and checks categorical consistency.
-- 2. Product Information: Validates primary keys, product names, costs, and date consistency.
-- 3. Sales Transactions: Validates date fields and consistency between sales, quantity, and price.
-- 4. ERP Customer Data: Cleans customer IDs, validates birthdates, and standardizes gender values.
-- 5. Location Data: Standardizes country values and validates IDs.
-- 6. Category Data: Ensures consistency in categories, subcategories, and maintenance fields.
-- ============================================================

-- ============================================================
-- Customer Information Checks
-- ============================================================
-- Check for NULLs or duplicates in primary key
SELECT cst_id, COUNT(*) AS record_count
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check for unwanted spaces in names
SELECT cst_id, cst_firstname, cst_lastname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)
   OR cst_lastname != TRIM(cst_lastname);

-- Check for unwanted spaces in gender
SELECT cst_id, cst_gndr
FROM bronze.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr);

-- Distinct gender values
SELECT DISTINCT TRIM(cst_gndr) AS standardized_gender
FROM bronze.crm_cust_info;

-- Distinct marital status values
SELECT DISTINCT TRIM(cst_marital_status) AS standardized_marital_status
FROM bronze.crm_cust_info;


-- ============================================================
-- Product Information Checks
-- ============================================================
-- Check for NULLs or duplicates in primary key
SELECT prd_id, COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Check for unwanted spaces in product names
SELECT prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Check for NULL or negative costs
SELECT prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Distinct product lines
SELECT DISTINCT prd_line
FROM bronze.crm_prd_info;

-- Check invalid date ranges
SELECT *
FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- Check date overlaps
SELECT prd_id, prd_key, prd_nm, prd_start_dt, prd_end_dt,
       LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt) - 1 AS prd_end_dt_test
FROM bronze.crm_prd_info
WHERE prd_key IN ('AC-HE-HL-U509-R', 'AC-HE-HL-U509');


-- ============================================================
-- Sales Transactions Checks
-- ============================================================
-- Invalid order dates
SELECT NULLIF(sls_order_dt, 0) AS sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0 OR LEN(sls_order_dt) != 8 OR sls_order_dt > 205000101 OR sls_order_dt < 19300101;

-- Invalid ship dates
SELECT NULLIF(sls_ship_dt, 0) AS sls_ship_dt
FROM bronze.crm_sales_details
WHERE sls_ship_dt <= 0 OR LEN(sls_ship_dt) != 8 OR sls_ship_dt > 205000101 OR sls_ship_dt < 19300101;

-- Invalid due dates
SELECT NULLIF(sls_due_dt, 0) AS sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0 OR LEN(sls_due_dt) != 8 OR sls_due_dt > 205000101 OR sls_due_dt < 19300101;

-- Inconsistent order, ship, or due dates
SELECT *
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt;

-- Check consistency between sales, quantity, and price
SELECT DISTINCT sls_sales AS sls_old_sales, sls_quantity, sls_price AS sls_old_price,
       CASE WHEN sls_sales IS NULL OR sls_sales <=0 OR sls_sales != sls_quantity * ABS(sls_price)
            THEN sls_quantity * ABS(sls_price) ELSE sls_sales END AS sls_sales,
       CASE WHEN sls_price IS NULL OR sls_price <= 0
            THEN sls_sales / NULLIF(sls_quantity, 0) ELSE sls_price END AS sls_price
FROM bronze.crm_sales_details
WHERE sls_sales = sls_quantity * sls_price OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
   OR sls_sales <= 0 OR sls_quantity < 0 OR sls_price <= 0;


-- ============================================================
-- ERP Customer Data Checks
-- ============================================================
-- Clean customer IDs
SELECT cid,
       CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid)) ELSE cid END AS cid
FROM bronze.erp_cust_az12;

-- Identify out-of-range dates
SELECT DISTINCT bdate
FROM bronze.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE();

-- Standardize gender values
SELECT DISTINCT gen,
       CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
            WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
            ELSE 'N/A' END AS gen_test
FROM bronze.erp_cust_az12;


-- ============================================================
-- Location Data Checks
-- ============================================================
-- Clean customer IDs
SELECT cid, REPLACE(cid, '-', '') AS cid_test, cntry
FROM bronze.erp_loc_a101;

-- Check for valid customer keys
SELECT cst_key FROM silver.crm_cust_info;

-- Standardize country values
SELECT DISTINCT cntry AS old_cntry,
       CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
            WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
            WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'N/A'
            ELSE TRIM(cntry) END AS cntry
FROM bronze.erp_loc_a101
ORDER BY cntry;


-- ============================================================
-- Category Data Checks
-- ============================================================
-- Check for unwanted spaces
SELECT *
FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance);

-- Distinct categories
SELECT DISTINCT cat FROM bronze.erp_px_cat_g1v2;

-- Distinct subcategories
SELECT DISTINCT subcat FROM bronze.erp_px_cat_g1v2;

-- Distinct maintenance values
SELECT DISTINCT maintenance FROM bronze.erp_px_cat_g1v2;
