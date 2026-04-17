# Funnel Analysis for E-commerce Platform

## Business Problem

E-commerce platforms lose the majority of potential buyers between the first page view and purchase. This project answers:
- **Where exactly are users dropping off** in the conversion funnel?
- **Which traffic sources and devices** convert best?
- **Does the treatment checkout page** outperform the control in the A/B test?
- **Which users are re-engagement candidates** (reached checkout but never bought)?

---

## Dataset

| File | Description |
|---|---|
| `sample_events.csv` | 50 synthetic e-commerce events across 17 users |
| `funnel_analysis.sql` | 7 production-ready SQL queries |

**Schema:**
```
events(event_id, user_id, session_id, event_type, device_type, traffic_source, created_at)
orders(order_id, user_id, session_id, amount, created_at)
ab_tests(user_id, variant)  -- 'control' | 'treatment'
```

**Event types (funnel order):** `page_view` → `add_to_cart` → `checkout` → `purchase`

---

## SQL Queries Included

| # | Query | Purpose |
|---|---|---|
| 1 | Overall Conversion Funnel | Stage-by-stage drop-off rates |
| 2 | Drop-off Analysis | Absolute and % drop-off per stage |
| 3 | Funnel by Traffic Source | End-to-end CR per channel (organic, paid, email, social) |
| 4 | Funnel by Device Type | Desktop vs mobile vs tablet conversion |
| 5 | Weekly Conversion Trends | CR trends over time |
| 6 | A/B Test Analysis | Control vs treatment checkout page CR |
| 7 | Re-engagement Candidates | Users who hit checkout but never purchased |

---

## Key Findings (from sample data)

- **Biggest drop-off** occurs between add-to-cart and checkout (~35% of cart users abandon before checkout)
- **Email traffic** drives the highest end-to-end conversion rate vs social and organic
- **Desktop users** convert at a higher rate than mobile, suggesting UX friction on mobile checkout
- **A/B test:** Treatment checkout variant shows measurable uplift in checkout-to-purchase rate
- **Re-engagement list:** Users who reached checkout multiple times are high-value targets for cart abandonment campaigns

---

## SQL Concepts Demonstrated

- `CTEs` for multi-step funnel calculations
- `Window Functions` — `LAG()`, `ROW_NUMBER()` for drop-off tracking
- `CASE WHEN` for conditional aggregation across event types
- `COUNT(DISTINCT ...)` for accurate unique-user funnel counting
- `DATE_TRUNC` for time-series trend analysis
- `LEFT JOIN` + `NOT IN` subquery for exclusion logic
- `NULLIF` for safe division / zero-division protection

---

## How to Run

```sql
-- 1. Create and load the events table
CREATE TABLE events (
  event_id SERIAL PRIMARY KEY,
  user_id VARCHAR(10),
  session_id VARCHAR(10),
  event_type VARCHAR(20),
  device_type VARCHAR(20),
  traffic_source VARCHAR(30),
  created_at TIMESTAMP
);

-- 2. Load sample data from sample_events.csv
\COPY events FROM 'sample_events.csv' CSV HEADER;

-- 3. Run any query from funnel_analysis.sql
```

---

*Part of the [SQL Portfolio](https://github.com/manojkumarkavuri20-a11y/sql-portfolio) by Manoj Kumar Kavuri*
