# PL/SQL Window Functions Analysis: Inyange Industries Rwanda

**Course:** Database Development with PL/SQL (INSY 8311)  
**Student:** MUTARUTWA immaculate 
**Student ID:** 27806
**Assignment:** Individual Assignment I - Window Functions Mastery Project  
**Submission Date:** September 27, 2025  
**Repository:** plsql-window-functions-mutarutwa-immaculate 

---

## Step 1: Problem Definition  

### Business Context  
Inyange Industries is Rwanda’s leading food and beverage manufacturer, producing milk, yogurt, fruit juices, and bottled water. Its distribution network covers the entire country, with products sold in supermarkets, local shops, schools, and restaurants across Kigali, Huye, Musanze, Rubavu, and other regions. As a flagship Rwandan brand, Inyange has become a household name and a critical player in the nation’s food security and nutrition strategy. The company supplies thousands of liters of milk daily and employs hundreds of staff in production, logistics, and distribution.  

### Data Challenge  
Despite being a national leader, Inyange Industries faces challenges in understanding regional product performance and tracking seasonal sales fluctuations. Management lacks clear insights into which products dominate in which regions, how customer purchasing behavior changes month-to-month, and whether certain products should be prioritized in production and distribution. Without data-driven insights, stock allocation and marketing campaigns risk inefficiency.  

### Expected Outcome  
The window functions analysis will help Inyange Industries identify top-selling products per region, track cumulative and monthly sales growth, segment customers into value tiers, and analyze trends across multiple months. These insights will support better production planning, smarter regional distribution, and targeted marketing programs.  

---

## Step 2: Success Criteria (5 Measurable Goals)  

| **Success Criteria**                | **Window Function Used**                                | **Analysis Type**              | **Screenshot**   |
|-------------------------------------|---------------------------------------------------------|--------------------------------|------------------|
| 1. Top 5 products per region         | `RANK() OVER(PARTITION BY region ORDER BY total_sales DESC)` | Regional Product Rankings       | Screenshot 21    |
| 2. Running monthly sales totals      | `SUM() OVER(ORDER BY month ROWS UNBOUNDED PRECEDING)`   | Running Totals Analysis         | Screenshot 6     |
| 3. Month-over-month growth           | `LAG()` and `LEAD()` for growth %                       | Growth Percentage Calculations  | Screenshot 11    |
| 4. Customer quartiles segmentation   | `NTILE(4) OVER(ORDER BY total_spending DESC)`           | Customer Quartiles              | Screenshot 12    |
| 5. 3-month moving averages           | `AVG() OVER(ORDER BY month ROWS 2 PRECEDING)`           | Moving Averages Analysis        | Screenshot 8     |

### Detailed Success Criteria  
- **Top 5 products per region** → Identify whether milk, yogurt, juice, or bottled water performs best in Kigali vs rural regions using `RANK()`.  
- **Running monthly sales totals** → Track cumulative product sales over the year to detect growth patterns using `SUM() OVER()`.  
- **Month-over-month growth analysis** → Use `LAG()/LEAD()` to measure changes, e.g., milk sales growth between April and May.  
- **Customer quartiles segmentation** → Classify retailers (supermarkets, schools, restaurants) into quartiles by purchase volumes using `NTILE(4)`.  
- **3-month moving averages** → Smooth seasonal demand patterns (e.g., school reopening months, holidays) using `AVG() OVER()`.  

---

## Step 3: Database Schema Design
## Entity Relationship Diagram  

