# Five SQL Interview Question Types Preparation Guide

*Companion to Chapter 16: From Learner to Practitioner*

---

## Overview

Chapter 16 identifies five recurring SQL interview question types that appear consistently across data analyst hiring processes. Preparing a structured verbal response framework for each type — alongside a clean, annotated SQL example — dramatically improves your performance. This guide gives you both.

---

## The Five Question Types at a Glance

| # | Question Type | What Interviewers Are Testing |
|---|---------------|-------------------------------|
| 1 | Conceptual / Definition | Foundational understanding of SQL mechanics |
| 2 | Write-a-Query | Syntax fluency and logical problem decomposition |
| 3 | Debugging / Fix-the-Code | Attention to detail and error diagnosis |
| 4 | Business Scenario | Translation of vague requirements into precise queries |
| 5 | Messy / Real-World Data | Awareness that production data is imperfect |

---

## Type 1 — Conceptual / Definition Questions

**Example question:** *"What is the difference between `LEFT JOIN` and `INNER JOIN`?"*

**Verbal framework (DEFINE → CONTRAST → USE CASE):**
- Define both terms plainly
- Contrast their behavior with one concrete difference
- Name a real use case where you'd choose one over the other

**Annotated SQL example:**
```sql
-- INNER JOIN: returns only rows with matches in BOTH tables
SELECT orders.order_id, customers.name
FROM orders
INNER JOIN customers ON orders.customer_id = customers.customer_id;

-- LEFT JOIN: returns ALL rows from the left table,
-- NULL for unmatched rows on the right
SELECT customers.name, orders.order_id
FROM customers
LEFT JOIN orders ON customers.customer_id = orders.customer_id;
-- Use LEFT JOIN when you need to find customers with NO orders
```

---

## Type 2 — Write-a-Query Questions

**Example question:** *"Show me the top 5 customers by total revenue in the last 90 days."*

**Verbal framework (RESTATE → PLAN → BUILD):**
- Restate the goal in your own words before writing anything
- Name the tables and columns you'd need
- Build the query incrementally, narrating each clause

**Annotated SQL example:**
```sql
SELECT
    customer_id,
    SUM(order_total) AS total_revenue   -- aggregate revenue per customer
FROM orders
WHERE order_date >= CURRENT_DATE - INTERVAL '90 days'  -- filter time window
GROUP BY customer_id                    -- one row per customer
ORDER BY total_revenue DESC             -- highest revenue first
LIMIT 5;                                -- top 5 only
```

> **Tip:** Narrating your reasoning out loud while writing demonstrates analytical thinking — interviewers value the process, not just the output.

---

## Type 3 — Debugging / Fix-the-Code Questions

**Example question:** *"This query returns no results — what's wrong?"*

**Verbal framework (READ → HYPOTHESIZE → TEST):**
- Read the query aloud before touching it
- State your hypothesis about the likely error
- Explain what change you'd make and why

**Common bugs to check first:**
- `WHERE` clause filtering out all rows (wrong date format, wrong comparison operator)
- `GROUP BY` missing a non-aggregated column
- `HAVING` used where `WHERE` is needed (or vice versa)
- Joining on mismatched data types (integer vs. string IDs)

---

## Type 4 — Business Scenario Questions

**Example question:** *"Our marketing team wants to know which product categories are underperforming. How would you approach this?"*

**Verbal framework (CLARIFY → DEFINE METRIC → QUERY → INTERPRET):**
- Ask one or two clarifying questions before writing SQL (Chapter 16 emphasizes this skill under stakeholder communication)
- Define what "underperforming" means numerically
- Write the query against that definition
- Describe how you'd present the result

**Clarifying questions to model:**
- "What time period should we evaluate?"
- "Are we measuring by revenue, units sold, or margin?"
- "Should we compare against a target, or against other categories?"

---

## Type 5 — Messy / Real-World Data Questions

**Example question:** *"How would you handle NULL values and duplicate records before analyzing this dataset?"*

**Verbal framework (AUDIT → CLEAN → DOCUMENT):**
- Describe how you'd first audit the data for issues
- Explain specific cleaning steps with SQL
- Note that production data is always imperfect — Chapter 16 stresses this directly

**Annotated SQL example:**
```sql
-- Audit NULLs
SELECT COUNT(*) AS total_rows,
       COUNT(customer_id) AS non_null_ids   -- NULLs are excluded by COUNT(col)
FROM customers;

-- Remove duplicates using ROW_NUMBER()
WITH ranked AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY email ORDER BY created_at DESC) AS rn
    FROM customers
)
SELECT * FROM ranked WHERE rn = 1;  -- keep the most recent record per email
```

---

## Quick Preparation Checklist

- [ ] Practice each question type with a timer (15 minutes per question)
- [ ] Record yourself narrating a query solution — review the playback
- [ ] Build at least one portfolio project using real, messy public data
- [ ] Prepare two clarifying questions for every business scenario prompt
- [ ] Review this guide on your spaced repetition schedule (see Chapter 16's twelve-week plan)

---

*Structured preparation converts SQL knowledge into interview performance. The goal is not memorization — it is fluency under pressure.*
