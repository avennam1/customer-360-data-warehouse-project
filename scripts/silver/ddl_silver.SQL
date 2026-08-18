/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'silver' schema for the Shopper Insights
    Data Warehouse, dropping existing tables if they already exist.
    Run this script to re-define the DDL structure of 'silver' Tables.
===============================================================================
*/

IF OBJECT_ID('silver.retail_customers', 'U') IS NOT NULL
    DROP TABLE silver.retail_customers;
GO
CREATE TABLE silver.retail_customers (
    customer_id      NVARCHAR(50),
    first_name       NVARCHAR(50),
    last_name        NVARCHAR(50),
    join_date        DATE,
    dwh_create_date  DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.retail_customer_demographics', 'U') IS NOT NULL
    DROP TABLE silver.retail_customer_demographics;
GO
CREATE TABLE silver.retail_customer_demographics (
    customer_id      NVARCHAR(50),
    gender           NVARCHAR(50),
    birth_date       DATE,
    city             NVARCHAR(50),
    dwh_create_date  DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.retail_products', 'U') IS NOT NULL
    DROP TABLE silver.retail_products;
GO
CREATE TABLE silver.retail_products (
    product_id       NVARCHAR(50),
    product_name     NVARCHAR(100),
    category         NVARCHAR(50),
    subcategory      NVARCHAR(50),
    unit_price       DECIMAL(10,2),
    cost_price       DECIMAL(10,2),
    dwh_create_date  DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.retail_stores', 'U') IS NOT NULL
    DROP TABLE silver.retail_stores;
GO
CREATE TABLE silver.retail_stores (
    store_id         NVARCHAR(50),
    store_name       NVARCHAR(100),
    city             NVARCHAR(50),
    region           NVARCHAR(50),
    dwh_create_date  DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.retail_transactions', 'U') IS NOT NULL
    DROP TABLE silver.retail_transactions;
GO
CREATE TABLE silver.retail_transactions (
    transaction_id    NVARCHAR(50),
    transaction_date  DATE,
    customer_id       NVARCHAR(50),
    product_id        NVARCHAR(50),
    store_id          NVARCHAR(50),
    quantity          INT,
    discount           DECIMAL(5,2),
    payment_method    NVARCHAR(50),
    dwh_create_date   DATETIME2 DEFAULT GETDATE()
);
GO
