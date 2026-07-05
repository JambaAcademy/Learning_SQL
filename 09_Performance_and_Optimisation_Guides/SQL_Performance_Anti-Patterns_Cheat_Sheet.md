# SQL Performance Anti-Patterns Cheat Sheet

*Quick reference for Chapters 8 & 15 — spot the problem, apply the fix*

---

## Why This Matters

Correct SQL and *efficient* SQL are two different skills. On a small practice dataset a slow query finishes in milliseconds; on a production table with millions of rows the same habit can lock up an application. The patterns below are the most common ways beginners unknowingly write queries that work but don't scale.

---

## Anti-Pattern Quick-Reference Table

| # | Anti-Pattern | Root Problem | Chapter Reference |
|---|---|---|---|
| 1 | `SELECT *` everywhere | Fetches unneeded columns; blocks index-only scans | Ch. 15 |
| 2 | Correlated subquery on a large table | Inner query re-executes for every outer row | Ch. 8, Ch. 15 |
| 3 | Missing index on a filtered or joined column | Full table scan instead of targeted row lookup | Ch. 15 |
| 4 | `NOT IN` with a subquery that can return `NULL` | Unexpected empty result sets; forces full scan | Ch. 8 |
| 5 | Filtering inside a `FROM`-clause subquery unnecessarily | Materialises a large derived table before filtering | Ch. 8 |
| 6 | Ignoring the execution plan | Guessing at fixes instead of reading the evidence | Ch. 15 |

---

## Anti-Pattern Details and Rewrites

### 1. `SELECT *` — Requesting Everything You Don't Need

**The problem:** `SELECT *` forces the engine to read every column from disk, even columns your query never uses. It also prevents the database from satisfying the query using an index alone (an *index-only scan*).

**Rewrite:**
```sql
-- ❌ Anti-pattern
SELECT * FROM orders WHERE customer_id = 101;

-- ✅ Fix: name only the columns you actually need
SELECT order_id, order_date, total_amount
FROM orders
WHERE customer_id = 101;
```

---

### 2. Correlated Subquery on a Large Table

**The problem:** A correlated subquery references the outer query's current row, so the database re-runs the inner query *once per outer row*. On a table with 500 000 rows, that is 500 000 separate inner executions. Chapter 8 flags this as the key performance intuition to build early.

**Rewrite — replace with a `JOIN` or a scalar subquery in `FROM`:**
```sql
-- ❌ Anti-pattern: inner query fires for every employee row
SELECT employee_id, salary
FROM employees e
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE department_id = e.department_id
);

-- ✅ Fix: calculate averages once in a derived table, then join
SELECT e.employee_id, e.salary
FROM employees e
JOIN (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
) dept_avg ON e.department_id = dept_avg.department_id
WHERE e.salary > dept_avg.avg_salary;
```

The derived table (`FROM`-clause subquery) runs *once*; the join is then a single efficient operation.

---

### 3. Missing Index on a Filtered or Joined Column

**The problem:** Without an index, the engine performs a *full table scan* — reading every row to find matches. Chapter 15 explains that indexes act as pre-sorted references that let the database jump directly to target rows.

**Columns worth indexing:**
- Columns that appear in `WHERE` clauses frequently
- Columns used in `JOIN` conditions (`ON t1.id = t2.id`)
- Columns used in `ORDER BY` on large result sets

**Columns to leave alone:**
- Low-cardinality columns (e.g., a `gender` column with two values) — the index rarely helps
- Columns that are almost never filtered on

```sql
-- Add an index on a commonly filtered column
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
```

---

### 4. `NOT IN` With a Subquery That Can Return `NULL`

**The problem:** If the subquery returns even one `NULL` value, `NOT IN` returns no rows at all — a silent, hard-to-debug result. Chapter 8 covers this when discussing subqueries with `IN` and `NOT IN`.

```sql
-- ❌ Anti-pattern: breaks silently if subquery returns NULL
SELECT customer_id FROM customers
WHERE customer_id NOT IN (SELECT customer_id FROM orders);

-- ✅ Fix: use NOT EXISTS, which handles NULLs correctly
SELECT customer_id FROM customers c
WHERE NOT EXISTS (
    SELECT 1 FROM orders o
    WHERE o.customer_id = c.customer_id
);
```

---

### 5. Not Reading the Execution Plan

**The problem:** Optimising without reading the execution plan is guesswork. Chapter 15 shows that execution plans reveal exactly where query time is spent — whether it's a full scan, a missing index, or an expensive sort — so you fix the *actual* bottleneck.

**Quick-start commands:**
```sql
EXPLAIN SELECT ...;          -- PostgreSQL / MySQL: estimated plan
EXPLAIN ANALYZE SELECT ...;  -- PostgreSQL: estimated + actual timings
```

Look for: **Seq Scan** (full table scan — often fixable with an index), **high row estimates vs. actuals** (stale statistics), and **nested loop on large sets** (candidate for a derived-table rewrite).

---

## One-Line Rules to Remember

- **Name your columns.** `SELECT *` is a habit to break on day one.
- **Correlated = repeated.** If the inner query touches the outer row, it runs once per row.
- **Index the join, filter the index.** Put indexes where your `WHERE` and `ON` clauses point.
- **`NOT EXISTS` over `NOT IN`** whenever nullability is possible.
- **Read before you rewrite.** The execution plan shows the truth; your intuition might not.
