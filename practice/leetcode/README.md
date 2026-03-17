# LeetCode SQL Solutions

A collection of my solutions to LeetCode SQL problems, organized by difficulty and topic.

---

## Progress Tracker

| # | Problem | Difficulty | Topics | Status |
|---|---------|-----------|--------|--------|
| 175 | Combine Two Tables | Easy | JOIN | Solved |
| 176 | Second Highest Salary | Medium | Subquery, LIMIT | Solved |
| 177 | Nth Highest Salary | Medium | Window Functions | Solved |
| 178 | Rank Scores | Medium | DENSE_RANK | Solved |
| 180 | Consecutive Numbers | Medium | Self JOIN, LAG | Solved |
| 181 | Employees Earning More Than Managers | Easy | Self JOIN | Solved |
| 182 | Duplicate Emails | Easy | GROUP BY, HAVING | Solved |
| 183 | Customers Who Never Order | Easy | LEFT JOIN, IS NULL | Solved |
| 184 | Department Highest Salary | Medium | Window Functions | Solved |
| 185 | Department Top Three Salaries | Hard | DENSE_RANK, CTE | Solved |
| 196 | Delete Duplicate Emails | Easy | Self JOIN, DELETE | Solved |
| 197 | Rising Temperature | Easy | LAG, Date Functions | Solved |
| 262 | Trips and Users | Hard | CASE WHEN, JOIN | Solved |
| 550 | Game Play Analysis IV | Medium | CTE, Date Functions | Solved |
| 1164 | Product Price at a Given Date | Medium | Window Functions | Solved |

---

## Example Solutions

### 176. Second Highest Salary
```sql
-- Using OFFSET/LIMIT
SELECT MAX(salary) AS SecondHighestSalary
FROM Employee
WHERE salary < (SELECT MAX(salary) FROM Employee);

-- Alternative: Using DENSE_RANK
SELECT salary AS SecondHighestSalary
FROM (
    SELECT salary, DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
        FROM Employee
        ) ranked
        WHERE rnk = 2;
        ```

        ### 178. Rank Scores
        ```sql
        SELECT score,
            DENSE_RANK() OVER (ORDER BY score DESC) AS "rank"
            FROM Scores
            ORDER BY score DESC;
            ```

            ### 185. Department Top Three Salaries
            ```sql
            WITH ranked_salaries AS (
                SELECT d.name AS Department, e.name AS Employee, e.salary,
                        DENSE_RANK() OVER (PARTITION BY e.departmentId ORDER BY e.salary DESC) AS rnk
                            FROM Employee e
                                JOIN Department d ON e.departmentId = d.id
                                )
                                SELECT Department, Employee, salary AS Salary
                                FROM ranked_salaries
                                WHERE rnk <= 3;
                                ```

                                ---

                                ## Topics Covered
                                - JOINs (INNER, LEFT, Self)
                                - Window Functions (RANK, DENSE_RANK, ROW_NUMBER, LAG/LEAD)
                                - CTEs and Subqueries
                                - Aggregation (GROUP BY, HAVING)
                                - CASE WHEN logic
                                - Date manipulation
