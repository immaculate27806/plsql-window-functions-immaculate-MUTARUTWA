# PL/SQL Window Functions – Inyange Industries Rwanda

**Course:** Database Development with PL/SQL (INSY 8311)  
**Student:** MUTARUTWA immaculate 
**Student ID:** 27806 
**Assignment:** Individual Assignment I – Window Functions Mastery Project  
**Submission Date:** September 26, 2025  
**Repository:** [plsql-window-functions-mutarutwa immaculate](https://github.com/yourusername/plsql-window-functions-mutarutwa immaculate)  

---

## Step 1: Problem Definition 

### Business Context
Inyange Industries is Rwanda’s leading food and beverage company, producing and distributing milk, yogurt, juice, and bottled water. Its operations extend to every province, with products reaching supermarkets, schools, restaurants, and small retail shops. The company plays a vital role in national nutrition, serving millions of Rwandans daily.

### Data Challenge
The company processes thousands of transactions per month across multiple regions, but management struggles to:  
- Track top-selling products per region.  
- Monitor sales growth trends.  
- Segment customers based on purchasing behavior.  

Without analytical insights, inefficiencies may occur in production planning, logistics, and marketing.

### Expected Outcome
By applying **PL/SQL window functions**, Inyange Industries will:  
- Identify top-performing products per region and quarter.  
- Track running totals and moving averages of sales.  
- Measure month-over-month growth rates.  
- Segment customers into spending quartiles.  
- Provide actionable insights for targeted marketing and supply-chain optimization.

---

## Step 2: Success Criteria 

**Measurable Goals using window functions:**

| Goal | Function |
|------|---------|
| Top 5 products per region/quarter | `RANK()` |
| Running monthly sales totals | `SUM() OVER()` |
| Month-over-month growth rates | `LAG()` / `LEAD()` |
| Customer quartiles segmentation | `NTILE(4)` |
| 3-month moving averages | `AVG() OVER()` |

---

## Step 3: Database Schema 

### Tables

| Table | Purpose | Key Columns | Example Row |
|-------|---------|------------|------------|
| customers | Customer information | customer_id (PK), name, region, type | 1001, Nyamirambo Supermarket, Kigali, Retail |
| products | Product catalog | product_id (PK), name, category, unit_price | 2001, Fresh Milk 1L, Dairy, 1000 |
| distributors | Distribution hubs | distributor_id (PK), region, warehouse_name | 301, Kigali, Central Depot |
| transactions | Sales records linking all entities | transaction_id (PK), customer_id (FK), product_id (FK), distributor_id (FK), sale_date, quantity, amount | 4001, 1001, 2001, 301, 2025-01-15, 200, 250000 |

### ER Diagram
