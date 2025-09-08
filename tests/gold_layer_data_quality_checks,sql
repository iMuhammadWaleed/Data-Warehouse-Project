-- ============================================
-- PURPOSE: Identify duplicate records and data integrity issues 
-- in the gold data warehouse schema.
-- ============================================


-- 1. Check for Duplicate Customers
-- THEN: These are customer_keys that appear more than once and may need deduplication
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;


-- 2. Check for Duplicate Products
-- THEN: These are product_keys that appear more than once and may indicate data quality issues
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;


-- 3. Find Orphan Records in fact_sales
-- THEN: These are sales records referencing non-existent customers or products
SELECT * 
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
WHERE p.product_key IS NULL 
   OR c.customer_key IS NULL;
