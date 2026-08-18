/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema for the Shopper Insights 
    Data Warehouse, dropping existing tables if they already exist.
    Customer data is split into 'retail_customers' (core identity) and 
    'retail_customer_demographics' (sensitive/demographic attributes).
    Run this script to re-define the DDL structure of 'bronze' Tables.
===============================================================================
*/

IF OBJECT_ID('bronze.retail_customers', 'U') IS NOT NULL
    DROP TABLE bronze.retail_customers;
GO

CREATE TABLE bronze.retail_customers (
    customer_id    NVARCHAR(50),
    first_name     NVARCHAR(50),
    last_name      NVARCHAR(50),
    join_date      DATE
);
GO

IF OBJECT_ID('bronze.retail_customer_demographics', 'U') IS NOT NULL
    DROP TABLE bronze.retail_customer_demographics;
GO

CREATE TABLE bronze.retail_customer_demographics (
    customer_id    NVARCHAR(50),
    gender         NVARCHAR(10),
    birth_date     DATE,
    city           NVARCHAR(50)
);
GO

IF OBJECT_ID('bronze.retail_products', 'U') IS NOT NULL
    DROP TABLE bronze.retail_products;
GO

CREATE TABLE bronze.retail_products (
    product_id     NVARCHAR(50),
    product_name   NVARCHAR(100),
    category       NVARCHAR(50),
    subcategory    NVARCHAR(50),
    unit_price     DECIMAL(10,2),
    cost_price     DECIMAL(10,2)
);
GO

IF OBJECT_ID('bronze.retail_stores', 'U') IS NOT NULL
    DROP TABLE bronze.retail_stores;
GO

CREATE TABLE bronze.retail_stores (
    store_id       NVARCHAR(50),
    store_name     NVARCHAR(100),
    city           NVARCHAR(50),
    region         NVARCHAR(50)
);
GO

IF OBJECT_ID('bronze.retail_transactions', 'U') IS NOT NULL
    DROP TABLE bronze.retail_transactions;
GO

CREATE TABLE bronze.retail_transactions (
    transaction_id    NVARCHAR(50),
    transaction_date  DATE,
    customer_id       NVARCHAR(50),
    product_id        NVARCHAR(50),
    store_id          NVARCHAR(50),
    quantity          INT,
    discount           DECIMAL(5,2),
    payment_method    NVARCHAR(50)
);
GO
