# Sales Analysis Project

## Business Question

**What are the revenue trends, top-performing products, and regional sales patterns across our retail business?**

This project simulates a real-world business scenario where a Business Analyst needs to provide data-driven insights to leadership on sales performance, product rankings, and geographic trends.

---

## Dataset

- **Source:** Synthetic retail sales dataset (inspired by Kaggle/Maven Analytics datasets)
- **Size:** 1,000 orders across 4 regions, 20 products, 200 customers
- **Schema:**

| Table | Columns | Description |
|-------|---------|-------------|
| `orders` | order_id, customer_id, order_date, region, total_amount | Core transaction table |
| `order_items` | item_id, order_id, product_id, quantity, unit_price | Line items per order |
| `products` | product_id, product_name, category, cost_price | Product catalog |
| `customers` | customer_id, customer_name, signup_date, region | Customer master data |

---

## Approach

### Techniques Used
- **JOINs** (INNER, LEFT) to connect orders with products and customers
- **GROUP BY** with aggregate functions for revenue summaries
- **Window Functions** (RANK, SUM OVER, LAG) for rankings and running totals
- **Date manipulation** for monthly/quarterly trend analysis
- **CASE WHEN** for conditional categorization

### Analysis Breakdown
1. Monthly revenue trends with month-over-month growth
2. Top 10 products by revenue using RANK()
3. Regional sales comparison and market share
4. Customer purchase frequency distribution
5. Running total of revenue by quarter

---

## Key Findings

- **Revenue grew 23% from Q1 to Q4**, with the strongest month being November driven by seasonal demand
- **Top 3 products account for 35% of total revenue**, suggesting high product concentration risk
- **West region outperforms others by 18%**, indicating potential for targeted expansion in underperforming regions
- **Repeat customers generate 2.4x more revenue** than one-time buyers, highlighting the importance of retention

---

## SQL Highlights

### Monthly Revenue with MoM Growth
```sql
WITH monthly_revenue AS (
      SELECT
          DATE_TRUNC('month', order_date) AS month,
          SUM(total_amount) AS revenue
      FROM orders
      GROUP BY DATE_TRUNC('month', order_date)
  )
SELECT
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS prev_month_revenue,
    ROUND(
              (revenue - LAG(revenue) OVER (ORDER BY month))
              / LAG(revenue) OVER (ORDER BY month) * 100, 2
          ) AS mom_growth_pct
FROM monthly_revenue
ORDER BY month;
```

### Top Products by Revenue with Rank
```sql
SELECT
    p.product_name,
    p.category,
    SUM(oi.quantity * oi.unit_price) AS total_revenue,
    RANK() OVER (ORDER BY SUM(oi.quantity * oi.unit_price) DESC) AS revenue_rank
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name, p.category
ORDER BY revenue_rank
LIMIT 10;
```

---

## Files

| File | Description |
|------|-------------|
| `queries.sql` | All SQL queries used in this analysis |
| `data/sales_data.csv` | Sample dataset |
| `results/monthly_revenue.csv` | Monthly revenue output |

---

## How to Run

1. Load `data/sales_data.csv` into your PostgreSQL database
2. Execute queries from `queries.sql` sequentially
3. Results can also be tested on [DB Fiddle](https://www.db-fiddle.com/)
