/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs quality checks to validate the integrity, consistency, 
    and accuracy of the Gold Layer for the Shopper Insights Data Warehouse. 
    These checks ensure:
    - Uniqueness of surrogate keys in dimension tables.
    - Referential integrity between fact and dimension tables.
    - Validation of relationships in the data model for analytical purposes.
Usage Notes:
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

-- ====================================================================
-- Checking 'gold.dim_customers'
-- ====================================================================
-- Check for Uniqueness of Customer Key in gold.dim_customers
-- Expectation: No results
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.dim_products'
-- ====================================================================
-- Check for Uniqueness of Product Key in gold.dim_products
-- Expectation: No results
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.dim_stores'
-- ====================================================================
-- Check for Uniqueness of Store Key in gold.dim_stores
-- Expectation: No results
SELECT 
    store_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_stores
GROUP BY store_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.fact_transactions'
-- ====================================================================
-- Check the data model connectivity between fact and all dimensions
-- Expectation: No results (every transaction should match a valid customer, product, and store)
SELECT * 
FROM gold.fact_transactions f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
LEFT JOIN gold.dim_stores s
    ON s.store_key = f.store_key
WHERE p.product_key IS NULL 
   OR c.customer_key IS NULL 
   OR s.store_key IS NULL;

-- ====================================================================
-- Checking 'gold.fact_transactions' — additional business rule checks
-- ====================================================================
-- Check for negative or zero quantities
-- Expectation: No results
SELECT *
FROM gold.fact_transactions
WHERE quantity <= 0;

-- Check for invalid discount values (should be between 0 and 1)
-- Expectation: No results
SELECT *
FROM gold.fact_transactions
WHERE discount < 0 OR discount > 1;

-- Check for negative sales_amount
-- Expectation: No results
SELECT *
FROM gold.fact_transactions
WHERE sales_amount < 0;
