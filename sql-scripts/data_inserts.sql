
-- PL/SQL Window Functions Project - Sample Data Insert
-- Student: MUTARUTWA Immaculate
-- Course: Database Development with PL/SQL (INSY 8311)
-- Case Study: Inyange Industries Rwanda
-- =====================================================

-- SCREENSHOT 2: Entity Relationship Verification
-- Verify all tables exist and show relationships
SELECT 
    table_name,
    'TABLE' AS object_type
FROM user_tables 
WHERE table_name IN ('CUSTOMERS', 'PRODUCTS', 'DISTRIBUTORS', 'TRANSACTIONS')
UNION ALL
SELECT 
    constraint_name,
    'FOREIGN KEY' AS object_type
FROM user_constraints 
WHERE table_name IN ('TRANSACTIONS') AND constraint_type = 'R'
ORDER BY object_type, table_name;

-- =====================================================
-- Insert Sample Data (run all inserts before screenshots)
-- =====================================================

-- Insert Customers (Retail, Wholesale, Schools)
INSERT INTO customers VALUES (1001, 'Jean Claude Uwimana', 'Retail', 'Kigali', '078-123-4567', DATE '2023-01-15');
INSERT INTO customers VALUES (1002, 'Marie Grace Mukamana', 'Wholesale', 'Huye', '078-234-5678', DATE '2023-02-20');
INSERT INTO customers VALUES (1003, 'Patrick Niyonshuti', 'School', 'Musanze', '078-345-6789', DATE '2023-03-10');
INSERT INTO customers VALUES (1004, 'Claudine Uwamahoro', 'Retail', 'Kigali', '078-456-7890', DATE '2023-01-25');
INSERT INTO customers VALUES (1005, 'Emmanuel Habimana', 'Wholesale', 'Rubavu', '078-567-8901', DATE '2023-04-05');
INSERT INTO customers VALUES (1006, 'Immaculee Mukeshimana', 'School', 'Nyagatare', '078-678-9012', DATE '2023-02-15');
INSERT INTO customers VALUES (1007, 'Didier Rugambwa', 'Retail', 'Rusizi', '078-789-0123', DATE '2023-03-20');
INSERT INTO customers VALUES (1008, 'Esperance Mukagatare', 'Wholesale', 'Kigali', '078-890-1234', DATE '2023-01-30');
INSERT INTO customers VALUES (1009, 'Vincent Mutabazi', 'School', 'Huye', '078-901-2345', DATE '2023-04-10');
INSERT INTO customers VALUES (1010, 'Solange Uwizeye', 'Retail', 'Musanze', '078-012-3456', DATE '2023-02-25');

-- Insert Products (Inyange product categories)
INSERT INTO products VALUES (2001, 'Fresh Milk 1L', 'Milk', 1200);
INSERT INTO products VALUES (2002, 'Fresh Milk 500ml', 'Milk', 700);
INSERT INTO products VALUES (2003, 'Inyange Yogurt 500ml', 'Yogurt', 1500);
INSERT INTO products VALUES (2004, 'Inyange Yogurt 1L', 'Yogurt', 2500);
INSERT INTO products VALUES (2005, 'Inyange Mango Juice 1L', 'Juice', 2000);
INSERT INTO products VALUES (2006, 'Inyange Apple Juice 500ml', 'Juice', 1000);
INSERT INTO products VALUES (2007, 'Inyange Mineral Water 500ml', 'Water', 500);
INSERT INTO products VALUES (2008, 'Inyange Mineral Water 1.5L', 'Water', 800);
INSERT INTO products VALUES (2009, 'Inyange Butter 250g', 'Dairy', 3500);
INSERT INTO products VALUES (2010, 'Inyange Cheese 200g', 'Dairy', 5000);

-- Insert Distributors (Inyange warehouses & regional depots)
INSERT INTO distributors VALUES (101, 'Inyange Kigali Main Depot', 'Kigali', 'Joseph Murenzi');
INSERT INTO distributors VALUES (102, 'Inyange Huye Distributor', 'Huye', 'Alice Uwimana');
INSERT INTO distributors VALUES (103, 'Inyange Musanze Depot', 'Musanze', 'Robert Nsengimana');
INSERT INTO distributors VALUES (104, 'Inyange Rubavu Warehouse', 'Rubavu', 'Grace Mukamana');
INSERT INTO distributors VALUES (105, 'Inyange Nyagatare Depot', 'Nyagatare', 'Jeanine Uwase');

-- Insert Transactions (Customers buying products from distributors)
INSERT INTO transactions VALUES (3001, 1001, 2001, 101, DATE '2024-01-15', 5, 6000);
INSERT INTO transactions VALUES (3002, 1002, 2005, 102, DATE '2024-01-16', 10, 20000);
INSERT INTO transactions VALUES (3003, 1003, 2003, 103, DATE '2024-01-17', 20, 30000);
INSERT INTO transactions VALUES (3004, 1004, 2007, 101, DATE '2024-01-18', 30, 15000);
INSERT INTO transactions VALUES (3005, 1005, 2009, 104, DATE '2024-01-20', 5, 17500);
INSERT INTO transactions VALUES (3006, 1006, 2002, 105, DATE '2024-02-05', 40, 28000);
INSERT INTO transactions VALUES (3007, 1007, 2004, 103, DATE '2024-02-10', 12, 30000);
INSERT INTO transactions VALUES (3008, 1008, 2006, 101, DATE '2024-02-12', 25, 25000);
INSERT INTO transactions VALUES (3009, 1009, 2008, 105, DATE '2024-02-15', 50, 40000);
INSERT INTO transactions VALUES (3010, 1010, 2010, 103, DATE '2024-02-18', 8, 40000);
INSERT INTO transactions VALUES (3011, 1001, 2005, 101, DATE '2024-03-01', 6, 12000);
INSERT INTO transactions VALUES (3012, 1002, 2007, 102, DATE '2024-03-05', 40, 20000);
INSERT INTO transactions VALUES (3013, 1003, 2009, 103, DATE '2024-03-08', 10, 35000);
INSERT INTO transactions VALUES (3014, 1004, 2001, 101, DATE '2024-03-12', 12, 14400);
INSERT INTO transactions VALUES (3015, 1005, 2008, 104, DATE '2024-03-15', 20, 16000);
INSERT INTO transactions VALUES (3016, 1006, 2003, 105, DATE '2024-03-18', 30, 45000);
INSERT INTO transactions VALUES (3017, 1007, 2002, 103, DATE '2024-03-20', 15, 10500);
INSERT INTO transactions VALUES (3018, 1008, 2006, 101, DATE '2024-03-25', 50, 50000);
INSERT INTO transactions VALUES (3019, 1009, 2010, 105, DATE '2024-03-28', 5, 25000);
INSERT INTO transactions VALUES (3020, 1010, 2004, 103, DATE '2024-03-30', 10, 25000);

COMMIT;

-- Verify data insertion
SELECT 'Distributors' as table_name, COUNT(*) as record_count FROM distributors
UNION ALL
SELECT 'Products', COUNT(*) FROM products
UNION ALL
SELECT 'Customers', COUNT(*) FROM customers
UNION ALL
SELECT 'Transactions', COUNT(*) FROM transactions;
