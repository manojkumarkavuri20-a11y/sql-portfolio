-- ============================================
-- CUSTOMER SEGMENTATION - SQL Queries
-- Author: Manoj Kumar Kavuri
-- Database: PostgreSQL
-- ============================================

-- 1. RFM SEGMENTATION
WITH rfm_base AS (
      SELECT
          customer_id,
          CURRENT_DATE - MAX(txn_date) AS recency_days,
          COUNT(txn_id) AS frequency,
          SUM(amount) AS monetary
      FROM transactions
      GROUP BY customer_id
  ),
rfm_scores AS (
      SELECT *,
          NTILE(5) OVER (ORDER BY recency_days DESC) AS r_score,
          NTILE(5) OVER (ORDER BY frequency ASC) AS f_score,
          NTILE(5) OVER (ORDER BY monetary ASC) AS m_score
      FROM rfm_base
  )
SELECT *,
    CASE
        WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champions'
        WHEN r_score >= 3 AND f_score >= 3 THEN 'Loyal Customers'
        WHEN r_score >= 4 AND f_score <= 2 THEN 'New Customers'
        WHEN r_score <= 2 AND f_score >= 3 AND m_score >= 3 THEN 'At Risk'
        WHEN r_score <= 2 AND f_score <= 2 THEN 'Lost'
        ELSE 'Needs Attention'
    END AS segment
FROM rfm_scores
ORDER BY monetary DESC;


-- 2. SEGMENT SUMMARY
WITH rfm_base AS (
      SELECT customer_id,
          CURRENT_DATE - MAX(txn_date) AS recency_days,
          COUNT(txn_id) AS frequency,
          SUM(amount) AS monetary
      FROM transactions GROUP BY customer_id
  ),
rfm_scores AS (
      SELECT *,
          NTILE(5) OVER (ORDER BY recency_days DESC) AS r_score,
          NTILE(5) OVER (ORDER BY frequency ASC) AS f_score,
          NTILE(5) OVER (ORDER BY monetary ASC) AS m_score
      FROM rfm_base
  ),
segments AS (
      SELECT *,
          CASE
              WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champions'
              WHEN r_score >= 3 AND f_score >= 3 THEN 'Loyal Customers'
              WHEN r_score <= 2 AND f_score >= 3 AND m_score >= 3 THEN 'At Risk'
              WHEN r_score <= 2 AND f_score <= 2 THEN 'Lost'
              ELSE 'Needs Attention'
          END AS segment
      FROM rfm_scores
  )
SELECT segment,
    COUNT(*) AS customer_count,
    ROUND(AVG(monetary), 2) AS avg_monetary,
    ROUND(SUM(monetary), 2) AS total_revenue
FROM segments
GROUP BY segment
ORDER BY total_revenue DESC;


-- 3. COHORT RETENTION ANALYSIS
WITH customer_cohort AS (
      SELECT customer_id,
          DATE_TRUNC('month', MIN(txn_date)) AS cohort_month
      FROM transactions
      GROUP BY customer_id
  ),
monthly_activity AS (
      SELECT t.customer_id, cc.cohort_month,
          DATE_TRUNC('month', t.txn_date) AS activity_month,
          EXTRACT(YEAR FROM AGE(DATE_TRUNC('month', t.txn_date), cc.cohort_month)) * 12
          + EXTRACT(MONTH FROM AGE(DATE_TRUNC('month', t.txn_date), cc.cohort_month)) AS month_number
      FROM transactions t
      JOIN customer_cohort cc ON t.customer_id = cc.customer_id
  )
SELECT cohort_month, month_number,
    COUNT(DISTINCT customer_id) AS active_customers,
    ROUND(COUNT(DISTINCT customer_id) * 100.0
          / FIRST_VALUE(COUNT(DISTINCT customer_id)) OVER (
              PARTITION BY cohort_month ORDER BY month_number
          ), 2) AS retention_pct
FROM monthly_activity
GROUP BY cohort_month, month_number
ORDER BY cohort_month, month_number;
