-- =====================================================
-- PL/SQL Window Functions Project - Window Functions Queries
-- Student: MUTARUTWA Immaculate
-- Course: Database Development with PL/SQL (INSY 8311)
-- Case Study: Inyange Industries Rwanda
-- =====================================================

-- =========================================
-- WINDOW FUNCTIONS QUERIES FOR SCREENSHOTS
-- =========================================

-- SCREENSHOT 3: ROW_NUMBER() Results
-- Query 1: Rank products by sales for each distributor
SELECT 
    d.warehouse_name AS distributor,
    p.name AS product_name,
    SUM(t.amount) AS total_sales,
    ROW_NUMBER() OVER (PARTITION BY d.warehouse_name ORDER BY SUM(t.amount) DESC) AS sales_rank
FROM transactions t
JOIN products p ON t.product_id = p.product_id
JOIN distributors d ON t.distributor_id = d.distributor_id
WHERE t.sale_date >= DATE '2024-01-01'
GROUP BY d.warehouse_name, p.name
ORDER BY d.warehouse_name, sales_rank;

-- SCREENSHOT 4: RANK() and DENSE_RANK() Comparison
-- Query 2: Compare different ranking functions
SELECT 
    d.warehouse_name AS distributor,
    p.name AS product_name,
    SUM(t.amount) AS total_sales,
    RANK() OVER (PARTITION BY d.warehouse_name ORDER BY SUM(t.amount) DESC) AS rank_with_gaps,
    DENSE_RANK() OVER (PARTITION BY d.warehouse_name ORDER BY SUM(t.amount) DESC) AS dense_rank,
    ROW_NUMBER() OVER (PARTITION BY d.warehouse_name ORDER BY SUM(t.amount) DESC) AS row_number
FROM transactions t
JOIN products p ON t.product_id = p.product_id
JOIN distributors d ON t.distributor_id = d.distributor_id
GROUP BY d.warehouse_name, p.name
ORDER BY d.warehouse_name, total_sales DESC;

-- SCREENSHOT 5: PERCENT_RANK() Analysis
-- Query 3: Show product ranks as percentages
SELECT 
    d.warehouse_name AS distributor,
    p.name AS product_name,
    SUM(t.amount) AS total_sales,
    ROUND(PERCENT_RANK() OVER (PARTITION BY d.warehouse_name ORDER BY SUM(t.amount) DESC), 3) AS percent_rank,
    CASE 
        WHEN PERCENT_RANK() OVER (PARTITION BY d.warehouse_name ORDER BY SUM(t.amount) DESC) <= 0.25 THEN 'Top 25%'
        WHEN PERCENT_RANK() OVER (PARTITION BY d.warehouse_name ORDER BY SUM(t.amount) DESC) <= 0.50 THEN 'Top 50%'
        WHEN PERCENT_RANK() OVER (PARTITION BY d.warehouse_name ORDER BY SUM(t.amount) DESC) <= 0.75 THEN 'Top 75%'
        ELSE 'Bottom 25%'
    END AS performance_quartile
FROM transactions t
JOIN products p ON t.product_id = p.product_id
JOIN distributors d ON t.distributor_id = d.distributor_id
GROUP BY d.warehouse_name, p.name
ORDER BY d.warehouse_name, total_sales DESC;

