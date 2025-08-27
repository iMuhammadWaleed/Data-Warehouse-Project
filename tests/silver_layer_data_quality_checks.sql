-- ============================================================
-- Script Name: silver_layer_data_quality_checks.sql
-- Purpose    : Perform Data Quality (DQ) checks on Silver layer
--              CRM, ERP, and Sales data to ensure:
--              - Uniqueness of keys
--              - Standardized values
--              - Valid date ranges
--              - Data consistency & accuracy
-- ============================================================


-- ============================================================
-- Customer Information Quality Checks
-- ============================================================

-- 1. Check for NULLs or Duplicates in Primary Key (cst_id)
--    Ensures uniqueness and completeness of customer records
SELECT
    cst_id,
    COUNT(*) AS record_count
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- 2. Check for unwanted leading/trailing spaces in customer names
SELECT
    cst_id,
    cst_firstname,
    cst_lastname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)
   OR cst_lastname != TRIM(cst_lastname);

-- 3. Check for unwanted spaces in gender values
SELECT
    cst_id,
    cst_gndr
FROM silver.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr);

-- 4. View distinct gender values (should be standardized: M/F/Other)
SELECT DISTINCT
    TRIM(cst_gndr) AS standardized_gender
FROM silver.crm_cust_info;

-- 5. View distinct marital status values (standardization check)
SELECT DISTINCT
    TRIM(cst_marital_status) AS standardized_marital_status
FROM silver.crm_cust_info;

-- 6. Full table output for manual review (use cautiously in prod)
SELECT * FROM silver.crm_cust_info;


-- ============================================================
-- Product Information Quality Checks
-- ============================================================

-- 1. Check for NULLs or Duplicates in Primary Key (prd_id)
SELECT 
    prd_id,
    COUNT(*) AS record_count
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- 2. Check for unwanted spaces in product name
SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- 3. Check for NULLs or negative product cost values
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- 4. View distinct product lines (standardization check)
SELECT DISTINCT prd_line
FROM silver.crm_prd_info;

-- 5. Check for invalid date orders (end date < start date)
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- 6. Full product table for manual review
SELECT * FROM silver.crm_prd_info;


-- ============================================================
-- Sales Information Quality Checks
-- ============================================================

-- 1. Check for invalid due dates in Bronze layer
SELECT 
    NULLIF(sls_due_dt, 0) AS sls_due_dt 
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0 
   OR LEN(sls_due_dt) != 8 
   OR sls_due_dt > 20500101 
   OR sls_due_dt < 19000101;

-- 2. Check for invalid date orders (order date > ship/due date)
SELECT * 
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt 
   OR sls_order_dt > sls_due_dt;

-- 3. Check data consistency: sales = quantity × price
SELECT DISTINCT 
    sls_sales,
    sls_quantity,
    sls_price 
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL 
   OR sls_quantity IS NULL 
   OR sls_price IS NULL
   OR sls_sales <= 0 
   OR sls_quantity <= 0 
   OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

-- 4. Full sales details for manual review
SELECT * FROM silver.crm_sales_details;


-- ============================================================
-- ERP Customer Data Quality Checks
-- ============================================================

-- 1. Identify out-of-range birth dates
SELECT DISTINCT
    bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE();

-- 2. Gender standardization (map to Male/Female/N/A)
SELECT DISTINCT 
    gen,
    CASE 
        WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
        WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
        ELSE 'N/A'
    END AS standardized_gender
FROM silver.erp_cust_az12;

-- 3. Full ERP customer data for manual review
SELECT * FROM silver.erp_cust_az12;


-- ============================================================
-- ERP Location Data Quality Checks
-- ============================================================

-- 1. Distinct country values for standardization
SELECT DISTINCT cntry
FROM silver.erp_loc_a101
ORDER BY cntry;

-- 2. Full location data for manual review
SELECT * FROM silver.erp_loc_a101;


-- ============================================================
-- ERP Product Category Data Quality Checks
-- ============================================================

-- 1. Check for unwanted spaces in category, subcategory, or maintenance fields
SELECT * 
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat) 
   OR subcat != TRIM(subcat) 
   OR maintenance != TRIM(maintenance);

-- 2. Data standardization: category values
SELECT DISTINCT cat 
FROM silver.erp_px_cat_g1v2;

-- 3. Data standardization: sub-category values
SELECT DISTINCT subcat 
FROM silver.erp_px_cat_g1v2;

-- 4. Data standardization: maintenance values
SELECT DISTINCT maintenance 
FROM silver.erp_px_cat_g1v2;

-- 5. Full ERP product category data for manual review
SELECT * FROM silver.erp_px_cat_g1v2;
