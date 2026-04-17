# SQL Portfolio

[![SQL](https://img.shields.io/badge/SQL-Advanced-blue?style=flat-square)](https://www.hackerrank.com/manojkumarkavuri20) [![HackerRank](https://img.shields.io/badge/HackerRank-SQL%20Advanced%20Certified-brightgreen?style=flat-square)](https://www.hackerrank.com/manojkumarkavuri20) [![PostgreSQL](https://img.shields.io/badge/PostgreSQL-14%2B-336791?style=flat-square)](https://www.postgresql.org/)

A curated collection of SQL projects, practice problems, and notes demonstrating analytical skills for Business Analyst and Data Analyst roles.

---

## 👀 Quick Start for Recruiters

| If you want to see... | Go here |
|---|---|
| End-to-end business analysis SQL | [`projects/sales-analysis/`](projects/sales-analysis/) |
| RFM customer segmentation | [`projects/customer-segmentation/`](projects/customer-segmentation/) |
| Funnel & conversion analysis | [`projects/funnel-analysis/`](projects/funnel-analysis/) |
| HackerRank Advanced SQL solutions | [`practice/hackerrank/`](practice/hackerrank/) |
| Window functions deep dive | [`notes/window-functions.md`](notes/window-functions.md) |

---

## Repository Structure

```
sql-portfolio/
|
├── README.md                    ← You are here
├── projects/
|   ├── sales-analysis/
|   |   ├── README.md            ← Problem, approach, findings
|   |   ├── data/                ← Sample data (CSV)
|   |   ├── queries.sql          ← All SQL queries
|   |   └── results/             ← Output CSVs
|   ├── customer-segmentation/
|   |   ├── README.md
|   |   ├── data/
|   |   ├── queries.sql
|   |   └── results/
|   └── funnel-analysis/
|       ├── README.md
|       ├── data/
|       └── queries.sql
├── practice/
|   ├── hackerrank/
|   |   └── README.md            ← HackerRank SQL solutions
|   └── leetcode/
|       └── README.md            ← LeetCode SQL solutions
└── notes/
    └── window-functions.md      ← SQL concept deep-dives
```

---

## Projects

### 1. Sales Analysis

**Business Question:** What are the revenue trends, top-performing products, and regional sales patterns?

**Skills demonstrated:** JOINs, GROUP BY, Window Functions (RANK, SUM OVER), Date Manipulation

**Sample output:**

| product_category | total_revenue | revenue_rank | mom_growth |
|---|---|---|---|
| Electronics | £142,500 | 1 | +8.3% |
| Clothing | £98,200 | 2 | -2.1% |
| Home & Garden | £76,800 | 3 | +12.4% |

➡️ [View Project](projects/sales-analysis/)

---

### 2. Customer Segmentation (RFM)

**Business Question:** How can we segment customers using RFM analysis and track cohort retention?

**Skills demonstrated:** CTEs, CASE WHEN, Date Functions, Window Functions (ROW_NUMBER, LAG)

**Sample output:**

| customer_segment | customer_count | avg_order_value | retention_rate |
|---|---|---|---|
| Champions | 342 | £287 | 89% |
| Loyal Customers | 891 | £154 | 74% |
| At Risk | 456 | £89 | 31% |
| Lost | 213 | £42 | 8% |

➡️ [View Project](projects/customer-segmentation/)

---

### 3. Funnel Analysis

**Business Question:** Where in the conversion funnel are customers dropping off, and what is the stage-by-stage conversion rate?

**Skills demonstrated:** CTEs, Window Functions, CASE WHEN, conversion rate calculations

➡️ [View Project](projects/funnel-analysis/)

---

## Practice Problems

| Platform | Difficulty | Focus Area | Certified |
|---|---|---|---|
| HackerRank | Advanced | Aggregations, Window Functions, CTEs | ✅ SQL Advanced Certificate |
| LeetCode | Medium/Hard | JOINs, Subqueries, Edge Cases | ✅ |

---

## SQL Skills Covered

| Skill | Demonstrated In |
|---|---|
| JOINs (INNER, LEFT, FULL OUTER) | Sales Analysis, Practice Problems |
| CTEs and Subqueries | Customer Segmentation, Funnel Analysis |
| Window Functions (ROW_NUMBER, RANK, LAG/LEAD, SUM OVER) | All Projects |
| Aggregations and GROUP BY | All Projects |
| CASE WHEN Logic | Customer Segmentation, RFM Scoring |
| Date/Time Manipulation | Sales Analysis, Cohort Analysis |
| RFM Scoring | Customer Segmentation |
| Conversion Funnel Analysis | Funnel Analysis |

---

## Tools

- **PostgreSQL** — Primary database engine
- **DB Fiddle** — Live runnable query links
- **GitHub** — Version control and portfolio hosting

---

## About

**Manoj Kumar Kavuri** — Graduate Business & Operations Analyst  
MSc International Business (Distinction) | HackerRank SQL Advanced Certified

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0A66C2?style=flat-square&logo=linkedin)](https://www.linkedin.com/in/manojkumarkavuri/) [![GitHub](https://img.shields.io/badge/GitHub-Profile-181717?style=flat-square&logo=github)](https://github.com/manojkumarkavuri20-a11y)

> Open to Business Analyst, Operations Analyst, and Data Analyst roles across the UK.