```plaintext
┌─────────────────┐         ┌────────────────────┐
│    CUSTOMERS    │         │    DISTRIBUTORS    │
├─────────────────┤         ├────────────────────┤
│ customer_id (PK)│         │ distributor_id (PK)│
│ name            │         │ region             │
│ type (retail/   │         │ warehouse_name     │
│ wholesale/school│         │ contact_person     │
└─────────┬───────┘         └─────────┬──────────┘
          │                           │
          │ 1                         │ 1
          │                           │
          │ M                         │ M
          └──────┐           ┌────────┘
                 │           │
                 ▼           ▼
         ┌─────────────────────────┐
         │     TRANSACTIONS        │
         ├─────────────────────────┤
         │ transaction_id (PK)     │
         │ customer_id (FK)        │
         │ product_id (FK)         │
         │ distributor_id (FK)     │
         │ sale_date               │
         │ quantity                │
         │ amount                  │
         └─────────┬───────────────┘
                   │
                   │ M
                   │
                   │ 1
                   ▼
         ┌─────────────────┐
         │    PRODUCTS     │
         ├─────────────────┤
         │ product_id (PK) │
         │ name            │
         │ category        │
         │ unit_price      │
         └─────────────────┘
  ```        
### Business Rules and Relationships  
- One customer (supermarket, school, shop) can make many transactions (1:M).  
- One distributor can process many transactions (1:M).  
- One product (milk, juice, water, yogurt) can appear in many transactions (1:M).  
- Each transaction is linked to one customer, one distributor, and one product.  

### Table Specifications  

| **Table**      | **Purpose**                           | **Key Columns**                                  | **Example Row** |
|----------------|---------------------------------------|--------------------------------------------------|-----------------|
| customers      | Customer details (retailers, schools) | customer_id (PK), name, type, region             | 1001, Nyamirambo Supermarket, Retail, Kigali |
| products       | Product catalog (milk, juice, water)  | product_id (PK), name, category, unit_price      | 2001, Fresh Milk 1L, Dairy, 1000 |
| distributors   | Distribution centers by region        | distributor_id (PK), warehouse_name, region, contact_person | 301, Kigali Central Depot, Kigali, Jean Mugenzi |
| transactions   | Sales linking all entities            | transaction_id (PK), customer_id (FK), product_id (FK), distributor_id (FK), sale_date, amount | 4001, 1001, 2001, 301, 2024-05-12, 250,000 |

---
*Screenshot 1: Schema Creation*
<img width="145" height="73" alt="image" src="https://github.com/user-attachments/assets/349ab4cb-0b00-44b1-8b36-6e60787dbd6a" />



## Step 4: Window Functions Implementation  

### 4.1 Ranking Functions – Product Performance Analysis  
- **Functions:** `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`, `PERCENT_RANK()`  
- **Use Case:** Top products by region.  

*Screenshot 3: ROW_NUMBER() Results*  
*Screenshot 4: RANK() vs DENSE_RANK() Comparison*  
*Screenshot 5: PERCENT_RANK() Analysis*  

---

### 4.2 Aggregate Functions – Revenue Trend Analysis  
- **Functions:** `SUM()`, `AVG()`, `MIN()`, `MAX()` with frame specifications (`ROWS` vs `RANGE`).  
- **Use Case:** Running totals & moving averages.  

*Screenshot 6: Running Totals*  
*Screenshot 7: ROWS vs RANGE Comparison*  
*Screenshot 8: 3-Month Moving Averages*  

---

### 4.3 Navigation Functions – Growth Pattern Analysis  
- **Functions:** `LAG()`, `LEAD()`  
- **Use Case:** Month-over-month growth analysis.  

*Screenshot 9: LAG() Previous Month Comparison*  
*Screenshot 10: LEAD() Future Analysis*  
*Screenshot 11: Growth Percentage Calculations*  

---

### 4.4 Distribution Functions – Customer Segmentation  
- **Functions:** `NTILE(4)`, `CUME_DIST()`  
- **Use Case:** Customer quartile segmentation.  

*Screenshot 12: NTILE() Customer Quartiles*  
*Screenshot 13: CUME_DIST() Distribution*  
*Screenshot 14: Customer Segment Labels*  

---

## Step 5: Results Analysis  

