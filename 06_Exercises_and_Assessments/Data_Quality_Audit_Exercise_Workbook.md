# Data Quality Audit Exercise Workbook

## Chapter 14 — Detecting and Diagnosing Dirty Data

This workbook accompanies Chapter 14 of *The Science of Learning SQL*. Each exercise targets a specific detection technique from the chapter. Work through every query, compare your output to the expected results, and use the grading rubric to confirm mastery before moving on.

---

## Dataset: `dirty_sales.csv`

Import the CSV into a table called `dirty_sales` with the following schema:

```sql
CREATE TABLE dirty_sales (
    order_id      INTEGER,
    customer_id   INTEGER,
    product_name  VARCHAR(100),
    category      VARCHAR(50),
    quantity      INTEGER,
    unit_price    DECIMAL(10,2),
    order_date    VARCHAR(20),   -- intentionally stored as text
    region        VARCHAR(50),
    customer_fk   INTEGER        -- references a customers table
);
```

A companion `customers` table (50 rows, IDs 1–50) is provided separately.

---

## Exercise 1 — Detecting NULLs, Blanks, and Placeholder Values

**Objective:** Identify every column that contains missing or disguised-missing data.

**Your query must:**
- Count NULL values per column using `SUM(CASE WHEN col IS NULL THEN 1 ELSE 0 END)`
- Detect blank strings (`''`) and common placeholders (`'N/A'`, `'unknown'`, `'none'`)

```sql
SELECT
    SUM(CASE WHEN order_id    IS NULL THEN 1 ELSE 0 END) AS null_order_id,
    SUM(CASE WHEN product_name = '' OR LOWER(product_name)
             IN ('n/a','unknown','none') THEN 1 ELSE 0 END) AS dirty_product_name,
    SUM(CASE WHEN region IS NULL OR LOWER(region)
             IN ('n/a','unknown') THEN 1 ELSE 0 END)       AS dirty_region
FROM dirty_sales;
```

**Expected Output:**

| null_order_id | dirty_product_name | dirty_region |
|---|---|---|
| 3 | 7 | 12 |

**Grading:** ✅ Pass if all three counts match within ±1 (data has deliberate variation).

---

## Exercise 2 — Finding Duplicates with ROW_NUMBER

**Objective:** Surface rows that share the same `order_id`, revealing duplicate records that would inflate aggregations.

```sql
WITH ranked AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY rowid) AS rn
    FROM dirty_sales
)
SELECT * FROM ranked WHERE rn > 1;
```

**Expected Output:** 5 duplicate rows returned, each with `rn = 2` or higher.

**Follow-up question:** Write a DELETE or SELECT-into-new-table query that keeps only `rn = 1`. Explain in one sentence why deleting without first auditing is dangerous.

---

## Exercise 3 — Identifying Outliers and Impossible Values

**Objective:** Use statistical filters to flag rows where `quantity` or `unit_price` fall outside realistic bounds.

**Your query must flag:**
- `quantity <= 0` or `quantity > 500`
- `unit_price < 0` or `unit_price > 10000`
- `order_date` values that cannot be cast to a valid date (test with `TRY_CAST` or `CASE` logic)

```sql
SELECT order_id, quantity, unit_price, order_date
FROM dirty_sales
WHERE quantity <= 0
   OR quantity > 500
   OR unit_price < 0
   OR unit_price > 10000;
```

**Expected Output:** 8 rows flagged as outliers.

**Grading rubric:**

| Check | Points |
|---|---|
| Catches negative quantities | 1 |
| Catches zero quantities | 1 |
| Catches price > 10 000 | 1 |
| Includes impossible date detection | 2 |
| **Total** | **5** |

---

## Exercise 4 — Standardising Inconsistent Categories

**Objective:** Use `CASE WHEN` and `LOWER()` / `TRIM()` to unify the `category` column before any GROUP BY analysis.

```sql
SELECT
    category AS raw_category,
    CASE
        WHEN LOWER(TRIM(category)) IN ('electronics','electronic','electrnics') THEN 'Electronics'
        WHEN LOWER(TRIM(category)) IN ('clothing','clothng','apparel')          THEN 'Clothing'
        WHEN LOWER(TRIM(category)) IN ('food','foods','grocery')                THEN 'Food'
        ELSE 'Uncategorised'
    END AS clean_category,
    COUNT(*) AS row_count
FROM dirty_sales
GROUP BY raw_category;
```

**Expected Output:** Raw categories collapse from 11 distinct values to 4 clean values.

---

## Exercise 5 — Auditing Referential Integrity

**Objective:** Detect orphaned records — rows in `dirty_sales` whose `customer_fk` has no match in `customers`.

```sql
SELECT ds.order_id, ds.customer_fk
FROM dirty_sales ds
LEFT JOIN customers c ON ds.customer_fk = c.customer_id
WHERE c.customer_id IS NULL;
```

**Expected Output:** 6 orphaned rows. These rows would be silently excluded from any INNER JOIN analysis.

**Reflection prompt:** How does an orphaned record corrupt a revenue-by-customer report? Write your answer in two sentences before checking the chapter discussion.

---

## Completion Checklist

- [ ] Exercise 1 — NULL and placeholder audit complete
- [ ] Exercise 2 — Duplicates identified and deduplication query written
- [ ] Exercise 3 — Outlier filter scores 4 or 5 out of 5
- [ ] Exercise 4 — Category standardisation reduces to 4 clean values
- [ ] Exercise 5 — Referential integrity orphans found and reflection answered

**Score 4–5 exercises correctly → ready for Chapter 15.**
