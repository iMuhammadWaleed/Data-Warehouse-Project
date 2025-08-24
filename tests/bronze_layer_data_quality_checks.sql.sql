-- ============================================================
-- Script Name: bronze_layer_data_quality_checks.sql
-- Purpose   : Cleansing and validating CRM customer information
--             in the Bronze layer before promoting to Silver.
-- ============================================================

-- ============================================================
-- 1. Check for NULLs or Duplicates in Primary Key (cst_id)
--    - Any duplicates or NULLs in the primary key must be resolved
--    - These will cause issues when inserting into the Silver layer
-- ============================================================

SELECT
    cst_id,
    COUNT(*) AS record_count
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- ============================================================
-- 2. Check for unwanted leading/trailing spaces in customer names
--    - Ensures consistency in name fields (first and last names)
-- ============================================================

SELECT
    cst_id,
    cst_firstname,
    cst_lastname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)
   OR cst_lastname != TRIM(cst_lastname);

-- ============================================================
-- 3. Check for unwanted spaces in gender values
--    - Helps identify and fix inconsistent formatting
-- ============================================================

SELECT
    cst_id,
    cst_gndr
FROM bronze.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr);

-- ============================================================
-- 4. Check distinct values in gender column
--    - Used to assess standardization (e.g., 'M', 'F', 'Male', etc.)
--    - Helps define normalization rules for Silver layer
-- ============================================================

SELECT DISTINCT
    TRIM(cst_gndr) AS standardized_gender
FROM bronze.crm_cust_info;

-- ============================================================
-- 5. Check distinct values in marital status column
--    - Ensures values are standardized (e.g., 'Single', 'Married', etc.)
-- ============================================================

SELECT DISTINCT
    TRIM(cst_marital_status) AS standardized_marital_status
FROM bronze.crm_cust_info;