### Descriptive – What Happened?  
- Milk dominates urban sales; yogurt and juice perform better in rural schools and shops.  
- Seasonal peaks in juice sales during hot months.  
- Top 25% of customers generate over 60% of revenue.  

### Diagnostic – Why These Patterns Occur?  
- Urban vs rural demand differences (milk and bottled water are urban staples, juice and yogurt see seasonal demand).  
- Schools drive bulk juice purchases around reopening months.  
- Heavy dependence on a few top customers introduces concentration risk.  

### Prescriptive – What Next?  
- Create loyalty programs for top customers.  
- Plan inventory for seasonal spikes (e.g., juice during hot seasons, milk during school reopening).  
- Reallocate resources to regions where growth potential is higher.  

---

## Step 6: GitHub Repository Structure

```plaintext
plsql-window-functions-mutarutwa-immaculate/
├── README.md                           # Main assignment report
├── sql_scripts/
│   ├── 01_schema_creation.sql          # Database schema setup
│   ├── 02_sample_data_insert.sql       # Sample data insertion
│   └── 03_window_functions_queries.sql # All window function queries
├── screenshots/
│   ├── 01_schema_creation.png
│   ├── 02_er_verification.png
│   ├── 03_row_number_results.png
│   ├── 04_rank_comparison.png
│   ├── 05_percent_rank_analysis.png
│   ├── 06_running_totals.png
│   ├── 07_rows_vs_range_comparison.png
│   ├── 08_moving_averages.png
│   ├── 09_lag_previous_month.png
│   ├── 10_lead_future_analysis.png
│   ├── 11_growth_percentage.png
│   ├── 12_ntile_customer_quartiles.png
│   ├── 13_cume_dist_percentiles.png
│   ├── 14_customer_segment_labels.png
│   └── 21_top_5_products_per_region.png
└── .git/

```
 
## Step 7: References  

1. Oracle Corporation. (2024). *Oracle Database SQL Language Reference - Analytic Functions*. [Oracle Docs](https://docs.oracle.com/en/database/oracle/oracle-database/21/sqlrf/Analytic-Functions.html)  
2. Oracle Corporation. (2024). *Oracle Database PL/SQL Language Reference*. [Oracle Docs](https://docs.oracle.com/en/database/oracle/oracle-database/21/lnpls/)  
3. TechOnTheNet. (2024). *Oracle / PLSQL: Analytic Functions*. [TechOnTheNet](https://www.techonthenet.com/oracle/functions/analytic/)  
4. W3Schools. (2024). *SQL Window Functions*. [W3Schools](https://www.w3schools.com/sql/sql_window_functions.asp)  
5. SQLBolt. (2024). *Lesson 18: Queries with Expressions*. [SQLBolt](https://sqlbolt.com/lesson/select_queries_with_expressions)  
6. Oracle Tutorial. (2023). *Oracle Window Functions Tutorial*. YouTube.  
7. Programming with Mosh. (2022). *SQL Window Functions Explained*. YouTube.  
8. Oracle Corporation. (2024). *Oracle Database Administrator's Guide - Creating Tables*. [Oracle Docs](https://docs.oracle.com/en/database/oracle/oracle-database/21/admin/creating-and-configuring-an-oracle-database.html)  
9. Inyange Industries Rwanda. (2024). *Company Website*. [Inyange Industries](https://inyangeindustries.com)  
10. Course Lecture Notes. (2025). *INSY 8311 – Database Development with PL/SQL*. AUCA.  

---

## Academic Integrity Statement  
All sources used in this project have been properly cited and referenced. While I consulted various learning resources and documentation to understand window function concepts and SQL syntax, the application of these concepts to Inyange Industries’ business scenario represents my own analytical work.  

I used the referenced Oracle documentation, online tutorials, and course materials to learn how window functions work and understand the proper syntax. The database design, business context development, and interpretation of results reflect my own understanding and analysis.  

---
