# Customer Segmentation Project

## Business Question
**How can we segment customers using RFM analysis and track cohort retention?**

This project addresses understanding customer behavior to drive targeted marketing and maximize lifetime value.

---

## Dataset
- **Source:** Synthetic e-commerce transaction data
- **Size:** 5,000 transactions, 500 customers, 12 months

| Table | Columns |
|-------|---------|
| `transactions` | txn_id, customer_id, txn_date, amount |
| `customers` | customer_id, name, signup_date, region |

---

## Approach

### Part 1: RFM Segmentation
- Scored Recency, Frequency, Monetary using CTEs and NTILE()
- Classified segments with CASE WHEN

### Part 2: Cohort Retention
- Grouped customers by signup month
- Tracked monthly retention with window functions

### Techniques Used
- CTEs, Window Functions (ROW_NUMBER, NTILE, LAG)
- CASE WHEN, Date Functions, LEFT JOIN

---

## Key Findings
- Champions (12% of customers) generate 45% of revenue
- At-risk customers make up 18% of the base
- Month-1 retention averages 42% with drop-off after month 3
- Q1 cohorts show 15% higher retention than Q3

---

## SQL Highlights

### RFM Scoring
```sql
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
                                                                )
                                                                SELECT *, CASE
                                                                    WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champions'
                                                                        WHEN r_score >= 3 AND f_score >= 3 THEN 'Loyal Customers'
                                                                            WHEN r_score <= 2 AND f_score >= 3 AND m_score >= 3 THEN 'At Risk'
                                                                                WHEN r_score <= 2 AND f_score <= 2 THEN 'Lost'
                                                                                    ELSE 'Needs Attention'
                                                                                    END AS segment FROM rfm_scores ORDER BY monetary DESC;
                                                                                    ```

                                                                                    ---

                                                                                    ## Files
                                                                                    | File | Description |
                                                                                    |------|-------------|
                                                                                    | `queries.sql` | RFM and cohort analysis queries |
                                                                                    | `data/customers.csv` | Sample data |
                                                                                    | `results/rfm_segments.csv` | Segmentation output |
