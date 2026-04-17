# Funnel Analysis

**Business Question:** Where in the conversion funnel are customers dropping off, and what is the stage-by-stage conversion rate?

## Overview

This project uses SQL to track users through a multi-stage conversion funnel — from first visit through to completed purchase — and identifies the biggest drop-off points. Built to answer the kind of question that comes up in every e-commerce and SaaS business.

## Sample Output

| funnel_stage | users_entered | users_completed | conversion_rate | drop_off_rate |
|---|---|---|---|---|
| Visit | 10,000 | 10,000 | 100% | 0% |
| Product View | 6,200 | 6,200 | 62.0% | 38.0% |
| Add to Cart | 2,800 | 2,800 | 45.2% | 54.8% |
| Checkout Start | 1,400 | 1,400 | 50.0% | 50.0% |
| Purchase | 980 | 980 | 70.0% | 30.0% |

**Overall conversion: 9.8% (Visit to Purchase)**

## SQL Skills Demonstrated

- CTEs for stage-by-stage tracking
- Window functions for cohort ordering
- CASE WHEN for funnel stage classification
- Conversion rate and drop-off rate calculations
- Cohort analysis by acquisition channel

## Files

- `queries.sql` — Main funnel analysis queries
- `data/` — Sample event data (CSV)

## Key Finding

The biggest drop-off is between Visit and Product View (38%) — suggesting the homepage or category pages aren't surfacing the right products. The Add-to-Cart to Checkout step is the second biggest gap (50%), typical of price sensitivity or trust issues at that point.

## Related

- [Sales Analysis](../sales-analysis/) — Revenue trends and product performance
- [Customer Segmentation](../customer-segmentation/) — RFM analysis and cohort retention
