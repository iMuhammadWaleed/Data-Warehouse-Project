/****************************************************************************************************
    Script Name : Rebuild DataWarehouse Database and Schemas
    Description :
        This script will completely reset the 'DataWarehouse' database.
        Steps:
          1. Drop 'DataWarehouse' if it exists (⚠ Deletes all data inside).
          2. Create a fresh 'DataWarehouse' database.
          3. Create schemas: bronze, silver, gold.

        Schema Purpose (common in data lakehouse architecture):
          - bronze : Raw, unprocessed data
          - silver : Cleaned, standardized, and lightly transformed data
          - gold   : Curated, business-ready data

    Author     : [Your Name]
    Date       : [YYYY-MM-DD]
****************************************************************************************************/

-----------------------------------------
-- 1. Drop Database if it Exists
-----------------------------------------
IF DB_ID(N'DataWarehouse') IS NOT NULL
BEGIN
    -- Ensure no connections block the drop
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END
GO

-----------------------------------------
-- 2. Create Fresh Database
-----------------------------------------
CREATE DATABASE DataWarehouse;
GO

-- Switch context to the new database
USE DataWarehouse;
GO

-----------------------------------------
-- 3. Create Schemas
-----------------------------------------
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO

PRINT 'DataWarehouse database and schemas created successfully.';
