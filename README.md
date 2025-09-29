# PL/SQL Window Functions Analysis: Inyange Industries Rwanda

**Course:** Database Development with PL/SQL (INSY 8311)  
**Student:** MUTARUTWA immaculate 
**Student ID:** 27806
**Assignment:** Individual Assignment I - Window Functions Mastery Project  
**Submission Date:** September 29, 2025  
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


*Screenshot 2: Data Insertion*
<img width="179" height="80" alt="image" src="https://github.com/user-attachments/assets/6736901e-2d74-4979-83fd-3fac08780cfa" />


## Step 4: Window Functions Implementation  

### 4.1 Ranking Functions – Product Performance Analysis  
- **Functions:** `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`, `PERCENT_RANK()`  
- **Use Case:** Top products by region.  

*Screenshot 3: ROW_NUMBER() Results*  
<img width="368" height="113" alt="image" src="https://github.com/user-attachments/assets/2f69d7ed-eec8-430a-b5a0-6879f2c7e089" />

*Screenshot 4: RANK() vs DENSE_RANK() Comparison*  
<img width="355" height="110" alt="image" src="https://github.com/user-attachments/assets/559df254-883e-4650-bbbc-9365ba60514f" />

*Screenshot 5: PERCENT_RANK() Analysis*  
<img width="455" height="107" alt="image" src="https://github.com/user-attachments/assets/bdcce75e-abc5-464f-8adc-d355afe7a75e" />

---

### 4.2 Aggregate Functions – Revenue Trend Analysis  
- **Functions:** `SUM()`, `AVG()`, `MIN()`, `MAX()` with frame specifications (`ROWS` vs `RANGE`).  
- **Use Case:** Running totals & moving averages.  

*Screenshot 6: Running Totals*  
<img width="368" height="115" alt="image" src="https://github.com/user-attachments/assets/51fcf713-1fee-4e2a-85f7-669ef1af90e3" />

*Screenshot 7: ROWS vs RANGE Comparison* 
<img width="452" height="115" alt="image" src="https://github.com/user-attachments/assets/06dc5132-7115-474a-8f25-7fd22d93cf77" />

*Screenshot 8: 3-Month Moving Averages*  
<img width="449" height="116" alt="image" src="https://github.com/user-attachments/assets/8efb10c7-c876-47b0-84b1-64d0ff619353" />

---

### 4.3 Navigation Functions – Growth Pattern Analysis  
- **Functions:** `LAG()`, `LEAD()`  
- **Use Case:** Month-over-month growth analysis.  

*Screenshot 9: LAG() Previous Month Comparison*  
<img width="440" height="116" alt="image" src="https://github.com/user-attachments/assets/a11dc612-5840-410f-9d74-96a2c0d8813d" />

*Screenshot 10: LEAD() Future Analysis* 
<img width="457" height="117" alt="image" src="https://github.com/user-attachments/assets/d56dfb96-8c83-4b09-9e80-613f8b1f3519" />

*Screenshot 11: Growth Percentage Calculations*  
<img width="493" height="111" alt="image" src="https://github.com/user-attachments/assets/317b9fe5-f544-4026-8053-f7126267b07c" />

---

### 4.4 Distribution Functions – Customer Segmentation  
- **Functions:** `NTILE(4)`, `CUME_DIST()`  
- **Use Case:** Customer quartile segmentation.  

*Screenshot 12: NTILE() Customer Quartiles* 
<img width="509" height="113" alt="image" src="https://github.com/user-attachments/assets/233c45f4-443f-4f79-bb31-2b9efbaea790" />

*Screenshot 13: CUME_DIST() Distribution* 
<img width="382" height="116" alt="image" src="https://github.com/user-attachments/assets/973233ae-15df-4af5-9287-26451614282a" />

*Screenshot 14: Customer Segment Labels*  
<img width="569" height="107" alt="image" src="https://github.com/user-attachments/assets/d4a1d8a6-7e91-4948-a503-9a3d132c3685" />

---

*Screenshot 15: First and Last Values Analysis*
<img width="542" height="118" alt="image" src="https://github.com/user-attachments/assets/19be3e4c-d8f3-401b-b4ad-30c9bd745b81" />

-- *SCREENSHOT 16: Advanced Ranking with Ties*
<img width="559" height="118" alt="image" src="https://github.com/user-attachments/assets/1348e247-d638-41c3-a8a8-4222f5f3a488" />

-- *SCREENSHOT 17: Window Frame Variations*
<img width="548" height="116" alt="image" src="https://github.com/user-attachments/assets/dd788cc4-8f30-42f3-b6a2-f80a770e8bdd" />

--* SCREENSHOT 18: Advanced Customer Analytics*
<img width="563" height="107" alt="image" src="https://github.com/user-attachments/assets/8e3b988b-7ad8-419a-bc75-49440fade50e" />

*-- SCREENSHOT 19: Product Performance Matrix*
<img width="562" height="109" alt="image" src="https://github.com/user-attachments/assets/f582338c-d962-49f6-bb58-1790ca2c2593" />

*-- SCREENSHOT 20: Business Intelligence Summary*
<img width="366" height="95" alt="image" src="https://github.com/user-attachments/assets/59a77827-39f0-4ac1-bf99-e62a807a9509" />

<img width="434" height="115" alt="image" src="https://github.com/user-attachments/assets/55f8695a-82ac-408b-a7cb-77f05f75b20b" />




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
