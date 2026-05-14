# 🏗️ SQL Data Warehouse Project

A full end-to-end data warehousing project built with **SQL Server**, following the **Medallion Architecture** (Bronze → Silver → Gold). This project consolidates raw sales data from two source systems into a clean, analytics-ready data model.

---

## 📌 Project Background

This project was built as a hands-on portfolio exercise following the tutorial **"SQL Data Warehouse from Scratch"** by [**Data with Baraa**](https://www.youtube.com/@DataWithBaraa) (Baraa Khatib Salkini), a data engineer with 17+ years of industry experience. All credit for the project concept, dataset, and architecture design goes to him. This repository represents my own personal implementation of the project.

---

## 🎯 Objective

Build a modern data warehouse using SQL Server that:
- Ingests raw data from two simulated source systems (CRM and ERP)
- Cleans and standardizes the data
- Produces a business-ready star schema for analytics and reporting

---

## 🏛️ Architecture

This project follows the **Medallion Architecture** — a three-layer approach that progressively refines raw data into clean, structured, and analytics-ready information.

```
[CRM CSV Files] ─┐
                 ├──► BRONZE (Raw) ──► SILVER (Clean) ──► GOLD (Analytics)
[ERP CSV Files] ─┘
```

### Bronze Layer
- Raw data ingested directly from CSV files with no transformations
- Serves as the historical record of source data
- **6 tables:** 3 from CRM, 3 from ERP

### Silver Layer
- Data cleansing, standardization, and deduplication applied
- All data quality issues resolved here before analysis
- **6 tables** mirroring bronze but with clean, consistent data

### Gold Layer
- Business-ready data modeled into a **Star Schema**
- Built using SQL Views for real-time reflection of silver data
- **3 views:** `dim_customers`, `dim_products`, `fact_sales`

---

## 📂 Repository Structure

```
sql-data-warehouse-project/
│
├── datasets/                        # Raw source CSV files (CRM and ERP)
│
├── scripts/
│   ├── init_database.sql            # Creates the DataWarehouse database and schemas
│   ├── bronze/
│   │   ├── ddl_bronze.sql           # Creates raw bronze tables
│   │   └── proc_load_bronze.sql     # Stored procedure to bulk load CSV data
│   ├── silver/
│   │   ├── ddl_silver.sql           # Creates cleaned silver tables
│   │   └── proc_load_silver.sql     # Stored procedure to clean and load silver data
│   └── gold/
│       ├── ddl_gold.sql             # Creates star schema views
│       ├── report_customers.sql     # Customer behavior analytics view
│       ├── report_products.sql      # Product performance analytics view
│       └── report_sales.sql         # Sales trends analytics view
│
└── tests/
    └── quality_checks.sql           # Verification queries for all layers
```

---

## 🛠️ Tools & Technologies

| Tool | Purpose |
|---|---|
| SQL Server Express 2025 | Database engine |
| SQL Server Management Studio (SSMS) | Query editor and database management |
| T-SQL | All scripting, ETL, and analytics |
| GitHub | Version control and portfolio hosting |

---

## 📊 Data Sources

The project uses **6 CSV files** simulating two enterprise source systems:

**CRM System:**
| File | Description | Rows |
|---|---|---|
| `cust_info.csv` | Customer demographics | 18,493 |
| `prd_info.csv` | Product catalog | 397 |
| `sales_details.csv` | Sales transactions | 60,398 |

**ERP System:**
| File | Description | Rows |
|---|---|---|
| `CUST_AZ12.csv` | Customer birthdate and gender | 18,483 |
| `LOC_A101.csv` | Customer country data | 18,484 |
| `PX_CAT_G1V2.csv` | Product categories | 37 |

---

## 🧹 Data Cleaning Highlights

The Silver Layer resolves the following data quality issues found in the raw Bronze data:

| Issue | Table | Fix Applied |
|---|---|---|
| Duplicate customers | `crm_cust_info` | `ROW_NUMBER()` deduplication — 9 duplicates removed |
| Inconsistent gender values (F, Female, FEMALE) | `crm_cust_info`, `erp_cust_az12` | Standardized to 'Male' / 'Female' / 'n/a' |
| Inconsistent marital status (S, M) | `crm_cust_info` | Standardized to 'Single' / 'Married' / 'n/a' |
| Dates stored as integers (20210101) | `crm_sales_details` | Converted to proper DATE type |
| Invalid sales amounts | `crm_sales_details` | Recalculated as quantity × price |
| Future birthdates | `erp_cust_az12` | Replaced with NULL |
| Inconsistent country names (US, USA) | `erp_loc_a101` | Standardized to full country names |
| Combined product/category key | `crm_prd_info` | Split into separate `cat_id` and `prd_key` columns |
| NULL product costs | `crm_prd_info` | Replaced with 0 using `ISNULL()` |

---

## ⭐ Star Schema (Gold Layer)

```
                    ┌─────────────────┐
                    │  dim_customers  │
                    │─────────────────│
                    │ customer_key PK │
                    │ customer_number │
                    │ first_name      │
                    │ last_name       │
                    │ country         │
                    │ gender          │
                    │ marital_status  │
                    │ birthdate       │
                    │ create_date     │
                    └────────┬────────┘
                             │
                             │
┌─────────────────┐   ┌──────┴───────────┐
│  dim_products   │   │   fact_sales     │
│─────────────────│   │──────────────────│
│ product_key  PK │◄──│ product_key   FK │
│ product_number  │   │ customer_key  FK │
│ product_name    │   │ order_number     │
│ category        │   │ order_date       │
│ subcategory     │   │ ship_date        │
│ product_line    │   │ due_date         │
│ cost            │   │ sales_amount     │
│ maintenance     │   │ quantity         │
└─────────────────┘   │ price            │
                      └──────────────────┘
```

---

## 📈 Analytics & Reporting

Three analytical views built on top of the Gold Layer:

### `report_customers`
- Customer segmentation: **VIP**, **Regular**, **Inactive**
- Age group segmentation: Under 30, 30-44, 45-60, Over 60
- Metrics: total orders, total sales, average order value, lifespan in months

### `report_products`
- Product performance segmentation: **High**, **Mid**, **Low Performer**
- Cost segmentation: **Expensive**, **Mid Range**, **Affordable**
- Recency segmentation based on last order date

### `report_sales`
- Monthly sales trends
- Cumulative sales per year
- Month-over-month change
- Year-to-date average sales

---

## 🚀 How to Run This Project

**Prerequisites:**
- [SQL Server Express](https://www.microsoft.com/en-us/sql-server/sql-server-downloads) installed
- [SSMS](https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms) installed
- CSV files from the `datasets/` folder saved locally

**Steps:**
1. Run `scripts/init_database.sql` — creates the `DataWarehouse` database and schemas
2. Run `scripts/bronze/ddl_bronze.sql` — creates the bronze tables
3. Update the file paths in `scripts/bronze/proc_load_bronze.sql` to match your local CSV location, then run it
4. Execute `EXEC bronze.load_bronze` to load the raw data
5. Run `scripts/silver/ddl_silver.sql` — creates the silver tables
6. Run `scripts/silver/proc_load_silver.sql` — creates the cleaning procedure
7. Execute `EXEC silver.load_silver` to load the cleaned data
8. Run `scripts/gold/ddl_gold.sql` — creates the star schema views
9. Run the three report scripts in `scripts/gold/`
10. Use `tests/quality_checks.sql` to verify results at any layer

---

## 🙏 Credits

This project was built by following the tutorial **"SQL Data Warehouse from Scratch | Full Hands-On Data Engineering Project"** by **Baraa Khatib Salkini (Data with Baraa)**, posted on February 10, 2025.

- 📺 YouTube: [@DataWithBaraa](https://www.youtube.com/@DataWithBaraa)
- 🌐 Website: [datawithbaraa.com](https://www.datawithbaraa.com)
- 💼 LinkedIn: [Baraa Khatib Salkini](https://linkedin.com/in/baraa-khatib-salkini)
- 📁 Original Repository: [sql-data-warehouse-project](https://github.com/DataWithBaraa/sql-data-warehouse-project)

---

## 📜 License

This project is licensed under the [MIT License](LICENSE). Free to use with proper attribution.
