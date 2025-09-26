-- =====================================================
-- PL/SQL Window Functions Project - Schema Creation
-- Student: MUTARUTWA immaculate
-- Course: Database Development with PL/SQL (INSY 8311)
-- Case Study: Inyange Industries Rwanda
-- =====================================================

-- SCREENSHOT 1: Database Schema Creation
-- Run these CREATE TABLE statements one by one

-- Create Customers table first (no dependencies)
CREATE TABLE customers (
    customer_id NUMBER(6) PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    type VARCHAR2(30) CHECK (type IN ('Retail', 'Wholesale', 'School')),
    region VARCHAR2(50) NOT NULL,
    contact_phone VARCHAR2(20),
    registration_date DATE DEFAULT SYSDATE
);

-- Create Products table  
CREATE TABLE products (
    product_id NUMBER(6) PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    category VARCHAR2(30) CHECK (category IN ('Milk', 'Juice', 'Water', 'Yogurt')),
    unit_price NUMBER(8,2) NOT NULL
);

-- Create Distributors table
CREATE TABLE distributors (
    distributor_id NUMBER(4) PRIMARY KEY,
    warehouse_name VARCHAR2(100) NOT NULL,
    region VARCHAR2(50) NOT NULL,
    contact_person VARCHAR2(50)
);

-- Create Transactions table
-- This has foreign keys so create it last
CREATE TABLE transactions (
    transaction_id NUMBER(8) PRIMARY KEY,
    customer_id NUMBER(6) NOT NULL,
    product_id NUMBER(6) NOT NULL,
    distributor_id NUMBER(4) NOT NULL,
    sale_date DATE NOT NULL,
    quantity NUMBER(5) DEFAULT 1,
    amount NUMBER(12,2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (distributor_id) REFERENCES distributors(distributor_id)
);

-- Create indexes for better performance
CREATE INDEX idx_transactions_date ON transactions(sale_date);
CREATE INDEX idx_transactions_customer ON transactions(customer_id);
CREATE INDEX idx_transactions_product ON transactions(product_id);
CREATE INDEX idx_transactions_distributor ON transactions(distributor_id);
CREATE INDEX idx_customers_region ON customers(region);
CREATE INDEX idx_products_category ON products(category);

-- Display table structure
DESCRIBE customers;
DESCRIBE products;
DESCRIBE distributors;
DESCRIBE transactions;

-- Verify constraints
SELECT constraint_name, constraint_type, table_name 
FROM user_constraints 
WHERE table_name IN ('CUSTOMERS', 'PRODUCTS', 'DISTRIBUTORS', 'TRANSACTIONS')
ORDER BY table_name, constraint_type;

COMMIT;

