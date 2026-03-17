# Window Functions - Deep Dive Notes

## What Are Window Functions?

Window functions perform calculations across a set of rows related to the current row, without collapsing the result set like GROUP BY does. They "look through a window" of rows to compute values.

**Key difference from aggregates:** Window functions return a value for every row, while GROUP BY reduces rows.

---

## Syntax

```sql
function_name(expression) OVER (
    [PARTITION BY column_list]
        [ORDER BY column_list]
            [ROWS/RANGE frame_clause]
            )
            ```

            ---

            ## Categories of Window Functions

            ### 1. Ranking Functions

            | Function | Description | Handles Ties |
            |----------|-------------|-------------|
            | `ROW_NUMBER()` | Unique sequential number | No ties (arbitrary) |
            | `RANK()` | Rank with gaps for ties | 1, 2, 2, 4 |
            | `DENSE_RANK()` | Rank without gaps | 1, 2, 2, 3 |
            | `NTILE(n)` | Divides into n buckets | Equal distribution |

            ```sql
            -- Compare all ranking functions
            SELECT
                employee_name,
                    salary,
                        ROW_NUMBER() OVER (ORDER BY salary DESC) AS row_num,
                            RANK() OVER (ORDER BY salary DESC) AS rank_val,
                                DENSE_RANK() OVER (ORDER BY salary DESC) AS dense_rank_val,
                                    NTILE(4) OVER (ORDER BY salary DESC) AS quartile
                                    FROM employees;
                                    ```

                                    ### 2. Value Functions

                                    | Function | Description |
                                    |----------|-------------|
                                    | `LAG(col, n)` | Access value from n rows before |
                                    | `LEAD(col, n)` | Access value from n rows after |
                                    | `FIRST_VALUE(col)` | First value in the window |
                                    | `LAST_VALUE(col)` | Last value in the window |
                                    | `NTH_VALUE(col, n)` | Nth value in the window |

                                    ```sql
                                    -- Month-over-month comparison using LAG
                                    SELECT
                                        month,
                                            revenue,
                                                LAG(revenue, 1) OVER (ORDER BY month) AS prev_month,
                                                    revenue - LAG(revenue, 1) OVER (ORDER BY month) AS mom_change
                                                    FROM monthly_sales;
                                                    ```

                                                    ### 3. Aggregate Window Functions

                                                    Any aggregate (SUM, AVG, COUNT, MIN, MAX) can be used as a window function.

                                                    ```sql
                                                    -- Running total and moving average
                                                    SELECT
                                                        order_date,
                                                            amount,
                                                                SUM(amount) OVER (ORDER BY order_date) AS running_total,
                                                                    AVG(amount) OVER (
                                                                            ORDER BY order_date
                                                                                    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
                                                                                        ) AS moving_avg_3day
                                                                                        FROM orders;
                                                                                        ```

                                                                                        ---

                                                                                        ## Frame Clauses

                                                                                        Frame clauses define which rows are included in the window.

                                                                                        ```
                                                                                        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW  -- default for ORDER BY
                                                                                        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW          -- last 3 rows
                                                                                        ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING   -- current to end
                                                                                        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING           -- 3-row sliding window
                                                                                        ```

                                                                                        ---

                                                                                        ## Common Business Use Cases

                                                                                        ### 1. Running Totals
                                                                                        ```sql
                                                                                        SUM(revenue) OVER (ORDER BY date ROWS UNBOUNDED PRECEDING)
                                                                                        ```

                                                                                        ### 2. Percent of Total
                                                                                        ```sql
                                                                                        amount * 100.0 / SUM(amount) OVER ()
                                                                                        ```

                                                                                        ### 3. Year-over-Year Growth
                                                                                        ```sql
                                                                                        (revenue - LAG(revenue) OVER (ORDER BY year))
                                                                                        / LAG(revenue) OVER (ORDER BY year) * 100
                                                                                        ```

                                                                                        ### 4. Top N per Group
                                                                                        ```sql
                                                                                        -- Top 3 products per category by revenue
                                                                                        WITH ranked AS (
                                                                                            SELECT *, DENSE_RANK() OVER (
                                                                                                    PARTITION BY category ORDER BY revenue DESC
                                                                                                        ) AS rnk
                                                                                                            FROM products
                                                                                                            )
                                                                                                            SELECT * FROM ranked WHERE rnk <= 3;
                                                                                                            ```
                                                                                                            
                                                                                                            ### 5. Cumulative Distribution
                                                                                                            ```sql
                                                                                                            CUME_DIST() OVER (ORDER BY score)
                                                                                                            PERCENT_RANK() OVER (ORDER BY score)
                                                                                                            ```
                                                                                                            
                                                                                                            ---
                                                                                                            
                                                                                                            ## Performance Tips
                                                                                                            
                                                                                                            1. **Indexing:** Create indexes on PARTITION BY and ORDER BY columns
                                                                                                            2. **Avoid redundant sorts:** Combine window functions with the same OVER clause
                                                                                                            3. **Use named windows:** PostgreSQL supports WINDOW clause for reuse
                                                                                                            4. **Limit frame size:** Smaller frames = faster computation
                                                                                                            
                                                                                                            ```sql
                                                                                                            -- Named window example (PostgreSQL)
                                                                                                            SELECT
                                                                                                                ROW_NUMBER() OVER w,
                                                                                                                    SUM(amount) OVER w
                                                                                                                    FROM orders
                                                                                                                    WINDOW w AS (PARTITION BY customer_id ORDER BY order_date);
                                                                                                                    ```
                                                                                                                    
                                                                                                                    ---
                                                                                                                    
                                                                                                                    ## Interview Tips
                                                                                                                    
                                                                                                                    - Always clarify whether ties matter (RANK vs DENSE_RANK vs ROW_NUMBER)
                                                                                                                    - Window functions execute after WHERE, GROUP BY, and HAVING
                                                                                                                    - You cannot use window functions in WHERE clauses (use a CTE/subquery)
                                                                                                                    - PARTITION BY is optional; without it, the entire result set is one partition
