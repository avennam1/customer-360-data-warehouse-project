/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer of the Shopper Insights 
    Data Warehouse. The Gold layer represents the final dimension and fact 
    tables (Star Schema). Each view performs transformations and combines 
    data from the Silver layer to produce a clean, enriched, business-ready 
    dataset.
Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO
CREATE VIEW gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY c.customer_id) AS customer_key, -- Surrogate key
    c.customer_id                              AS customer_id,
    c.first_name                               AS first_name,
    c.last_name                                AS last_name,
    d.gender                                   AS gender,
    d.birth_date                               AS birth_date,
    d.city                                     AS city,
    c.join_date                                AS join_date
FROM silver.retail_customers c
LEFT JOIN silver.retail_customer_demographics d
    ON c.customer_id = d.customer_id;
GO

-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO
CREATE VIEW gold.dim_products AS
SELECT
    ROW_NUMBER() OVER (ORDER BY p.product_id) AS product_key, -- Surrogate key
    p.product_id                              AS product_id,
    p.product_name                            AS product_name,
    p.category                                AS category,
    p.subcategory                             AS subcategory,
    p.unit_price                              AS unit_price,
    p.cost_price                              AS cost_price
FROM silver.retail_products p;
GO

-- =============================================================================
-- Create Dimension: gold.dim_stores
-- =============================================================================
IF OBJECT_ID('gold.dim_stores', 'V') IS NOT NULL
    DROP VIEW gold.dim_stores;
GO
CREATE VIEW gold.dim_stores AS
SELECT
    ROW_NUMBER() OVER (ORDER BY s.store_id) AS store_key, -- Surrogate key
    s.store_id                              AS store_id,
    s.store_name                            AS store_name,
    s.city                                  AS city,
    s.region                                AS region
FROM silver.retail_stores s;
GO

-- =============================================================================
-- Create Fact Table: gold.fact_transactions
-- =============================================================================
IF OBJECT_ID('gold.fact_transactions', 'V') IS NOT NULL
    DROP VIEW gold.fact_transactions;
GO
CREATE VIEW gold.fact_transactions AS
SELECT
    t.transaction_id                                       AS transaction_id,
    t.transaction_date                                     AS transaction_date,
    cu.customer_key                                        AS customer_key,
    pr.product_key                                          AS product_key,
    st.store_key                                            AS store_key,
    t.quantity                                              AS quantity,
    t.discount                                              AS discount,
    t.payment_method                                        AS payment_method,
    pr.unit_price                                           AS unit_price,
    ROUND(pr.unit_price * t.quantity * (1 - t.discount), 2) AS sales_amount -- Derived revenue after discount
FROM silver.retail_transactions t
LEFT JOIN gold.dim_customers cu
    ON t.customer_id = cu.customer_id
LEFT JOIN gold.dim_products pr
    ON t.product_id = pr.product_id
LEFT JOIN gold.dim_stores st
    ON t.store_id = st.store_id;
GO
