-- ============================================================
-- Funnel Analysis for E-commerce Platform
-- Project: sql-portfolio / projects / funnel_analysis
-- Author: Manoj Kumar Kavuri
-- Description: Conversion funnel from page view to purchase,
--   with segment analysis and A/B test evaluation.
-- ============================================================

-- -------------------------------------------------------
-- TABLE ASSUMPTIONS
-- -------------------------------------------------------
-- events(event_id, user_id, session_id, event_type, device_type,
--        traffic_source, created_at)
-- event_type values: 'page_view', 'add_to_cart', 'checkout', 'purchase'
-- orders(order_id, user_id, session_id, amount, created_at)
-- ab_tests(user_id, variant)  -- variant: 'control' | 'treatment'


-- -------------------------------------------------------
-- 1. OVERALL CONVERSION FUNNEL
-- -------------------------------------------------------
WITH funnel_counts AS (
  SELECT
    COUNT(DISTINCT CASE WHEN event_type = 'page_view'   THEN user_id END) AS page_views,
    COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN user_id END) AS add_to_cart,
    COUNT(DISTINCT CASE WHEN event_type = 'checkout'    THEN user_id END) AS checkout,
    COUNT(DISTINCT CASE WHEN event_type = 'purchase'    THEN user_id END) AS purchase
  FROM events
)
SELECT
  'page_view'   AS funnel_stage, page_views   AS users, 100.0                                    AS stage_rate,
  ROUND(100.0 * add_to_cart / NULLIF(page_views, 0), 2)                                          AS overall_cr
FROM funnel_counts
UNION ALL
SELECT 'add_to_cart', add_to_cart,
  ROUND(100.0 * add_to_cart / NULLIF(page_views, 0), 2),
  ROUND(100.0 * add_to_cart / NULLIF(page_views, 0), 2) FROM funnel_counts
UNION ALL
SELECT 'checkout', checkout,
  ROUND(100.0 * checkout / NULLIF(add_to_cart, 0), 2),
  ROUND(100.0 * checkout / NULLIF(page_views, 0), 2) FROM funnel_counts
UNION ALL
SELECT 'purchase', purchase,
  ROUND(100.0 * purchase / NULLIF(checkout, 0), 2),
  ROUND(100.0 * purchase / NULLIF(page_views, 0), 2) FROM funnel_counts;


-- -------------------------------------------------------
-- 2. DROP-OFF ANALYSIS BY STAGE
-- -------------------------------------------------------
WITH stage_users AS (
  SELECT
    event_type AS stage,
    COUNT(DISTINCT user_id) AS unique_users,
    ROW_NUMBER() OVER (ORDER BY
      CASE event_type
        WHEN 'page_view'   THEN 1
        WHEN 'add_to_cart' THEN 2
        WHEN 'checkout'    THEN 3
        WHEN 'purchase'    THEN 4
      END) AS stage_order
  FROM events
  WHERE event_type IN ('page_view','add_to_cart','checkout','purchase')
  GROUP BY event_type
)
SELECT
  curr.stage,
  curr.unique_users,
  LAG(curr.unique_users) OVER (ORDER BY curr.stage_order) AS prev_stage_users,
  curr.unique_users - LAG(curr.unique_users) OVER (ORDER BY curr.stage_order) AS drop_off,
  ROUND(
    100.0 * (LAG(curr.unique_users) OVER (ORDER BY curr.stage_order) - curr.unique_users)
    / NULLIF(LAG(curr.unique_users) OVER (ORDER BY curr.stage_order), 0), 2
  ) AS drop_off_pct
FROM stage_users curr
ORDER BY curr.stage_order;


