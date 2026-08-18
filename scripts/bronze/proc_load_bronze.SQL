/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from the retail
    source CSV files (Customers, Customer Demographics, Products, Stores,
    Transactions) for the Shopper Insights Data Warehouse.

    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses BULK INSERT to load CSV files into bronze tables.
    - Tracks the load duration for each table.
    - Tracks the total batch load duration.
    - Handles and reports errors.

Parameters:
    None.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE 
        @start_time DATETIME,
        @end_time DATETIME,
        @batch_start_time DATETIME,
        @batch_end_time DATETIME;

    BEGIN TRY

        SET @batch_start_time = GETDATE();

        PRINT '=============================================================';
        PRINT 'Loading Bronze Layer';
        PRINT '=============================================================';

        PRINT '-------------------------------------------------------------';
        PRINT 'Loading Tables';
        PRINT '-------------------------------------------------------------';


        /* =====================================================
           Customer Demographics
        ===================================================== */

        PRINT '>> Loading bronze.retail_customer_demographics';

        SET @start_time = GETDATE();

        TRUNCATE TABLE bronze.retail_customer_demographics;

        BULK INSERT bronze.retail_customer_demographics
        FROM 'C:\sqldata\dataset\customer_demographics.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            CODEPAGE = '65001',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '';


        /* =====================================================
           Customers
        ===================================================== */

        PRINT '>> Loading bronze.retail_customers';

        SET @start_time = GETDATE();

        TRUNCATE TABLE bronze.retail_customers;

        BULK INSERT bronze.retail_customers
        FROM 'C:\sqldata\dataset\customers.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            CODEPAGE = '65001',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '';


        /* =====================================================
           Products
        ===================================================== */

        PRINT '>> Loading bronze.retail_products';

        SET @start_time = GETDATE();

        TRUNCATE TABLE bronze.retail_products;

        BULK INSERT bronze.retail_products
        FROM 'C:\sqldata\dataset\products.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            CODEPAGE = '65001',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '';


        /* =====================================================
           Stores
        ===================================================== */

        PRINT '>> Loading bronze.retail_stores';

        SET @start_time = GETDATE();

        TRUNCATE TABLE bronze.retail_stores;

        BULK INSERT bronze.retail_stores
        FROM 'C:\sqldata\dataset\stores.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            CODEPAGE = '65001',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';

        PRINT '';


        /* =====================================================
           Transactions
        ===================================================== */

        PRINT '>> Loading bronze.retail_transactions';

        SET @start_time = GETDATE();

        TRUNCATE TABLE bronze.retail_transactions;

        BULK INSERT bronze.retail_transactions
        FROM 'C:\sqldata\dataset\transactions.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a',
            CODEPAGE = '65001',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
            + ' seconds';


        /* =====================================================
           Batch Summary
        ===================================================== */

        SET @batch_end_time = GETDATE();

        PRINT '=============================================================';
        PRINT 'Bronze Layer Load Completed Successfully';
        PRINT '>> Total Load Duration: '
            + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR)
            + ' seconds';
        PRINT '=============================================================';

    END TRY

    BEGIN CATCH

        PRINT '=============================================================';
        PRINT 'Error Occurred While Loading Bronze Layer';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT 'Error Line: ' + CAST(ERROR_LINE() AS NVARCHAR);
        PRINT '=============================================================';

    END CATCH

END;
GO
