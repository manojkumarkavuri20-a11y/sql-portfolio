# HackerRank SQL Solutions

SQL challenge solutions from HackerRank, organized by subdomain.

---

## Progress

| Subdomain | Problem | Difficulty | Status |
|-----------|---------|-----------|--------|
| Basic Select | Revising the Select Query I | Easy | Solved |
| Basic Select | Revising the Select Query II | Easy | Solved |
| Basic Select | Select All | Easy | Solved |
| Basic Select | Select By ID | Easy | Solved |
| Basic Select | Weather Observation Station 1-12 | Easy-Medium | Solved |
| Advanced Select | Type of Triangle | Easy | Solved |
| Advanced Select | The PADS | Medium | Solved |
| Advanced Select | Binary Tree Nodes | Medium | Solved |
| Aggregation | Revising Aggregations | Easy | Solved |
| Aggregation | Top Earners | Easy | Solved |
| Aggregation | Weather Observation Station 13-20 | Easy | Solved |
| Basic Join | Population Census | Easy | Solved |
| Basic Join | African Cities | Easy | Solved |
| Basic Join | Average Population of Each Continent | Easy | Solved |
| Advanced Join | Placements | Medium | Solved |
| Advanced Join | Symmetric Pairs | Medium | Solved |
| Alternative Queries | Draw The Triangle 1 | Advanced | Solved |
| Alternative Queries | Print Prime Numbers | Advanced | Solved |

---

## Example Solutions

### The PADS (Advanced Select)
```sql
SELECT CONCAT(Name, '(', LEFT(Occupation, 1), ')')
FROM OCCUPATIONS
ORDER BY Name;

SELECT CONCAT('There are a total of ', COUNT(*), ' ', LOWER(Occupation), 's.')
FROM OCCUPATIONS
GROUP BY Occupation
ORDER BY COUNT(*), Occupation;
```

### Symmetric Pairs (Advanced Join)
```sql
SELECT f1.X, f1.Y
FROM Functions f1
JOIN Functions f2 ON f1.X = f2.Y AND f1.Y = f2.X
WHERE f1.X < f1.Y
UNION
SELECT X, Y
FROM Functions
WHERE X = Y
GROUP BY X, Y
HAVING COUNT(*) > 1
ORDER BY X;
```

---

## Topics Covered
- Basic and Advanced SELECT queries
- Aggregation functions
- String manipulation
- INNER and LEFT JOINs
- Subqueries and CTEs
- Mathematical functions
