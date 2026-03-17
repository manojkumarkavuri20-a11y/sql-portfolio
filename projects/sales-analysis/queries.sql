-- ============================================
-- SALES ANALYSIS - SQL Queries
-- Author: Manoj Kumar Kavuri
-- Database: PostgreSQL
-- ============================================

-- ============================================
-- 1. MONTHLY REVENUE TRENDS WITH MOM GROWTH
-- Business Question: How is revenue trending 
-- month over month? Are we growing?
-- ============================================

WITH monthly_revenue AS (
      SELECT
          DATE_TRUNC('month', o.order_date) AS month,
          SUM(o.total_amount) AS revenue,
          COUNT(DISTINCT o.order_id) AS total_orders,
          COUNT(DISTINCT o.customer_id) AS unique_customers
      FROM orders o
      GROUP BY DATE_TRUNC('month', o.order_date)
  )
SELECT
    month,
    revenue,
    total_orders,
    unique_customers,
    LAG(revenue) OVER (ORDER BY month) AS prev_month_revenue,
    ROUND(
          (revenue - LAG(revenue) OVER (ORDER BY month))
          / NULLIF(LAG(revenue) OVER (ORDER BY month), 0) * 100, 2
      ) AS mom_growth_pct
FROM monthly_revenue
ORDER BY month;


-- ============================================
-- 2. TOP 10 PRODUCTS BY REVENUE
-- Business Question: Which products drive the 
-- most revenue? Is there product concentration?
-- ============================================

SELECT
    p.product_name,
    p.category,
    SUM(oi.quantity) AS units_sold,
    SUM(oi.quantity * oi.unit_price) AS total_revenue,
    ROUND(
          SUM(oi.quantity * oi.unit_price) * 100.0 
        / SUM(SUM(oi.quantity * oi.unit_price)) OVER (), 2
      ) AS revenue_share_pct,
    RANK() OVER (ORDER BY SUM(oi.quantity * oi.unit_price) DESC) AS revenue_rank
FROM order_items oi
INNER JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name, p.category
ORDER BY revenue_rank
LIMIT 10;


-- ============================================
-- 3. REGIONAL SALES COMPARISON
-- Business Question: Which regions perform best?
-- Where should we focus expansion efforts?
-- ============================================

SELECT
    o.region,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    SUM(o.total_amount) AS total_revenue,
    ROUND(AVG(o.total_amount), 2) AS avg_order_value,
    ROUND(
          SUM(o.total_amount) * 100.0 
        / SUM(SUM(o.total_amount)) OVER (), 2
      ) AS market_share_pct
FROM orders o
GROUP BY o.region
ORDER BY total_revenue DESC;


-- ============================================
-- 4. CUSTOMER PURCHASE FREQUENCY
-- Business Question: How often do customers 
-- buy? What does our repeat rate look like?
-- ============================================

WITH customer_orders AS (
      SELECT
          customer_id,
          COUNT(order_id) AS order_count,
          SUM(total_amount) AS lifetime_value,
          MIN(order_date) AS first_order,
          MAX(order_date) AS last_order
      FROM orders
      GROUP BY customer_id
  )
SELECT
    CASE
        WHEN order_count = 1 THEN '1 order'
        WHEN order_count BETWEEN 2 AND 3 THEN '2-3 orders'
        WHEN order_count BETWEEN 4 AND 6 THEN '4-6 orders'
        ELSE '7+ orders'
    END AS frequency_bucket,
    COUNT(*) AS customer_count,
    ROUND(AVG(lifetime_value), 2) AS avg_lifetime_value,
    ROUND(
          COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2
      ) AS pct_of_customers
FROM customer_orders
GROUP BY
    CASE
        WHEN order_count = 1 THEN '1 order'
        WHEN order_count BETWEEN 2 AND 3 THEN '2-3 orders'
        WHEN order_count BETWEEN 4 AND 6 THEN '4-6 orders'
        ELSE '7+ orders'
    END
ORDER BY MIN(order_count);


-- ============================================
-- 5. QUARTERLY RUNNING TOTAL
-- Business Question: What is our cumulative 
-- revenue progression throughout the year?
-- ============================================

SELECT
    DATE_TRUNC('quarter', order_date) AS quarter,
    SUM(total_amount) AS quarterly_revenue,
    SUM(SUM(total_amount)) OVER (
        ORDER BY DATE_TRUNC('quarter', order_date)
          ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
      ) AS running_total
FROM orders
GROUP BY DATE_TRUNC('quarter', order_date)
ORDER BY quarter;


-- ============================================
-- 6. PRODUCT CATEGORY PERFORMANCE
-- Business Question: Which categories are 
-- growing fastest? Where should we invest?
-- ============================================

SELECT
    p.category,
    DATE_TRUNC('quarter', o.order_date) AS quarter,
    SUM(oi.quantity * oi.unit_price) AS category_revenue,
    LAG(SUM(oi.quantity * oi.unit_price)) OVER (
          PARTITION BY p.category 
          ORDER BY DATE_TRUNC('quarter', o.order_date)
      ) AS prev_quarter_revenue,
    ROUND(
          (SUM(oi.quantity * oi.unit_price) - LAG(SUM(oi.quantity * oi.unit_price)) OVER (
              PARTITION BY p.category 
              ORDER BY DATE_TRUNC('quarter', o.order_date)
          )) / NULLIF(LAG(SUM(oi.quantity * oi.unit_price)) OVER (
              PARTITION BY p.category 
              ORDER BY DATE_TRUNC('quarter', o.order_date)
          ), 0) * 100, 2
      ) AS qoq_growth_pct
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category, DATE_TRUNC('quarter', o.order_date)
ORDER BY p.category, quarter;
