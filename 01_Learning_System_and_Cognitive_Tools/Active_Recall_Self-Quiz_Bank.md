# Active Recall Self-Quiz Bank
### *The Science of Learning SQL* — Chapter-by-Chapter Question Bank

---

> **How to use this bank:** Close your notes. Write or type your answer from memory before checking. Passive re-reading feels productive but builds no durable skill — the forgetting curve will erase it within days. Reconstruction is the mechanism that rewires technical memory.

---

## Spaced Repetition Schedule

| Session | Chapters to Quiz | Days Since Last Review |
|---|---|---|
| Day 1 | Ch. 3 | — (first exposure) |
| Day 2 | Ch. 3 + Ch. 4 | 1 |
| Day 4 | Ch. 3, 4 + Ch. 5 | 2 |
| Day 7 | Ch. 3–5 + Ch. 6 | 3 |
| Day 12 | Ch. 3–6 + Ch. 7 | 5 |
| Day 20 | Full bank: Ch. 3–7 | 8 |

Return to questions that stumped you at each session. Struggle during retrieval is the signal that durable learning is occurring.

---

## Chapter 1 — The Cognitive Science Foundation

1. Name the two learning mechanisms that Chapter 1 identifies as building lasting SQL fluency, and explain in one sentence why each works.
2. What does the forgetting curve predict will happen to SQL syntax you read once but never actively retrieve?
3. Describe the "pyramid" metaphor for progressive skill layering. Why does skipping foundational concepts cause cognitive overload later?
4. What is the difference between *recognising* a SQL keyword and being able to *reconstruct* it? Which one do professional analysts actually need?

---

## Chapter 3 — Your First SELECT Statement

1. Write from memory the minimal SQL statement that retrieves every column from a table called `customers`.
2. Rewrite that query so it retrieves only `customer_id` and `email`.
3. A colleague's result set contains 47 rows but several city names repeat. Write the query that returns only unique city values from a `customers` table.
4. Your output column is labelled `annual_revenue`. Write the clause that renames it to `Annual Revenue` in the results without altering the table.
5. You run a query and receive an error. According to Chapter 3, what should your first instinct be — and why are error messages described as "diagnostic feedback" rather than failures?
6. What is the difference between `SELECT *` and listing specific columns? Name one professional reason to avoid `SELECT *` in production queries.

---

## Chapter 4 — Filtering Rows With WHERE

1. Write a query that retrieves all rows from `orders` where `status` equals `'shipped'`.
2. Extend that query to also require that `order_total` is greater than 500.
3. A column called `delivery_date` contains some empty values. Write the condition that returns only rows where `delivery_date` has no value recorded.
4. Why can't you write `WHERE delivery_date = NULL`? What happens when you try?
5. Write a WHERE clause that returns customers whose last name starts with the letter `M`. Which operator and wildcard character do you need?
6. You need orders placed in 2023 only. Write the condition using `>=` and `<` on a `order_date` column.

---

## Chapter 5 — Sorting and Limiting Results

1. Write a query that returns the 10 most recent rows from an `events` table sorted by `event_date`.
2. Sort `products` by `category` ascending, then by `price` descending within each category. Write the full `ORDER BY` clause.
3. List the six standard SQL clauses (`SELECT`, `FROM`, `WHERE`, `GROUP BY`, `HAVING`, `ORDER BY`) in the order you *write* them, then in the order the database *executes* them.
4. What does `OFFSET 20` accomplish when combined with `LIMIT 10`? Describe the practical use case.

---

## Chapter 6 — Aggregate Functions and GROUP BY

1. Write a query that counts the total number of rows in an `orders` table.
2. Write a query that returns the average `sale_price` grouped by `product_category`.
3. You want only categories where the average sale price exceeds 100. Write the complete query including the correct filter clause.
4. Why does `HAVING` exist as a separate clause from `WHERE`? What breaks if you try to filter an aggregate with `WHERE`?
5. A `reviews` table has a `rating` column with some NULL values. What does `COUNT(rating)` return versus `COUNT(*)`?

---

## Chapter 7 — Joins

1. Write an INNER JOIN between `orders` and `customers` on `customer_id`. What rows are excluded from the result?
2. Rewrite that join as a LEFT JOIN. Which table's unmatched rows are preserved?
3. Define a Cartesian product. What mistake in your SQL causes one?
4. A query joins `orders`, `customers`, and `products`. Sketch the two JOIN clauses you need (table names and key columns are your choice — write valid syntax).
5. Why do relational databases split data across multiple tables rather than storing everything in one? Name one benefit.

---

## Self-Scoring Guide

| Score | Interpretation | Action |
|---|---|---|
| Wrote it perfectly from memory | Consolidated — schedule next review in 5–8 days | Move forward |
| Mostly correct, minor syntax gap | Nearly consolidated — review that clause once, re-test tomorrow | Targeted review |
| Recalled the concept but not syntax | Familiarity without fluency — write the query 3× by hand | Rewrite drill |
| Could not recall | Not yet encoded — re-read the section, quiz again in 24 hours | Re-exposure |
