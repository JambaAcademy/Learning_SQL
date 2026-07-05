# Chapter-by-Chapter Exercise Workbook

*The Science of Learning SQL: An Evidence-Based, Step-by-Step Guide to Mastering Databases, Queries, Joins, and Real-World Data Analysis for Complete Beginners*

---

## How to Use This Workbook

Each exercise is framed as a **real business question** a data analyst might receive. Write your query in the blank space provided, then compare your results against the expected output table. Use this workbook for active recall — attempt every query from memory before checking the solution.

**Grading key:**

| Mark | Meaning |
|------|---------|
| ✅ | Output matches exactly |
| 🟡 | Correct logic, minor formatting difference |
| ❌ | Reread the relevant section and retry |

---

## Chapter 3 — Your First SELECT Statement

### Business Context
You are a junior analyst at a retail company. Your manager needs readable summaries from the `products` table.

---

**Exercise 3.1** *(Difficulty: Beginner)*
> "List only the product name and price for every product we carry."

```sql
-- Write your query here:

```

**Expected Output (sample rows):**

| product_name | price |
|---|---|
| Wireless Headphones | 49.99 |
| USB-C Cable | 12.99 |
| Laptop Stand | 34.50 |

---

**Exercise 3.2** *(Difficulty: Beginner)*
> "Show every unique category we sell — no duplicates."

```sql
-- Write your query here:

```

**Expected Output:** A single-column result listing each category once (e.g., Electronics, Accessories, Furniture).

---

**Exercise 3.3** *(Difficulty: Beginner+)*
> "Display product name and price, but label the columns 'Item' and 'Retail Price' so the report looks professional."

```sql
-- Write your query here:

```

- Use `AS` to alias both columns.
- The underlying table is unchanged after running this query.

---

## Chapter 4 — Filtering Rows With WHERE

### Business Context
The sales team needs targeted lists from the `orders` table.

---

**Exercise 4.1** *(Difficulty: Beginner)*
> "Find all orders where the total amount is greater than $200."

```sql
-- Write your query here:

```

**Expected Output (sample rows):**

| order_id | customer_id | total_amount |
|---|---|---|
| 1042 | 305 | 215.00 |
| 1089 | 412 | 349.99 |

---

**Exercise 4.2** *(Difficulty: Intermediate)*
> "Find orders placed in the Electronics category AND with a status of 'Shipped'."

```sql
-- Write your query here:

```

- Combine conditions using `AND`.
- Remember: text values require single quotes.

---

**Exercise 4.3** *(Difficulty: Intermediate)*
> "Identify any orders where the shipping address is missing."

```sql
-- Write your query here:

```

**Key reminder:** Use `IS NULL`, not `= NULL`.

---

## Chapter 5 — Sorting and Limiting Results

### Business Context
Your manager wants ranked and paginated reports from the `customers` table.

---

**Exercise 5.1** *(Difficulty: Beginner)*
> "List the top 5 customers by total lifetime spend, highest first."

```sql
-- Write your query here:

```

**Expected Output (sample rows):**

| customer_name | lifetime_spend |
|---|---|
| Sarah Okonkwo | 1,240.00 |
| James Patel | 980.50 |

---

**Exercise 5.2** *(Difficulty: Intermediate)*
> "Show customers sorted by region (A–Z), then by lifetime spend (highest first) within each region."

```sql
-- Write your query here:

```

- Use two columns in `ORDER BY`.
- First sort column controls primary sequence; second resolves ties.

---

## Chapter 6 — Aggregate Functions and GROUP BY

### Business Context
Finance needs summary metrics from the `sales` table.

---

**Exercise 6.1** *(Difficulty: Intermediate)*
> "How many orders were placed in each product category?"

```sql
-- Write your query here:

```

**Expected Output:**

| category | order_count |
|---|---|
| Electronics | 412 |
| Accessories | 289 |
| Furniture | 134 |

---

**Exercise 6.2** *(Difficulty: Intermediate+)*
> "Show only the categories where total revenue exceeds $10,000."

```sql
-- Write your query here:

```

- Filter aggregated results with `HAVING`, not `WHERE`.

---

## Chapter 7 — Joins

### Business Context
You need to combine the `orders` and `customers` tables for a full sales report.

---

**Exercise 7.1** *(Difficulty: Intermediate)*
> "List every order alongside the customer's name — only where a match exists."

```sql
-- Write your query here:

```

- Use `INNER JOIN` on `customer_id`.

---

**Exercise 7.2** *(Difficulty: Intermediate+)*
> "Show all customers, including those who have never placed an order."

```sql
-- Write your query here:

```

- Use `LEFT JOIN`; unmatched order columns will appear as `NULL`.

---

## Chapter 8 — Subqueries

### Business Context
The analytics team needs dynamic, self-updating filters.

---

**Exercise 8.1** *(Difficulty: Advanced)*
> "Find all products priced above the average product price — without hardcoding the average."

```sql
-- Write your query here:

```

- The inner query calculates `AVG(price)`; the outer query filters against it.

---

**Exercise 8.2** *(Difficulty: Advanced)*
> "List customers who have never placed an order, using a subquery."

```sql
-- Write your query here:

```

- Use `NOT IN` with a subquery selecting `customer_id` from `orders`.

---

## Progress Tracker

| Chapter | Exercises Attempted | ✅ Correct | 🟡 Partial | ❌ Retry |
|---|---|---|---|---|
| Ch. 3 — SELECT | 3 | | | |
| Ch. 4 — WHERE | 3 | | | |
| Ch. 5 — ORDER BY / LIMIT | 2 | | | |
| Ch. 6 — Aggregates | 2 | | | |
| Ch. 7 — Joins | 2 | | | |
| Ch. 8 — Subqueries | 2 | | | |

> **Tip:** Any exercise marked ❌ is a retrieval opportunity, not a failure. Return to the relevant chapter section, reread the concept, then reattempt the query without looking at your previous attempt.
