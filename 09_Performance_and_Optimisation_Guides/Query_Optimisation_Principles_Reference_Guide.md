# Query Optimisation Principles Reference Guide

*Supporting Chapter 15: Performance and Optimisation*

---

## Why Optimisation Is a Foundational Skill, Not an Advanced One

Correct SQL and *efficient* SQL are two separate achievements. A query that returns the right answer on a 500-row test table can lock up a production system with 50 million rows. Chapter 15 makes a clear point: inefficient habits formed on small datasets become costly failures at scale. Optimisation is not a specialisation to defer — it is a professional baseline.

---

## The Logical Processing Order of SQL Execution

The database engine does **not** read your query in the order you write it. Understanding the actual execution sequence explains why certain optimisations work and others do not.

| Step | Clause Processed | What the Engine Does |
|------|-----------------|----------------------|
| 1 | `FROM` / `JOIN` | Identifies source tables and combines them |
| 2 | `WHERE` | Filters rows before any grouping |
| 3 | `GROUP BY` | Organises remaining rows into groups |
| 4 | `HAVING` | Filters groups (not individual rows) |
| 5 | `SELECT` | Computes columns and expressions |
| 6 | `DISTINCT` | Removes duplicate rows if specified |
| 7 | `ORDER BY` | Sorts the final result set |
| 8 | `LIMIT` / `FETCH` | Returns the requested row count |

**Key implication:** Aliases defined in `SELECT` are not yet available during `WHERE` or `GROUP BY` processing, because `SELECT` runs later. Filter as early as possible — every row eliminated in `WHERE` is a row the engine never has to group, sort, or return.

---

## Reading an Execution Plan Without a DBA

An execution plan is the database's step-by-step receipt showing exactly where processing time was spent. You do not need administrator privileges to read one — you need to know what to look for.

**How to generate a plan:**
- **PostgreSQL / SQLite:** Prepend `EXPLAIN` or `EXPLAIN ANALYZE` to your query.
- **MySQL:** Use `EXPLAIN SELECT ...`.
- **SQL Server:** Enable *Include Actual Execution Plan* in the query editor.

**What to look for:**

- **Sequential Scan / Full Table Scan** — The engine read every row in the table. On large tables, this is the primary warning sign.
- **Index Scan / Index Seek** — The engine used an index to locate rows directly. This is the target behaviour for filtered queries.
- **Estimated vs. Actual Rows** — A large gap means the engine's statistics are stale; results may be unreliable until statistics are refreshed.
- **Cost values** — Higher relative cost nodes are where to focus your tuning effort first.
- **Nested Loops on large sets** — Joining large tables without indexes produces exponential row comparisons.

> **Practical habit:** Run `EXPLAIN ANALYZE` before and after any index you add to confirm the plan actually changed.

---

## Indexing Strategies: What to Index and What to Leave Alone

An index is a pre-sorted reference structure. The database consults it the way you use a book's index — jumping directly to relevant entries rather than reading every page.

### Index These Columns

- **Columns used in `WHERE` clauses frequently** — especially high-cardinality columns (many distinct values, such as `customer_id` or `email`).
- **Foreign key columns** — joins on unindexed foreign keys force full scans of the child table.
- **Columns used in `ORDER BY` or `GROUP BY`** on large result sets.
- **Composite index columns** — when queries consistently filter on two columns together (e.g., `region` and `sale_date`), a multi-column index on both outperforms two separate indexes.

### Leave These Alone

- **Low-cardinality columns** — indexing a `status` column with three possible values rarely helps; the engine may still scan most rows.
- **Columns in small tables** — a full scan of a 200-row lookup table is faster than an index lookup.
- **Columns that are rarely queried** — every index consumes storage and slows `INSERT`, `UPDATE`, and `DELETE` operations.

---

## Common Performance Anti-Patterns

- **`SELECT *`** — retrieves every column including those never used, increasing data transfer and preventing index-only scans.
- **Functions wrapped around indexed columns in `WHERE`** — `WHERE YEAR(sale_date) = 2023` disables the index on `sale_date`; rewrite as a range filter instead.
- **`HAVING` used instead of `WHERE`** — filtering before grouping with `WHERE` is always cheaper than filtering after grouping with `HAVING`.
- **Unanchored `LIKE` patterns** — `WHERE name LIKE '%smith'` cannot use an index; `WHERE name LIKE 'smith%'` can.
- **Implicit type conversions in joins** — joining a `VARCHAR` column to an `INTEGER` column forces row-by-row conversion and disables indexes.

---

*Use this guide alongside the execution plan exercises in Chapter 15 to build the habit of checking plans before deploying any query to a production environment.*
