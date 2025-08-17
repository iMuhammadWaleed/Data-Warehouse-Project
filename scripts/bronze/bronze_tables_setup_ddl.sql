/*****************************************************************************************
 Script Name:     bronze_tables_setup_ddl.sql
 Script Type:     DDL (Data Definition Language)
 Purpose:         This script creates the initial structure for staging (bronze layer) 
                  tables used in the CRM and ERP data ingestion pipeline. It ensures 
                  clean table definitions by dropping existing tables (if any) and 
                  recreating them with the necessary schema.
*****************************************************************************************/

-- Drop the 'crm_cust_info' table from the 'bronze' schema if it already exists
IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_cust_info;
GO

-- Create the 'crm_cust_info' table to store customer information
CREATE TABLE bronze.crm_cust_info (
    cst_id              INT,              -- Customer ID
    cst_key             NVARCHAR(50),     -- Unique customer key
    cst_firstname       NVARCHAR(50),     -- Customer first name
    cst_lastname        NVARCHAR(50),     -- Customer last name
    cst_marital_status  NVARCHAR(50),     -- Marital status
    cst_gndr            NVARCHAR(50),     -- Gender
    cst_create_date     DATE              -- Record creation date
);
GO

-- Drop the 'crm_prd_info' table from the 'bronze' schema if it already exists
IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_prd_info;
GO

-- Create the 'crm_prd_info' table to store product information
CREATE TABLE bronze.crm_prd_info (
    prd_id       INT,              -- Product ID
    prd_key      NVARCHAR(50),     -- Unique product key
    prd_nm       NVARCHAR(50),     -- Product name
    prd_cost     INT,              -- Product cost
    prd_line     NVARCHAR(50),     -- Product line/category
    prd_start_dt DATETIME,         -- Start date of product availability
    prd_end_dt   DATETIME          -- End date of product availability
);
GO

-- Drop the 'crm_sales_details' table from the 'bronze' schema if it already exists
IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE bronze.crm_sales_details;
GO

-- Create the 'crm_sales_details' table to store sales order details
CREATE TABLE bronze.crm_sales_details (
    sls_ord_num  NVARCHAR(50),     -- Sales order number
    sls_prd_key  NVARCHAR(50),     -- Product key from the sales
    sls_cust_id  INT,              -- Customer ID
    sls_order_dt INT,              -- Order date (as integer, possibly YYYYMMDD)
    sls_ship_dt  INT,              -- Shipping date (as integer)
    sls_due_dt   INT,              -- Due date for order (as integer)
    sls_sales    INT,              -- Sales amount
    sls_quantity INT,              -- Quantity sold
    sls_price    INT               -- Price per unit
);
GO

-- Drop the 'erp_loc_a101' table from the 'bronze' schema if it already exists
IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE bronze.erp_loc_a101;
GO

-- Create the 'erp_loc_a101' table to store customer location details
CREATE TABLE bronze.erp_loc_a101 (
    cid    NVARCHAR(50),     -- Customer ID
    cntry  NVARCHAR(50)      -- Country
);
GO

-- Drop the 'erp_cust_az12' table from the 'bronze' schema if it already exists
IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE bronze.erp_cust_az12;
GO

-- Create the 'erp_cust_az12' table to store additional customer information
CREATE TABLE bronze.erp_cust_az12 (
    cid    NVARCHAR(50),     -- Customer ID
    bdate  DATE,             -- Birth date
    gen    NVARCHAR(50)      -- Gender
);
GO

-- Drop the 'erp_px_cat_g1v2' table from the 'bronze' schema if it already exists
IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE bronze.erp_px_cat_g1v2;
GO

-- Create the 'erp_px_cat_g1v2' table to store product category and maintenance information
CREATE TABLE bronze.erp_px_cat_g1v2 (
    id           NVARCHAR(50),     -- Product/category ID
    cat          NVARCHAR(50),     -- Product category
    subcat       NVARCHAR(50),     -- Product subcategory
    maintenance  NVARCHAR(50)      -- Maintenance information
);
GO
