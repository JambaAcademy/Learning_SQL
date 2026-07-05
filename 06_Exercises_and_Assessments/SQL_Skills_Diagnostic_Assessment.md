# SQL Skills Diagnostic Assessment

## Pre-Study Self-Evaluation for *The Science of Learning SQL*

**Purpose:** Complete this diagnostic before beginning the 12-week learning schedule from Chapter 1. Your results will reveal exactly which foundational areas need deeper focus and which chapters to prioritize. Answer each question independently — resist the urge to look up syntax first.

---

## How to Use This Assessment

1. Attempt every question without external help.
2. Record your confidence level (Low / Medium / High) alongside each answer.
3. Check your responses against the **Expected Outputs** section below.
4. Use the **Score Interpretation Guide** to map your gaps to specific chapters.

---

## Section 1: Core SELECT Queries *(Chapter 3)*

**Q1.** Write a query that retrieves only the `product_name` and `price` columns from a table called `products`.

**Q2.** You notice your results contain repeated city names. Write a query that returns a unique list of cities from a `customers` table, with the column labelled `unique_city`.

**Q3.** What does the following query return, and what problem does it solve?

```sql
SELECT first_name AS "First Name", last_name AS "Last Name"
FROM employees;
```

---

## Section 2: Filtering With WHERE *(Chapter 4)*

**Q4.** Write a query to retrieve all orders from the `orders` table where `total_amount` is greater than 500.

**Q5.** Retrieve all customers whose `country` is `'Canada'` AND whose `signup_year` is 2022 or later.

**Q6.** Write a query to find all products where the `description` column contains no value at all (the field is empty/absent).

**Q7.** Using `LIKE`, write a query that returns all employees from the `employees` table whose `last_name` begins with the letter `'S'`.

---

## Section 3: Sorting and Limiting *(Chapter 5)*

**Q8.** Write a query that returns the 5 most expensive products from the `products` table, sorted highest price first.

**Q9.** You want to sort `sales` records by `region` alphabetically, then by `sale_amount` from highest to lowest within each region. Write that query.

**Q10.** Place the following SQL clauses in their correct **logical execution order** (the order the database processes them, not the written order):

`LIMIT` — `ORDER BY` — `WHERE` — `SELECT` — `FROM`

---

## Section 4: Aggregation and GROUP BY *(Chapter 6)*

**Q11.** Write a query that counts the total number of rows in the `orders` table.

**Q12.** Find the average `salary` for each `department` in an `employees` table. Label the result `avg_salary`.

**Q13.** Modify your Q12 query to show only departments where the average salary exceeds 60,000.

**Q14.** Explain in one sentence why `COUNT(column_name)` and `COUNT(*)` can return different numbers.

---

## Section 5: Joins *(Chapter 7)*

**Q15.** Write an INNER JOIN query that combines `orders` and `customers` on `customer_id`, returning `customer_name` and `order_total`.

**Q16.** You want every customer to appear in results, even those with no orders. Which join type do you use, and why?

**Q17.** What happens if you forget the `ON` condition in a JOIN statement?

---

## Expected Outputs & Model Answers

| Q# | Key Concept Tested | Model Answer / Expected Output |
|----|--------------------|-------------------------------|
| Q1 | Column selection | `SELECT product_name, price FROM products;` |
| Q2 | DISTINCT + alias | `SELECT DISTINCT city AS unique_city FROM customers;` |
| Q3 | Column aliasing | Returns employee names with readable headers; solves unclear column labels |
| Q4 | Comparison operator | `WHERE total_amount > 500` |
| Q5 | AND + date filter | `WHERE country = 'Canada' AND signup_year >= 2022` |
| Q6 | NULL handling | `WHERE description IS NULL` |
| Q7 | LIKE wildcard | `WHERE last_name LIKE 'S%'` |
| Q8 | ORDER BY + LIMIT | `ORDER BY price DESC LIMIT 5` |
| Q9 | Multi-column sort | `ORDER BY region ASC, sale_amount DESC` |
| Q10 | Execution order | FROM → WHERE → SELECT → ORDER BY → LIMIT |
| Q11 | COUNT aggregate | `SELECT COUNT(*) FROM orders;` |
| Q12 | GROUP BY + AVG | `SELECT department, AVG(salary) AS avg_salary FROM employees GROUP BY department;` |
| Q13 | HAVING clause | Add `HAVING AVG(salary) > 60000` |
| Q14 | NULL counting trap | `COUNT(column_name)` skips NULL values; `COUNT(*)` counts every row |
| Q15 | INNER JOIN | `JOIN customers ON orders.customer_id = customers.customer_id` |
| Q16 | LEFT JOIN | LEFT JOIN — preserves all left-table rows regardless of matches |
| Q17 | Cartesian product | Rows multiply uncontrollably, silently corrupting results |

---

## Score Interpretation Guide

- **14–17 correct:** Strong foundation — use the 12-week schedule as designed.
- **10–13 correct:** Targeted gaps — revisit flagged chapters before advancing.
- **Below 10:** Begin at Chapter 3 and apply the spaced repetition system from Chapter 1 systematically.

> **Remember:** A low score here is diagnostic data, not failure. The cognitive science in Chapter 1 shows that identifying gaps *before* studying is precisely how active recall accelerates durable learning.