-- -------------------------------------------------------
-- 3. FUNNEL BY TRAFFIC SOURCE
-- -------------------------------------------------------
SELECT
  traffic_source,
  COUNT(DISTINCT CASE WHEN event_type = 'page_view'   THEN user_id END) AS page_views,
  COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN user_id END) AS add_to_cart,
  COUNT(DISTINCT CASE WHEN event_type = 'checkout'    THEN user_id END) AS checkout,
  COUNT(DISTINCT CASE WHEN event_type = 'purchase'    THEN user_id END) AS purchases,
  ROUND(
    100.0 * COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END)
    / NULLIF(COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END), 0), 2
  ) AS end_to_end_cr_pct
FROM events
GROUP BY traffic_source
ORDER BY end_to_end_cr_pct DESC;


-- -------------------------------------------------------
-- 4. FUNNEL BY DEVICE TYPE
-- -------------------------------------------------------
SELECT
  device_type,
  COUNT(DISTINCT CASE WHEN event_type = 'page_view'   THEN user_id END) AS page_views,
  COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN user_id END) AS add_to_cart,
  COUNT(DISTINCT CASE WHEN event_type = 'checkout'    THEN user_id END) AS checkout,
  COUNT(DISTINCT CASE WHEN event_type = 'purchase'    THEN user_id END) AS purchases,
  ROUND(
    100.0 * COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END)
    / NULLIF(COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END), 0), 2
  ) AS end_to_end_cr_pct
FROM events
GROUP BY device_type
ORDER BY end_to_end_cr_pct DESC;


-- -------------------------------------------------------
-- 5. TIME-BASED CONVERSION TRENDS (WEEKLY)
-- -------------------------------------------------------
SELECT
  DATE_TRUNC('week', created_at)::DATE AS week_start,
  COUNT(DISTINCT CASE WHEN event_type = 'page_view'   THEN user_id END) AS page_views,
  COUNT(DISTINCT CASE WHEN event_type = 'purchase'    THEN user_id END) AS purchases,
  ROUND(
    100.0 * COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END)
    / NULLIF(COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END), 0), 2
  ) AS weekly_cr_pct
FROM events
GROUP BY DATE_TRUNC('week', created_at)
ORDER BY week_start;


-- -------------------------------------------------------
-- 6. A/B TEST ANALYSIS: CHECKOUT PAGE VARIANTS
--    Hypothesis: treatment checkout page improves purchase CR
-- -------------------------------------------------------
WITH ab_funnel AS (
  SELECT
    ab.variant,
    COUNT(DISTINCT CASE WHEN e.event_type = 'checkout' THEN e.user_id END) AS checkout_users,
    COUNT(DISTINCT CASE WHEN e.event_type = 'purchase' THEN e.user_id END) AS purchase_users
  FROM events e
  JOIN ab_tests ab ON e.user_id = ab.user_id
  GROUP BY ab.variant
)
SELECT
  variant,
  checkout_users,
  purchase_users,
  ROUND(100.0 * purchase_users / NULLIF(checkout_users, 0), 2) AS checkout_to_purchase_cr_pct,
  ROUND(
    100.0 * purchase_users / NULLIF(checkout_users, 0)
    - LAG(100.0 * purchase_users / NULLIF(checkout_users, 0)) OVER (ORDER BY variant), 2
  ) AS uplift_vs_previous_pct
FROM ab_funnel
ORDER BY variant;


-- -------------------------------------------------------
-- 7. TOP DROPPED-OFF USERS: RE-ENGAGEMENT CANDIDATES
--    Users who reached checkout but never purchased
-- -------------------------------------------------------
SELECT
  e.user_id,
  MAX(e.created_at) AS last_seen,
  COUNT(DISTINCT e.session_id) AS sessions,
  SUM(CASE WHEN e.event_type = 'checkout' THEN 1 ELSE 0 END) AS checkout_count,
  MAX(ab.variant) AS ab_variant
FROM events e
LEFT JOIN ab_tests ab ON e.user_id = ab.user_id
WHERE e.user_id NOT IN (
  SELECT DISTINCT user_id FROM events WHERE event_type = 'purchase'
)
AND e.event_type = 'checkout'
GROUP BY e.user_id
ORDER BY checkout_count DESC, last_seen DESC
LIMIT 100;
