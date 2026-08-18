/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy, 
    and standardization across the 'silver' layer of the Shopper Insights Data 
    Warehouse. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after loading the Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

-- ====================================================================
-- Checking 'silver.retail_customers'
-- ====================================================================
-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results
SELECT 
    customer_id,
    COUNT(*) 
FROM silver.retail_customers
GROUP BY customer_id
HAVING COUNT(*) > 1 OR customer_id IS NULL;

-- Check for Unwanted Spaces
-- Expectation: No Results
SELECT 
    first_name 
FROM silver.retail_customers
WHERE first_name != TRIM(first_name);

SELECT 
    last_name 
FROM silver.retail_customers
WHERE last_name != TRIM(last_name);

-- Check for Invalid Join Dates
-- Expectation: No Results
SELECT 
    join_date 
FROM silver.retail_customers
WHERE join_date > GETDATE() 
   OR join_date < '1990-01-01';

-- ====================================================================
-- Checking 'silver.retail_customer_demographics'
-- ====================================================================
-- Check for NULLs or Duplicates in Key
-- Expectation: No Results
SELECT 
    customer_id,
    COUNT(*) 
FROM silver.retail_customer_demographics
GROUP BY customer_id
HAVING COUNT(*) > 1 OR customer_id IS NULL;

-- Data Standardization & Consistency
SELECT DISTINCT 
    gender 
FROM silver.retail_customer_demographics;

-- Identify Out-of-Range Birthdates
-- Expectation: Birthdates between 1924-01-01 and Today
SELECT DISTINCT 
    birth_date 
FROM silver.retail_customer_demographics
WHERE birth_date < '1924-01-01' 
   OR birth_date > GETDATE();

-- Check for Unwanted Spaces
-- Expectation: No Results
SELECT 
    city 
FROM silver.retail_customer_demographics
WHERE city != TRIM(city);

-- ====================================================================
-- Checking 'silver.retail_products'
-- ====================================================================
-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results
SELECT 
    product_id,
    COUNT(*) 
FROM silver.retail_products
GROUP BY product_id
HAVING COUNT(*) > 1 OR product_id IS NULL;

-- Check for Unwanted Spaces
-- Expectation: No Results
SELECT 
    product_name 
FROM silver.retail_products
WHERE product_name != TRIM(product_name);

-- Check for NULLs or Negative Values in Pricing
-- Expectation: No Results
SELECT 
    unit_price, 
    cost_price 
FROM silver.retail_products
WHERE unit_price < 0 OR unit_price IS NULL
   OR cost_price < 0 OR cost_price IS NULL;

-- Check for Cost Price Greater Than Unit Price (would imply a loss on every sale)
-- Expectation: Review any results
SELECT 
    * 
FROM silver.retail_products
WHERE cost_price > unit_price;

-- Data Standardization & Consistency
SELECT DISTINCT 
    category 
FROM silver.retail_products;

SELECT DISTINCT 
    subcategory 
FROM silver.retail_products;

-- ====================================================================
-- Checking 'silver.retail_stores'
-- ====================================================================
-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results
SELECT 
    store_id,
    COUNT(*) 
FROM silver.retail_stores
GROUP BY store_id
HAVING COUNT(*) > 1 OR store_id IS NULL;

-- Data Standardization & Consistency
SELECT DISTINCT 
    region 
FROM silver.retail_stores
ORDER BY region;

-- Check for Unwanted Spaces
-- Expectation: No Results
SELECT 
    * 
FROM silver.retail_stores
WHERE store_name != TRIM(store_name) 
   OR city != TRIM(city) 
   OR region != TRIM(region);

-- ====================================================================
-- Checking 'silver.retail_transactions'
-- ====================================================================
-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results
SELECT 
    transaction_id,
    COUNT(*) 
FROM silver.retail_transactions
GROUP BY transaction_id
HAVING COUNT(*) > 1 OR transaction_id IS NULL;

-- Check for Invalid Transaction Dates
-- Expectation: No Invalid Dates
SELECT 
    transaction_date 
FROM silver.retail_transactions
WHERE transaction_date > GETDATE() 
   OR transaction_date < '2000-01-01';

-- Check for NULLs or Non-Positive Quantities
-- Expectation: No Results
SELECT 
    * 
FROM silver.retail_transactions
WHERE quantity <= 0 OR quantity IS NULL;

-- Check for Invalid Discount Values (should be between 0 and 1)
-- Expectation: No Results
SELECT 
    * 
FROM silver.retail_transactions
WHERE discount < 0 OR discount > 1 OR discount IS NULL;

-- Check Referential Integrity: every transaction should map to a valid customer, product, and store
-- Expectation: No Results
SELECT t.*
FROM silver.retail_transactions t
LEFT JOIN silver.retail_customers c ON t.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT t.*
FROM silver.retail_transactions t
LEFT JOIN silver.retail_products p ON t.product_id = p.product_id
WHERE p.product_id IS NULL;

SELECT t.*
FROM silver.retail_transactions t
LEFT JOIN silver.retail_stores s ON t.store_id = s.store_id
WHERE s.store_id IS NULL;

-- Data Standardization & Consistency
SELECT DISTINCT 
    payment_method 
FROM silver.retail_transactions;
