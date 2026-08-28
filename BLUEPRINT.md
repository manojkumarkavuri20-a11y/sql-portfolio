# Blueprint

How this repository is put together, and the reasoning behind each piece, from an empty folder to the finished portfolio.

## Why this repo exists

I wanted a single place that shows how I actually think through a business question in SQL, not just a list of syntax I know. Most of the "SQL portfolio" repos I looked at before building mine were either a pile of disconnected queries with no context, or a giant polished dashboard with none of the underlying logic visible. I went for the middle ground: a handful of realistic business projects, each with a question, a schema, working queries, and a plain-English writeup of what the numbers actually mean.

## Repository layout

```
sql-portfolio/
README.md              overview + navigation for recruiters
BLUEPRINT.md            this file
projects/
sales-analysis/        revenue trends, product mix, regional performance
customer-segmentation/ RFM scoring + cohort retention
funnel-analysis/       conversion funnel + A/B test read
practice/
hackerrank/             solved problems, Advanced certificate
leetcode/               solved problems by difficulty
notes/
window-functions.md    my own reference notes on window functions
```

Each project folder follows the same shape: a `README.md` that states the business question and findings first, a `queries.sql` with the actual SQL, and (where relevant) `data/` for the sample CSV and `results/` for what the queries produce. Keeping every project on the same shape means someone can jump into any folder and immediately know where to look.

## Build process, start to finish

1. **Pick a business question first, data second.** For each project I started by writing the question a stakeholder would actually ask ("are we growing month over month," "who are our best customers," "where do people drop off before buying") rather than starting from a dataset and seeing what I could compute. That ordering is what keeps the queries from feeling like exercises.
2. **Sketch the schema on paper.** A minimal set of tables that could plausibly back an e-commerce or subscription business: `orders`, `order_items`, `products`, `transactions`, `events`, `ab_tests`. Nothing over-normalized, nothing that needs a diagram to explain.
3. **Generate small, believable synthetic data.** Every project uses a synthetic dataset sized so the sample output is readable in a table (tens of rows, not thousands) but the query logic is what would hold up at real scale.
4. **Write the query, then check it against the question.** Every query in this repo maps back to one line of the business question above it. If I couldn't explain in one sentence why a query existed, I cut it.
5. **Write the findings in plain English.** Each project README ends with a "key findings" section that reads like something I'd actually say out loud to a manager, not a restatement of the SQL.
6. **Cross-link everything from the root README.** A recruiter should never have to guess which folder answers which question - the root README's "quick start" table exists specifically to route them.

## Project-by-project logic

### Sales analysis
Business question: how is revenue trending, which products carry the business, and which regions are worth investing in. Approach: build a monthly revenue CTE with `LAG()` for month-over-month growth, rank products by revenue share with `RANK()` and a window `SUM() OVER ()` for share-of-total, compare regions the same way, then bucket customers by order count to see how much of the revenue depends on repeat buyers versus one-time purchases. The running quarterly total and the category quarter-over-quarter query round it out into something that reads like an actual quarterly business review.

### Customer segmentation (RFM)
Business question: which customers matter most, and who's slipping away. Approach: compute recency, frequency and monetary value per customer, split each into quintiles with `NTILE(5)`, then combine the three scores into named segments (Champions, Loyal, At Risk, Lost, etc.) with a `CASE` expression. The cohort retention query is a separate angle on the same data - it groups customers by the month they first transacted and tracks what fraction of each cohort is still active in later months, which is the metric that actually tells you if the business is leaking customers.

### Funnel analysis
Business question: where in the page-view-to-purchase journey are people dropping off, and does a checkout redesign help. Approach: count distinct users at each funnel stage, compute stage-to-stage and overall conversion with `NULLIF`-guarded division, then slice the same funnel by traffic source and device to find where the drop-off concentrates. The A/B test query isolates users in the checkout test and compares control versus treatment conversion directly, and the last query surfaces users who reached checkout but never purchased - the actual re-engagement list a marketing team would use.

## Practice and notes

The `practice/` folder is separate from `projects/` on purpose - it's raw problem-solving (HackerRank SQL track through the Advanced certificate, LeetCode database problems by difficulty), not business-framed work. It's there to show range on syntax and edge cases that a single business project wouldn't naturally exercise: recursive CTEs, string functions, harder join conditions. `notes/window-functions.md` is my own working reference on window functions, kept because it's the one SQL topic I had to deliberately sit down and internalize rather than pick up by osmosis, and it's useful to show the "how I learned it" alongside the "how I use it" in the projects.

## How to review this repo

Start at the root `README.md` for the recruiter-facing summary and the quick-start table, then open whichever project folder matches the question you care about most - each one is self-contained, so you don't need to read them in order. Read a project's `README.md` before its `queries.sql`; the README states the business question and the findings, and the SQL only really makes sense once you know what it's trying to answer. `practice/` is worth a skim if you want to see raw problem-solving separate from the business framing, and `notes/window-functions.md` if you want to see how I think about the trickier window-function cases.

## What I'd add next

A few things I'd want in a v2: an `EXPLAIN ANALYZE` pass on the heavier queries with notes on indexing, a small dbt-style layer so the CTEs in each project are reusable views instead of repeated subqueries, and a fourth project on inventory or demand forecasting to round out the retail angle. None of these were needed to answer the business questions I set out to answer, which is why they're not in v1.

---
This file exists so anyone reviewing the repo - recruiter, hiring manager, or future me - can see the reasoning behind the structure, not just the structure itself.
