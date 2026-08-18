/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema for the 
    Shopper Insights Data Warehouse.
    Actions Performed:
        - Truncates Silver tables.
        - Inserts transformed and cleansed data from Bronze into Silver tables.

Parameters:
    None.
    This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC silver.load_silver;
===============================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Loading Silver Layer';
        PRINT '================================================';

        PRINT '------------------------------------------------';
        PRINT 'Loading Retail Tables';
        PRINT '------------------------------------------------';

        -- Loading silver.retail_customers
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.retail_customers';
        TRUNCATE TABLE silver.retail_customers;
        PRINT '>> Inserting Data Into: silver.retail_customers';
        INSERT INTO silver.retail_customers (
            customer_id,
            first_name,
            last_name,
            join_date
        )
        SELECT
            TRIM(customer_id) AS customer_id,
            TRIM(first_name) AS first_name,
            TRIM(last_name) AS last_name,
            join_date
        FROM (
            SELECT
                *,
                ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY join_date DESC) AS flag_last
            FROM bronze.retail_customers
            WHERE customer_id IS NOT NULL
        ) t
        WHERE flag_last = 1; -- Remove accidental duplicate customer records
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        -- Loading silver.retail_customer_demographics
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.retail_customer_demographics';
        TRUNCATE TABLE silver.retail_customer_demographics;
        PRINT '>> Inserting Data Into: silver.retail_customer_demographics';
        INSERT INTO silver.retail_customer_demographics (
            customer_id,
            gender,
            birth_date,
            city
        )
        SELECT
            TRIM(customer_id) AS customer_id,
            CASE
                WHEN UPPER(TRIM(gender)) IN ('F', 'FEMALE') THEN 'Female'
                WHEN UPPER(TRIM(gender)) IN ('M', 'MALE') THEN 'Male'
                ELSE 'n/a'
            END AS gender, -- Normalize gender values
            CASE
                WHEN birth_date > GETDATE() THEN NULL
                ELSE birth_date
            END AS birth_date, -- Set invalid future birthdates to NULL
            TRIM(city) AS city
        FROM bronze.retail_customer_demographics
        WHERE customer_id IS NOT NULL;
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        -- Loading silver.retail_products
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.retail_products';
        TRUNCATE TABLE silver.retail_products;
        PRINT '>> Inserting Data Into: silver.retail_products';
        INSERT INTO silver.retail_products (
            product_id,
            product_name,
            category,
            subcategory,
            unit_price,
            cost_price
        )
        SELECT
            TRIM(product_id) AS product_id,
            TRIM(product_name) AS product_name,
            TRIM(category) AS category,
            TRIM(subcategory) AS subcategory,
            CASE WHEN unit_price IS NULL OR unit_price < 0 THEN 0 ELSE unit_price END AS unit_price,
            CASE WHEN cost_price IS NULL OR cost_price < 0 THEN 0 ELSE cost_price END AS cost_price
        FROM bronze.retail_products
        WHERE product_id IS NOT NULL;
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        -- Loading silver.retail_stores
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.retail_stores';
        TRUNCATE TABLE silver.retail_stores;
        PRINT '>> Inserting Data Into: silver.retail_stores';
        INSERT INTO silver.retail_stores (
            store_id,
            store_name,
            city,
            region
        )
        SELECT
            TRIM(store_id) AS store_id,
            TRIM(store_name) AS store_name,
            TRIM(city) AS city,
            CASE
                WHEN TRIM(region) = '' OR region IS NULL THEN 'n/a'
                ELSE TRIM(region)
            END AS region
        FROM bronze.retail_stores
        WHERE store_id IS NOT NULL;
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        -- Loading silver.retail_transactions
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.retail_transactions';
        TRUNCATE TABLE silver.retail_transactions;
        PRINT '>> Inserting Data Into: silver.retail_transactions';
        INSERT INTO silver.retail_transactions (
            transaction_id,
            transaction_date,
            customer_id,
            product_id,
            store_id,
            quantity,
            discount,
            payment_method
        )
        SELECT
            TRIM(transaction_id) AS transaction_id,
            transaction_date,
            TRIM(customer_id) AS customer_id,
            TRIM(product_id) AS product_id,
            TRIM(store_id) AS store_id,
            CASE WHEN quantity IS NULL OR quantity < 0 THEN 0 ELSE quantity END AS quantity,
            CASE 
                WHEN discount IS NULL OR discount < 0 THEN 0 
                WHEN discount > 1 THEN 1 
                ELSE discount 
            END AS discount, -- Clamp discount to a valid 0-1 range
            CASE
                WHEN TRIM(payment_method) = '' OR payment_method IS NULL THEN 'n/a'
                ELSE TRIM(payment_method)
            END AS payment_method
        FROM bronze.retail_transactions
        WHERE transaction_id IS NOT NULL;
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        SET @batch_end_time = GETDATE();
        PRINT '==========================================';
        PRINT 'Loading Silver Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
        PRINT '==========================================';

    END TRY
    BEGIN CATCH
        PRINT '==========================================';
        PRINT 'ERROR OCCURRED DURING LOADING SILVER LAYER';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '==========================================';
    END CATCH
END
GO
