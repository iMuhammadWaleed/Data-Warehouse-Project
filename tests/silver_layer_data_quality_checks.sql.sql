-- ============================================================
-- Script Name: silver_layer_data_quality_checks.sql
-- Purpose   : Validating cleaned CRM customer data in Silver layer
-- ============================================================

-- ============================================================
-- 1. Check for NULLs or Duplicates in Primary Key (cst_id)
--    - Ensures uniqueness and completeness of customer records
-- ============================================================

SELECT
    cst_id,
    COUNT(*) AS record_count
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- ============================================================
-- 2. Check for unwanted leading/trailing spaces in customer names
--    - Helps detect leftover formatting issues
-- ============================================================

SELECT
    cst_id,
    cst_firstname,
    cst_lastname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)
   OR cst_lastname != TRIM(cst_lastname);

-- ============================================================
-- 3. Check for unwanted spaces in gender values
--    - Gender should be fully standardized in Silver
-- ============================================================

SELECT
    cst_id,
    cst_gndr
FROM silver.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr);

-- ============================================================
-- 4. View distinct gender values
--    - Should reflect a clean set like ('M', 'F', 'Other')
-- ============================================================

SELECT DISTINCT
    TRIM(cst_gndr) AS standardized_gender
FROM silver.crm_cust_info;

-- ============================================================
-- 5. View distinct marital status values
--    - Useful to confirm that values have been standardized
-- ============================================================

SELECT DISTINCT
    TRIM(cst_marital_status) AS standardized_marital_status
FROM silver.crm_cust_info;

-- ============================================================
-- 6. (Optional) Full Table Output for Manual Review
--    - Can be removed or limited with WHERE/LIMIT in production
-- ============================================================

SELECT *
FROM silver.crm_cust_info;
