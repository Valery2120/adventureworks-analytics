# AdventureWorks BI: Analytical Platform Powered by dbt Core

This project is an **End-to-End solution** for transforming raw AdventureWorks ERP data
into structured data marts. The architecture is built on the principles of
**modularity and scalability**, enabling analysts to access reliable data
for **6 key business dashboards**.

---

## 🏗 Project Architecture

The project follows a **Layered (Medallion-style) Architecture**:

| Layer | Prefix | Description |
|---|---|---|
| **Staging** | `stg_` | Raw data cleansing from PostgreSQL, column renaming according to business logic, and type casting. |
| **Intermediate** | `int_` | Complex transformation layer. Handles entity joins, metric calculations (Lead Time, Profit), and missing value treatment (e.g., product categories). |
| **Marts** | `fct_`, `dim_` | Final data marts optimized for Power BI connectivity. Implements a **Star Schema** design. |

---

## 🛠 Technology Stack

- **Database:** PostgreSQL
- **Transformations:** dbt Core v1.11.7
- **Packages:** `dbt_utils` (for advanced testing and macros)
- **Environment:** Python 3.x (venv)

---

## 📊 Key Data Marts

| Model | Type | Description |
|---|---|---|
| `fct_sales` | Fact | Sales transactions, revenue, margin, and shipping lead times. |
| `dim_products` | Dimension | Complete product reference with categories and potential profit calculations. |
| `dim_customers` | Dimension | Customer segmentation by territory and type (Individual / Reseller). |
| `dim_salespersons` | Dimension | Sales team performance analytics and quota attainment tracking. |

---

## 🧪 Data Quality & Testing

The project includes **78 automated tests** ensuring full data integrity:

- **Generic Tests:** `unique`, `not_null`, `relationships`, `accepted_values`
- **Custom Tests:** Business logic validation via `dbt_utils.expression_is_true`
  *(e.g., asserting that margin cannot be negative within specific customer segments)*

---

## 🚀 Getting Started

**1. Install dependencies:**
```bash
dbt deps

**2. Build models (create tables/views in Postgres):**
```bash
dbt run

**3. Run tests:**
```bash
dbt test

**4. Generate and serve interactive docs + lineage graph:**
```bash
dbt docs generate
dbt docs serve

## Status

The project is **ready for integration with BI tools**.  
All **29 models** have been successfully **compiled** and **deployed**.
