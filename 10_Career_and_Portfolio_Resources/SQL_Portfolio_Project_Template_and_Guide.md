# SQL Portfolio Project Template and Guide

*Companion to Chapter 16: From Learner to Practitioner*

---

## Overview

A polished, documented SQL project on GitHub or a public platform demonstrates analytical thinking to employers far more convincingly than listing "SQL" on a résumé. Use this template for every project you publish. Complete every section — recruiters and hiring managers scan for thoroughness.

---

## Section 1: Project Header

```
Project Title:
Author:
Date Published:
Dataset Source (URL):
Tools Used:          (e.g., PostgreSQL, SQLite, DB Browser, DBeaver)
Skill Level Demonstrated:  (Beginner / Intermediate / Advanced)
```

---

## Section 2: Business Context

Answer these questions in 3–5 sentences before writing a single query. This mirrors the stakeholder clarification process described in Chapter 16 — asking the right questions before diving into data is what separates professional analysts from tutorial graduates.

- **What business problem does this analysis address?**
- **Who is the intended audience for these findings?** (e.g., marketing team, operations manager)
- **What decision could this analysis support?**
- **What does a successful answer look like?**

> **Example:** *A regional retail chain wants to understand which product categories drive repeat purchases. The findings will inform the Q3 promotions budget. Success means identifying at least two high-retention categories with supporting order-frequency data.*

---

## Section 3: Dataset Description

| Field | Details |
|---|---|
| Dataset Name | |
| Source | (Kaggle, data.gov, open city portal, etc.) |
| Row Count (approx.) | |
| Key Tables | List each table and its purpose |
| Date Range Covered | |
| Known Data Quality Issues | Nulls, duplicates, inconsistent formats |

**Data quality notes are mandatory.** Production SQL environments contain messy, inconsistent data that tutorials never replicate. Documenting what you found and how you handled it proves real-world readiness.

---

## Section 4: Cleaning and Preparation Queries

Document every cleaning step with the actual SQL and a plain-English explanation.

```sql
-- Remove duplicate order records introduced by the source export
DELETE FROM orders
WHERE order_id IN (
    SELECT order_id
    FROM orders
    GROUP BY order_id
    HAVING COUNT(*) > 1
);
```

**What this fixes:** Duplicate rows inflated revenue totals by approximately 4%. Identified by comparing `COUNT(order_id)` against `COUNT(DISTINCT order_id)`.

Repeat this pattern for each cleaning step. Never hide imperfect data — explaining how you handled it is the analysis.

---

## Section 5: Core Analysis Queries

For each query, provide three components:

1. **The business question being answered**
2. **The SQL query with inline comments**
3. **A plain-English interpretation of the result**

```sql
-- Q: Which product categories have the highest 90-day repeat purchase rate?
SELECT
    p.category,
    COUNT(DISTINCT o.customer_id)          AS total_customers,
    COUNT(DISTINCT r.customer_id)          AS repeat_customers,
    ROUND(
        COUNT(DISTINCT r.customer_id) * 100.0
        / COUNT(DISTINCT o.customer_id), 1
    )                                      AS repeat_rate_pct
FROM orders o
JOIN products p ON o.product_id = p.product_id
LEFT JOIN orders r
    ON o.customer_id = r.customer_id
    AND r.order_date BETWEEN o.order_date AND o.order_date + INTERVAL '90 days'
    AND r.order_id <> o.order_id
GROUP BY p.category
ORDER BY repeat_rate_pct DESC;
```

**Finding:** Electronics showed a 34% repeat rate — nearly double the store average — suggesting it is the strongest candidate for loyalty programme investment.

---

## Section 6: Key Findings Summary

- Finding 1 (quantified):
- Finding 2 (quantified):
- Finding 3 (quantified):
- One finding that surprised you and why it matters:

Quantify every finding. "Sales increased" is weak. "Revenue from returning customers grew 22% YoY" is portfolio-ready.

---

## Section 7: Visualisation Recommendations

| Finding | Recommended Chart Type | Rationale |
|---|---|---|
| Category repeat rates | Horizontal bar chart | Easy rank comparison |
| Revenue trend over time | Line chart | Shows momentum |
| Customer segment breakdown | Stacked bar or pie | Part-to-whole relationship |

Note the tool you would use (Tableau Public, Google Looker Studio, matplotlib) and include a screenshot or exported image if possible.

---

## Section 8: What You Would Do Next

List 2–3 follow-up analyses you would run given more time or data access. This signals the forward-thinking mindset stakeholders value and demonstrates you understand that one query rarely ends an investigation.

---

## Section 9: Skills Demonstrated

List the specific SQL concepts applied, aligned to the five interview question types from Chapter 16:

- [ ] Aggregation and GROUP BY logic
- [ ] JOIN types and multi-table queries
- [ ] Subqueries and CTEs
- [ ] Window functions
- [ ] Data cleaning and NULL handling

---

*Publish this document as your project `README.md`. Repeat the process monthly to maintain the spaced repetition rhythm recommended in Chapter 16's twelve-week review schedule.*
