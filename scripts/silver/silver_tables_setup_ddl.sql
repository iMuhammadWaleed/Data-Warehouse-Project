/*****************************************************************************************
 Script Type:     DDL (Data Definition Language)
 Script Purpose:  This script sets up the 'silver' schema tables required for the data 
                  warehouse layer. It ensures a clean environment by dropping existing 
                  tables if they exist and then recreating them with the required 
                  structure. The tables store customer, product, sales, location, and 
                  category information, serving as the standardized staging layer 
                  between bronze and gold data layers.
*****************************************************************************************/

-- Drop the 'crm_cust_info' table from the 'silver' schema if it already exists
IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_cust_info;
GO

-- Create the 'crm_cust_info' table to store customer information
CREATE TABLE silver.crm_cust_info (
    cst_id              INT NOT NULL,              -- Customer ID
    cst_key             NVARCHAR(50) NOT NULL,     -- Unique customer key
    cst_firstname       NVARCHAR(50),              -- Customer first name
    cst_lastname        NVARCHAR(50),              -- Customer last name
    cst_marital_status  NVARCHAR(50),              -- Marital status
    cst_gndr            NVARCHAR(50),              -- Gender
    cst_create_date     DATE,                      -- Record creation date
    dwh_create_date     DATETIME2 DEFAULT GETDATE() -- Data warehouse load timestamp
);
GO

-- Drop the 'crm_prd_info' table from the 'silver' schema if it already exists
IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_prd_info;
GO

-- Create the 'crm_prd_info' table to store product information
CREATE TABLE silver.crm_prd_info (
    prd_id              INT,                       -- Product ID
    cat_id              NVARCHAR(50) NOT NULL,     -- Category ID
    prd_key             NVARCHAR(50),
    prd_nm              NVARCHAR(50),              -- Product name
    prd_cost            INT,                       -- Product cost
    prd_line            NVARCHAR(50),              -- Product line/category
    prd_start_dt        DATE,                      -- Start date of product availability
    prd_end_dt          DATE,                      -- End date of product availability
    dwh_create_date     DATETIME2 DEFAULT GETDATE() -- Data warehouse load timestamp
);
GO

-- Drop the 'crm_sales_details' table from the 'silver' schema if it already exists
IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE silver.crm_sales_details;
GO

-- Create the 'crm_sales_details' table to store sales order details
CREATE TABLE silver.crm_sales_details (
    sls_ord_num         NVARCHAR(50) NOT NULL,     -- Sales order number
    sls_prd_key         NVARCHAR(50) NOT NULL,     -- Product key
    sls_cust_id         INT,                       -- Customer ID
    sls_order_dt        DATE,                      -- Order date
    sls_ship_dt         DATE,                      -- Shipping date
    sls_due_dt          DATE,                      -- Due date
    sls_sales           INT,                       -- Sales amount
    sls_quantity        INT,                       -- Quantity sold
    sls_price           INT,                       -- Price per unit
    dwh_create_date     DATETIME2 DEFAULT GETDATE() -- Data warehouse load timestamp
);
GO

-- Drop the 'erp_loc_a101' table from the 'silver' schema if it already exists
IF OBJECT_ID('silver.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE silver.erp_loc_a101;
GO

-- Create the 'erp_loc_a101' table to store customer location details
CREATE TABLE silver.erp_loc_a101 (
    cid                 NVARCHAR(50) NOT NULL,     -- Customer ID
    cntry               NVARCHAR(50),              -- Country
    dwh_create_date     DATETIME2 DEFAULT GETDATE() -- Data warehouse load timestamp
);
GO

-- Drop the 'erp_cust_az12' table from the 'silver' schema if it already exists
IF OBJECT_ID('silver.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE silver.erp_cust_az12;
GO

-- Create the 'erp_cust_az12' table to store additional customer information
CREATE TABLE silver.erp_cust_az12 (
    cid                 NVARCHAR(50) NOT NULL,     -- Customer ID
    bdate               DATE,                      -- Birth date
    gen                 NVARCHAR(50),              -- Gender
    dwh_create_date     DATETIME2 DEFAULT GETDATE() -- Data warehouse load timestamp
);
GO

-- Drop the 'erp_px_cat_g1v2' table from the 'silver' schema if it already exists
IF OBJECT_ID('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE silver.erp_px_cat_g1v2;
GO

-- Create the 'erp_px_cat_g1v2' table to store product category and maintenance information
CREATE TABLE silver.erp_px_cat_g1v2 (
    id                  NVARCHAR(50) NOT NULL,     -- Product/category ID
    cat                 NVARCHAR(50),              -- Product category
    subcat              NVARCHAR(50),              -- Product subcategory
    maintenance         NVARCHAR(50),              -- Maintenance information
    dwh_create_date     DATETIME2 DEFAULT GETDATE() -- Data warehouse load timestamp
);
GO
