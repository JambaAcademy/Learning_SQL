# Real Business Question Translation Exercises

## Chapter 13 Practice: From Vague Request to Executable SQL

These exercises apply the decomposition framework from Chapter 13. For each scenario, **do not write SQL immediately.** Instead, work through the planning steps in order, then write and validate your query.

---

## How to Use These Exercises

Follow the four-step framework for every scenario before opening a query editor:

1. **Restate** the vague request as a precise analytical question
2. **Identify** the tables, keys, and joins required
3. **Sketch** the filters, aggregations, and sort order in plain English
4. **Write** the SQL iteratively, starting with the simplest possible version

---

## Exercise Set

### Exercise 1 — "Show Me the Top Customers" *(Beginner)*

**Stakeholder request:**
> "Can you pull a list of our best customers from last quarter?"

**Your decomposition tasks:**

- What does "best" mean? (Revenue? Order count? Both?)
- What qualifies as "last quarter"? (Hard-code dates or use a dynamic expression?)
- Should the list be limited to a specific number of rows?

**Planning table — fill this in before writing SQL:**

| Planning Step | Your Answer |
|---|---|
| Precise analytical question | |
| Primary table | |
| Join required? (yes/no + table name) | |
| Filter condition(s) | |
| Aggregation | |
| Sort order | |
| Row limit | |

**Expected output shape:** One row per customer, columns for customer name, total revenue, ordered descending by revenue, limited to 10 rows.

**Validation benchmark:** Manually sum the top customer's orders from a small sample date range and confirm your query returns the same total.

---

### Exercise 2 — "Which Products Aren't Selling?" *(Intermediate)*

**Stakeholder request:**
> "We need to know if any products have gone quiet recently."

**Your decomposition tasks:**

- Define "gone quiet" — zero orders in the last 30 days? Fewer than a threshold?
- Are discontinued products in scope?
- Should results include products never sold, or only those with a sales history?

**Planning table:**

| Planning Step | Your Answer |
|---|---|
| Precise analytical question | |
| Primary table | |
| Join required? (yes/no + table name) | |
| Filter condition(s) | |
| Aggregation | |
| Sort order | |
| Row limit | |

**Hint:** This likely requires a `LEFT JOIN` between a products table and an orders table, with a `WHERE` clause filtering for `NULL` matches or zero counts — a classic pattern for finding "missing" records.

**Expected output shape:** One row per product with no orders in the defined window, showing product ID, product name, and date of last order (or NULL).

**Validation benchmark:** Pick one product from the result set and manually confirm in the orders table that no orders exist within the defined date range.

---

### Exercise 3 — "How Are We Doing Month Over Month?" *(Intermediate)*

**Stakeholder request:**
> "Leadership wants to see our performance trend."

**Your decomposition tasks:**

- Which metric defines "performance"? (Revenue, units, new customers?)
- Over what time range?
- Should months with zero activity appear as rows or be omitted?

**Expected output shape:** One row per calendar month, columns for year, month, total revenue, and a calculated column showing the difference from the prior month.

**Validation benchmark:** Confirm the grand total across all months matches a known annual revenue figure from a finance report or dashboard.

---

### Exercise 4 — "Find Problem Orders" *(Advanced)*

**Stakeholder request:**
> "Something looks off with some orders — can you dig into it?"

**Your decomposition tasks:**

- Define "problem" — orders with no associated customer? Orders with negative amounts? Orders placed but never fulfilled?
- Which tables hold order status and fulfillment data?
- Should results be filtered to a specific time window or product category?

**Expected output shape:** One row per flagged order, with columns for order ID, customer ID, order date, order total, and a `flag_reason` label explaining why the record was flagged.

**Validation benchmark:** Cross-reference three flagged order IDs against the raw orders table to confirm each meets your defined problem criteria.

---

## Documentation Requirement

For every exercise you complete, add a comment block above your final SQL using this structure:

```sql
-- Question: [Your precise restatement of the stakeholder request]
-- Tables used: [List tables]
-- Key joins: [Describe join logic]
-- Filters applied: [List WHERE conditions]
-- Validated: [How you confirmed the output]
-- Author / Date: [Your name and date]
```

This habit — drawn directly from Chapter 13's guidance on reproducibility — ensures any colleague can read, trust, and rerun your work without asking you to explain it from scratch.

---

## Grading Rubric

| Criterion | Points |
|---|---|
| Precise question restatement completed before SQL written | 20 |
| Planning table fully filled in | 20 |
| SQL builds iteratively (evidence of simple → complex steps) | 25 |
| Output shape matches expected result | 20 |
| Validation benchmark documented | 15 |
