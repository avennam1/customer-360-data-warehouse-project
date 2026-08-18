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
* **Data Modeling:** Design an analytics-ready **Star Schema** consisting of fact and dimension tables (`dim_customers`, `dim_products`, `dim_stores`, `fact_transactions`).
* **Scope:** Process the latest available dataset only. Historical tracking and historization are outside the current project scope.
* **Documentation:** Provide clear documentation of the data architecture, ETL process, and data model for both business stakeholders and analytics teams.

## 🎯 Business Value
The resulting data warehouse provides a centralized, reliable, and analytics-ready source of retail data — consolidating customers, products, stores, and transactions into a clean Star Schema. This lays the foundation for downstream reporting and analysis, such as customer behavior, product performance, and regional sales trends, by any BI tool or analyst querying the Gold layer views.

## 🔮 Possible Extensions
This project is scoped to the data engineering pipeline (Bronze → Silver → Gold). Future extensions could include:
* SQL-based analytics and reporting queries (customer segmentation, product performance, regional trends)
* A Power BI or Tableau dashboard built on top of the Gold layer views
* Incremental/historical data loading instead of full reloads
