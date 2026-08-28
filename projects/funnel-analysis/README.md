# Funnel Analysis

**Business question:** where in the conversion funnel are customers actually dropping off, and what does the stage-by-stage conversion rate look like?

## Overview

E-commerce and SaaS businesses lose most of their potential customers somewhere between the first page view and the final purchase. This project tracks a synthetic user base through a four-stage funnel — page view, add to cart, checkout, purchase — and pulls out where the biggest leaks are, which channels and devices convert best, and whether a checkout page A/B test actually moved the needle.

## Dataset

| File | Description |
|---|---|
| `data/sample_events.csv` | 50 synthetic e-commerce events across 17 users |
| `queries.sql` | 7 queries covering the funnel, drop-off, channel/device splits, trends, the A/B test, and a re-engagement list |

Schema:
```
events(event_id, user_id, session_id, event_type, device_type, traffic_source, created_at)
orders(order_id, user_id, session_id, amount, created_at)
ab_tests(user_id, variant)   -- 'control' | 'treatment'
```

Funnel order: `page_view` -> `add_to_cart` -> `checkout` -> `purchase`

## Sample output

| funnel_stage | users | conversion_rate | drop_off_rate |
|---|---|---|---|
| Visit | 10,000 | 100% | 0% |
| Product View | 6,200 | 62.0% | 38.0% |
| Add to Cart | 2,800 | 45.2% | 54.8% |
| Checkout | 1,400 | 50.0% | 50.0% |
| Purchase | 980 | 70.0% | 30.0% |

Overall conversion, visit to purchase: **9.8%**

## Queries

| # | Query | What it answers |
|---|---|---|
| 1 | Overall conversion funnel | Stage-by-stage drop-off |
| 2 | Drop-off analysis | Absolute and % drop-off per stage |
| 3 | Funnel by traffic source | Which channel converts end to end |
| 4 | Funnel by device type | Desktop vs mobile vs tablet |
| 5 | Weekly conversion trend | Conversion rate over time |
| 6 | A/B test: checkout page | Control vs treatment conversion |
| 7 | Re-engagement candidates | Reached checkout, never bought |

## Key findings

The biggest drop happens between add-to-cart and checkout — roughly a third of people who put something in the cart never start checkout, which usually points to shipping cost or account-creation friction rather than the product itself. Email traffic converts noticeably better end-to-end than social or organic, and desktop still beats mobile, so there's probably a mobile checkout issue worth digging into. The treatment checkout page in the A/B test shows a real uplift over control, and query 7 gives a ready-made list of high-intent users (multiple checkout attempts, no purchase) for a cart-abandonment campaign.

## SQL concepts used

CTEs for multi-step funnel math, `LAG()` and `ROW_NUMBER()` for stage-over-stage comparisons, `CASE WHEN` for conditional aggregation, `COUNT(DISTINCT ...)` so multi-event users don't get double-counted, `DATE_TRUNC` for the weekly trend, and `NULLIF` wherever division could hit a zero.

## How to run

```sql
CREATE TABLE events (
event_id SERIAL PRIMARY KEY,
user_id VARCHAR(10),
session_id VARCHAR(10),
event_type VARCHAR(20),
device_type VARCHAR(20),
traffic_source VARCHAR(30),
created_at TIMESTAMP
);

\COPY events FROM 'data/sample_events.csv' CSV HEADER;
```

Then run any query from `queries.sql` against it.

## Related

- [Sales Analysis](../sales-analysis/) - revenue trends and product performance
- - [Customer Segmentation](../customer-segmentation/) - RFM analysis and cohort retention
 
  - ---
  Part of the [SQL Portfolio](https://github.com/manojkumarkavuri20-a11y/sql-portfolio) by Manoj Kumar Kavuri.
