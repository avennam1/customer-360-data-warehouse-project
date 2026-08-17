# Shopper Insights Data Warehouse Project

A SQL Server data warehouse built using **Medallion Architecture** to consolidate customer and sales data into an analytics-ready **Star Schema**, supported by a complete ETL pipeline and data quality checks.

## 🏗️ Building the Data Warehouse — Data Engineering

### Objective

Develop a modern data warehouse using **SQL Server** to consolidate retail sales data across customers, products, stores, and transactions, enabling analytical reporting and informed decision-making.

### Specifications

* **Data Sources:** Import data from four related CSV source files:

  * Customers
  * Products
  * Stores
  * Transactions

* **Data Quality:** Clean, validate, and resolve data quality issues before preparing the data for analysis.

* **Integration:** Integrate data from multiple sources into a unified and analytics-friendly data model.

* **Architecture:** Implement a **Medallion Architecture** with:

  * **Bronze Layer:** Raw source data
  * **Silver Layer:** Cleaned and standardized data
  * **Gold Layer:** Business-ready dimensional model

* **Data Modeling:** Design an analytics-ready **Star Schema** consisting of fact and dimension tables.

* **Scope:** Process the latest available dataset only. Historical tracking and historization are outside the current project scope.

* **Documentation:** Provide clear documentation of the data architecture, ETL process, and data model for both business stakeholders and analytics teams.

## 📊 Analytics & Reporting — Data Analytics

### Objective

Develop SQL-based analytics and reporting to generate meaningful business insights from the data warehouse.

### Key Analysis Areas

**Customer Behavior**

* Customer purchasing patterns
* Customer spending
* Transaction frequency
* Customer segmentation

**Product Performance**

* Product-level sales
* Best and worst-performing products
* Product category performance
* Revenue contribution

**Store & Regional Sales Trends**

* Store-level performance
* Regional sales trends
* Revenue by location
* Top-performing stores and regions

## 🎯 Business Value

The resulting data warehouse provides a centralized and reliable source of analytical data, allowing stakeholders to monitor key business metrics, understand customer and product performance, analyze store and regional trends, and make more informed data-driven decisions.