-- SCREENSHOT 6: Running Totals Analysis
-- Query 4: Calculate monthly running totals
SELECT 
    TO_CHAR(t.sale_date, 'YYYY-MM') AS sale_month,
    d.warehouse_name AS distributor,
    SUM(t.amount) AS monthly_sales,
    SUM(SUM(t.amount)) OVER (
        PARTITION BY d.warehouse_name 
        ORDER BY TO_CHAR(t.sale_date, 'YYYY-MM') 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM transactions t
JOIN distributors d ON t.distributor_id = d.distributor_id
GROUP BY TO_CHAR(t.sale_date, 'YYYY-MM'), d.warehouse_name
ORDER BY d.warehouse_name, sale_month;

-- SCREENSHOT 7: ROWS vs RANGE Frame Comparison
-- Query 5: Compare ROWS vs RANGE
SELECT 
    TO_CHAR(t.sale_date, 'YYYY-MM') AS sale_month,
    d.warehouse_name AS distributor,
    SUM(t.amount) AS monthly_sales,
    SUM(SUM(t.amount)) OVER (
        PARTITION BY d.warehouse_name 
        ORDER BY TO_CHAR(t.sale_date, 'YYYY-MM') 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_rows,
    SUM(SUM(t.amount)) OVER (
        PARTITION BY d.warehouse_name 
        ORDER BY TO_CHAR(t.sale_date, 'YYYY-MM') 
        RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_range
FROM transactions t
JOIN distributors d ON t.distributor_id = d.distributor_id
GROUP BY TO_CHAR(t.sale_date, 'YYYY-MM'), d.warehouse_name
ORDER BY d.warehouse_name, sale_month;
-- SCREENSHOT 8: Three-Month Moving Averages
-- Query 6: Calculate 3-month moving averages
SELECT 
    TO_CHAR(t.sale_date, 'YYYY-MM') AS sale_month,
    d.warehouse_name AS distributor,
    SUM(t.amount) AS monthly_sales,
    ROUND(AVG(SUM(t.amount)) OVER (
        PARTITION BY d.warehouse_name 
        ORDER BY TO_CHAR(t.sale_date, 'YYYY-MM') 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS three_month_moving_avg,
    CASE 
        WHEN SUM(t.amount) > AVG(SUM(t.amount)) OVER (
            PARTITION BY d.warehouse_name 
            ORDER BY TO_CHAR(t.sale_date, 'YYYY-MM') 
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ) THEN 'Above Average'
        ELSE 'Below Average'
    END AS trend_indicator
FROM transactions t
JOIN distributors d ON t.distributor_id = d.distributor_id
GROUP BY TO_CHAR(t.sale_date, 'YYYY-MM'), d.warehouse_name
ORDER BY d.warehouse_name, sale_month;

-- SCREENSHOT 9: LAG() Previous Month Comparison
-- Query 7: Compare with previous month sales
SELECT 
    TO_CHAR(t.sale_date, 'YYYY-MM') AS sale_month,
    d.warehouse_name AS distributor,
    SUM(t.amount) AS current_month_sales,
    LAG(SUM(t.amount)) OVER (
        PARTITION BY d.warehouse_name 
        ORDER BY TO_CHAR(t.sale_date, 'YYYY-MM')
    ) AS previous_month_sales,
    SUM(t.amount) - LAG(SUM(t.amount)) OVER (
        PARTITION BY d.warehouse_name 
        ORDER BY TO_CHAR(t.sale_date, 'YYYY-MM')
    ) AS sales_difference
FROM transactions t
JOIN distributors d ON t.distributor_id = d.distributor_id
GROUP BY TO_CHAR(t.sale_date, 'YYYY-MM'), d.warehouse_name
ORDER BY d.warehouse_name, sale_month;

-- SCREENSHOT 10: LEAD() Future Period Analysis
-- Query 8: Compare with next month sales
SELECT 
    TO_CHAR(t.sale_date, 'YYYY-MM') AS sale_month,
    d.warehouse_name AS distributor,
    SUM(t.amount) AS current_month_sales,
    LEAD(SUM(t.amount)) OVER (
        PARTITION BY d.warehouse_name 
        ORDER BY TO_CHAR(t.sale_date, 'YYYY-MM')
    ) AS next_month_sales,
    CASE 
        WHEN LEAD(SUM(t.amount)) OVER (
            PARTITION BY d.warehouse_name 
            ORDER BY TO_CHAR(t.sale_date, 'YYYY-MM')
        ) > SUM(t.amount) THEN 'Growth Expected'
        WHEN LEAD(SUM(t.amount)) OVER (
            PARTITION BY d.warehouse_name 
            ORDER BY TO_CHAR(t.sale_date, 'YYYY-MM')
        ) < SUM(t.amount) THEN 'Decline Expected'
        ELSE 'No Data Available'
    END AS trend_prediction
FROM transactions t
JOIN distributors d ON t.distributor_id = d.distributor_id
GROUP BY TO_CHAR(t.sale_date, 'YYYY-MM'), d.warehouse_name
ORDER BY d.warehouse_name, sale_month;

-- SCREENSHOT 11: Growth Percentage Calculations
-- Query 9: Month-over-month growth rates
SELECT 
    TO_CHAR(t.sale_date, 'YYYY-MM') AS sale_month,
    d.warehouse_name AS distributor,
    SUM(t.amount) AS current_month_sales,
    LAG(SUM(t.amount)) OVER (
        PARTITION BY d.warehouse_name 
        ORDER BY TO_CHAR(t.sale_date, 'YYYY-MM')
    ) AS previous_month_sales,
    CASE 
        WHEN LAG(SUM(t.amount)) OVER (
            PARTITION BY d.warehouse_name 
            ORDER BY TO_CHAR(t.sale_date, 'YYYY-MM')
        ) IS NOT NULL THEN
            ROUND(
                ((SUM(t.amount) - LAG(SUM(t.amount)) OVER (
                    PARTITION BY d.warehouse_name 
                    ORDER BY TO_CHAR(t.sale_date, 'YYYY-MM')
                )) / LAG(SUM(t.amount)) OVER (
                    PARTITION BY d.warehouse_name 
                    ORDER BY TO_CHAR(t.sale_date, 'YYYY-MM')
                )) * 100, 2
            )
        ELSE NULL
    END AS growth_percentage
FROM transactions t
JOIN distributors d ON t.distributor_id = d.distributor_id
GROUP BY TO_CHAR(t.sale_date, 'YYYY-MM'), d.warehouse_name
ORDER BY d.warehouse_name, sale_month;

-- SCREENSHOT 12: NTILE() Customer Quartiles
-- Query 10: Group customers into quartiles
WITH customer_totals AS (
    SELECT 
        c.customer_id,
        c.name,
        c.region,
        SUM(t.amount) AS total_spending,
        COUNT(t.transaction_id) AS transaction_count
    FROM customers c
    JOIN transactions t ON c.customer_id = t.customer_id
    GROUP BY c.customer_id, c.name, c.region
)
SELECT 
    customer_id,
    name,
    region,
    total_spending,
    transaction_count,
    NTILE(4) OVER (ORDER BY total_spending DESC) AS spending_quartile
FROM customer_totals
ORDER BY total_spending DESC;

-- SCREENSHOT 13: CUME_DIST() Cumulative Distribution
-- Query 11: Customer percentile analysis
WITH customer_totals AS (
    SELECT 
        c.customer_id,
        c.name,
        c.region,
        SUM(t.amount) AS total_spending
    FROM customers c
    JOIN transactions t ON c.customer_id = t.customer_id
    GROUP BY c.customer_id, c.name, c.region
)
SELECT 
    name,
    region,
    total_spending,
    ROUND(CUME_DIST() OVER (ORDER BY total_spending), 3) AS cumulative_dist,
    ROUND(CUME_DIST() OVER (ORDER BY total_spending) * 100, 1) AS percentile
FROM customer_totals
ORDER BY total_spending DESC;

-- SCREENSHOT 14: Customer Segment Labels
-- Query 12: Business-friendly segmentation
WITH customer_totals AS (
    SELECT 
        c.customer_id,
        c.name,
        c.region,
        SUM(t.amount) AS total_spending,
        COUNT(t.transaction_id) AS transaction_count
    FROM customers c
    JOIN transactions t ON c.customer_id = t.customer_id
    GROUP BY c.customer_id, c.name, c.region
)
SELECT 
    customer_id,
    name,
    region,
    total_spending,
    transaction_count,
    NTILE(4) OVER (ORDER BY total_spending DESC) AS spending_quartile,
    CASE NTILE(4) OVER (ORDER BY total_spending DESC)
        WHEN 1 THEN 'VIP Customer'
        WHEN 2 THEN 'High Value'
        WHEN 3 THEN 'Regular'
        WHEN 4 THEN 'Price Sensitive'
    END AS customer_segment,
    ROUND(total_spending / transaction_count, 2) AS avg_transaction_value
FROM customer_totals
ORDER BY total_spending DESC;

-- SCREENSHOT 15: First and Last Values Analysis
-- Query 13: FIRST_VALUE and LAST_VALUE functions
SELECT 
    TO_CHAR(t.sale_date, 'YYYY-MM') AS sale_month,
    d.warehouse_name AS distributor,
    SUM(t.amount) AS monthly_sales,
    FIRST_VALUE(SUM(t.amount)) OVER (
        PARTITION BY d.warehouse_name 
        ORDER BY TO_CHAR(t.sale_date, 'YYYY-MM') 
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS first_month_sales,
    LAST_VALUE(SUM(t.amount)) OVER (
        PARTITION BY d.warehouse_name 
        ORDER BY TO_CHAR(t.sale_date, 'YYYY-MM') 
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS last_month_sales,
    SUM(t.amount) - FIRST_VALUE(SUM(t.amount)) OVER (
        PARTITION BY d.warehouse_name 
        ORDER BY TO_CHAR(t.sale_date, 'YYYY-MM') 
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS change_from_first
FROM transactions t
JOIN distributors d ON t.distributor_id = d.distributor_id
GROUP BY TO_CHAR(t.sale_date, 'YYYY-MM'), d.warehouse_name
ORDER BY d.warehouse_name, sale_month;

-- SCREENSHOT 16: Advanced Ranking with Ties
-- Query 14: Regional customer activity
SELECT 
    c.region,
    c.name AS customer_name,
    COUNT(t.transaction_id) AS transaction_count,
    RANK() OVER (PARTITION BY c.region ORDER BY COUNT(t.transaction_id) DESC) AS rank_with_gaps,
    DENSE_RANK() OVER (PARTITION BY c.region ORDER BY COUNT(t.transaction_id) DESC) AS dense_rank_no_gaps,
    ROW_NUMBER() OVER (PARTITION BY c.region ORDER BY COUNT(t.transaction_id) DESC, c.name) AS unique_row_number,
    CASE 
        WHEN RANK() OVER (PARTITION BY c.region ORDER BY COUNT(t.transaction_id) DESC) = 1 THEN 'Most Active'
        WHEN RANK() OVER (PARTITION BY c.region ORDER BY COUNT(t.transaction_id) DESC) <= 3 THEN 'Top 3'
        ELSE 'Regular Activity'
    END AS activity_level
FROM customers c
JOIN transactions t ON c.customer_id = t.customer_id
GROUP BY c.region, c.name, c.customer_id
ORDER BY c.region, transaction_count DESC;

-- SCREENSHOT 17: Window Frame Variations
-- Query 15: Different frame specs
SELECT 
    TO_CHAR(t.sale_date, 'YYYY-MM') AS sale_month,
    d.warehouse_name AS distributor,
    SUM(t.amount) AS monthly_sales,
    SUM(SUM(t.amount)) OVER (
        PARTITION BY d.warehouse_name 
        ORDER BY TO_CHAR(t.sale_date, 'YYYY-MM') 
        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
    ) AS three_month_window,
    AVG(SUM(t.amount)) OVER (
        PARTITION BY d.warehouse_name 
        ORDER BY TO_CHAR(t.sale_date, 'YYYY-MM') 
        ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING
    ) AS forward_looking_avg,
    SUM(SUM(t.amount)) OVER (
        PARTITION BY d.warehouse_name 
        ORDER BY TO_CHAR(t.sale_date, 'YYYY-MM') 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS trailing_three_month_sum
FROM transactions t
JOIN distributors d ON t.distributor_id = d.distributor_id
GROUP BY TO_CHAR(t.sale_date, 'YYYY-MM'), d.warehouse_name
ORDER BY d.warehouse_name, sale_month;

-- SCREENSHOT 18: Advanced Customer Analytics
-- Query 16: Multi-level analysis
WITH customer_analytics AS (
    SELECT 
        c.customer_id,
        c.name,
        c.region,
        SUM(t.amount) AS total_spending,
        COUNT(t.transaction_id) AS transaction_count,
        AVG(t.amount) AS avg_transaction_amount,
        MAX(t.sale_date) AS last_purchase_date,
        MIN(t.sale_date) AS first_purchase_date
    FROM customers c
    JOIN transactions t ON c.customer_id = t.customer_id
    GROUP BY c.customer_id, c.name, c.region
)
SELECT 
    name,
    region,
    total_spending,
    transaction_count,
    ROUND(avg_transaction_amount, 2) AS avg_transaction_amount,
    NTILE(5) OVER (ORDER BY total_spending DESC) AS spending_quintile,
    ROUND(PERCENT_RANK() OVER (ORDER BY transaction_count DESC) * 100, 1) AS frequency_percentile,
    RANK() OVER (PARTITION BY region ORDER BY total_spending DESC) AS regional_spending_rank,
    CASE 
        WHEN NTILE(5) OVER (ORDER BY total_spending DESC) = 1 THEN 'Platinum'
        WHEN NTILE(5) OVER (ORDER BY total_spending DESC) = 2 THEN 'Gold'
        WHEN NTILE(5) OVER (ORDER BY total_spending DESC) = 3 THEN 'Silver'
        WHEN NTILE(5) OVER (ORDER BY total_spending DESC) = 4 THEN 'Bronze'
        ELSE 'Standard'
    END AS loyalty_tier
FROM customer_analytics
ORDER BY total_spending DESC;

-- SCREENSHOT 19: Product Performance Matrix
-- Query 17: Product performance analysis
SELECT 
    p.name AS product_name,
    p.category,
    d.warehouse_name AS distributor,
    SUM(t.amount) AS total_sales,
    COUNT(t.transaction_id) AS units_sold,
    RANK() OVER (ORDER BY SUM(t.amount) DESC) AS overall_sales_rank,
    RANK() OVER (PARTITION BY p.category ORDER BY SUM(t.amount) DESC) AS category_rank,
    RANK() OVER (PARTITION BY d.warehouse_name ORDER BY SUM(t.amount) DESC) AS distributor_rank,
    ROUND(SUM(t.amount) / SUM(SUM(t.amount)) OVER () * 100, 2) AS market_share_percent,
    ROUND(SUM(t.amount) / SUM(SUM(t.amount)) OVER (PARTITION BY p.category) * 100, 2) AS category_share_percent,
    CASE 
        WHEN RANK() OVER (PARTITION BY p.category ORDER BY SUM(t.amount) DESC) = 1 THEN 'Category Leader'
        WHEN RANK() OVER (PARTITION BY p.category ORDER BY SUM(t.amount) DESC) <= 3 THEN 'Top Performer'
        ELSE 'Standard Product'
    END AS performance_status
FROM transactions t
JOIN products p ON t.product_id = p.product_id
JOIN distributors d ON t.distributor_id = d.distributor_id
GROUP BY p.name, p.category, d.warehouse_name, p.product_id
ORDER BY total_sales DESC;

-- SCREENSHOT 20: Business Intelligence Summary
-- Query 18: Executive dashboard
SELECT 
    'Window Function Summary Report' AS report_section,
    'Total Products Analyzed' AS metric_name,
    COUNT(DISTINCT p.product_id) AS metric_value
FROM transactions t
JOIN products p ON t.product_id = p.product_id
UNION ALL
SELECT 
    'Window Function Summary Report',
    'Total Customers Segmented',
    COUNT(DISTINCT c.customer_id)
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
UNION ALL
SELECT 
    'Window Function Summary Report',
    'Total Distributors Analyzed',
    COUNT(DISTINCT d.distributor_id)
FROM transactions t
JOIN distributors d ON t.distributor_id = d.distributor_id
UNION ALL
SELECT 
    'Window Function Summary Report',
    'Total Monthly Periods',
    COUNT(DISTINCT TO_CHAR(t.sale_date, 'YYYY-MM'))
FROM transactions t
UNION ALL
SELECT 
    'Business Metrics',
    'Top Customer Spending (RWF)',
    MAX(customer_total)
FROM (
    SELECT SUM(t.amount) AS customer_total
    FROM transactions t
    GROUP BY t.customer_id
)
UNION ALL
SELECT 
    'Business Metrics',
    'Average Monthly Sales (RWF)',
    ROUND(AVG(monthly_total))
FROM (
    SELECT SUM(t.amount) AS monthly_total
    FROM transactions t
    GROUP BY TO_CHAR(t.sale_date, 'YYYY-MM')
)
ORDER BY 1, 2;

-- =====================================================
-- ASSIGNMENT SUCCESS CRITERIA QUERIES
-- =====================================================

-- SUCCESS CRITERIA #1: Top 5 products per region (Inyange Requirement)
-- Query 19: Find top 5 products per region
SELECT * FROM (
    SELECT 
        c.region,
        p.name AS product_name,
        p.category,
        SUM(t.amount) AS total_sales,
        COUNT(t.transaction_id) AS total_transactions,
        RANK() OVER (PARTITION BY c.region ORDER BY SUM(t.amount) DESC) AS rank_position
    FROM transactions t
    JOIN products p ON t.product_id = p.product_id
    JOIN customers c ON t.customer_id = c.customer_id
    GROUP BY c.region, p.name, p.category
) ranked_products
WHERE rank_position <= 5
ORDER BY region, rank_position;







