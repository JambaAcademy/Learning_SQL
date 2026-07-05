# Query Documentation and Comment Standards Guide

*Companion to Chapter 13: Writing Queries for Real Business Questions*

---

## Purpose

This guide operationalises the documentation practices introduced in Chapter 13. Every query you write should be reproducible by a colleague who was not present when you built it. Consistent comments and header blocks make that possible without extra meetings or guesswork.

---

## The Two Layers of Query Documentation

Chapter 13 establishes that analytical work moves through deliberate layers — planning before coding, validating before sharing. Documentation follows the same two-layer structure:

- **Header block** — captures the *why* and *what* before the first `SELECT`
- **Inline comments** — capture the *how* at each logical step inside the query

Both layers are required. A header without inline comments leaves colleagues lost inside the logic. Inline comments without a header leave them wondering what business question the query was meant to answer.

---

## Standard Header Block Template

Place this block at the top of every query file or script section.

```sql
-- ============================================================
-- QUERY:        [Short descriptive name, e.g., Monthly Revenue by Region]
-- AUTHOR:       [Your name]
-- DATE CREATED: [YYYY-MM-DD]
-- LAST UPDATED: [YYYY-MM-DD]
-- ------------------------------------------------------------
-- BUSINESS QUESTION:
--   [Paste the original stakeholder request verbatim, then restate
--    the precise analytical question you derived from it.]
--   Original: "Can we see how sales are doing by region?"
--   Precise:  "What is total revenue per region for the trailing
--              12 months, excluding cancelled orders?"
-- ------------------------------------------------------------
-- TABLES USED:  orders, customers, regions
-- KEY JOINS:    orders.customer_id = customers.id
--               customers.region_id = regions.id
-- FILTERS:      order_date >= CURRENT_DATE - INTERVAL '12 months'
--               order_status != 'cancelled'
-- VALIDATION:   Row count matches finance dashboard total (n=48 regions).
--               Grand total within 0.5% of last month's reported figure.
-- ============================================================
```

---

## Inline Comment Standards

| Situation | Comment Style | Example |
|---|---|---|
| Table or CTE introduction | `-- [Name]: what this data represents` | `-- orders_clean: orders from last 12 months, cancelled rows removed` |
| Join explanation | `-- Join on [key] to bring in [field]` | `-- Join on customer_id to bring in region_id` |
| Filter rationale | `-- Exclude [X] because [business reason]` | `-- Exclude status='cancelled' per finance team definition` |
| Aggregation intent | `-- [Metric] as defined by [source/team]` | `-- SUM(revenue) as defined by the sales reporting spec` |
| Known limitation | `-- NOTE: [limitation and impact]` | `-- NOTE: refunds not yet deducted; totals will be slightly high` |

---

## Translating the Stakeholder Request — Documented Example

The following pattern mirrors the decomposition framework from Chapter 13.

```sql
-- ============================================================
-- QUERY:        Top 10 Customers by Lifetime Value
-- AUTHOR:       J. Rivera
-- DATE CREATED: 2024-03-15
-- LAST UPDATED: 2024-03-18
-- ------------------------------------------------------------
-- BUSINESS QUESTION:
--   Original: "Who are our best customers?"
--   Precise:  "Which 10 customers have the highest total paid
--              order value since account creation, excluding
--              internal test accounts?"
-- TABLES USED:  customers, orders
-- KEY JOINS:    orders.customer_id = customers.id
-- FILTERS:      customers.is_test_account = FALSE
--               orders.status = 'paid'
-- VALIDATION:   Top customer matches CRM record. Total across
--               top 10 cross-checked against BI tool report #42.
-- ============================================================

SELECT
    c.id,
    c.name,
    -- Lifetime value: sum of all paid order amounts
    SUM(o.amount) AS lifetime_value
FROM customers AS c
-- Join to orders to access transaction amounts
INNER JOIN orders AS o
    ON o.customer_id = c.id
-- Exclude internal test accounts per data dictionary definition
WHERE c.is_test_account = FALSE
-- Only count revenue that was actually collected
  AND o.status = 'paid'
GROUP BY c.id, c.name
ORDER BY lifetime_value DESC
LIMIT 10;
```

---

## Validation Notes — What to Record

Chapter 13 emphasises sanity-checking outputs before sharing them. Document your checks inside the header or in a separate comment block at the end of the file.

- **Row count check** — does the number of rows match an expected dimension (e.g., one row per region)?
- **Aggregate spot-check** — does the grand total align with a known benchmark such as a finance report or BI dashboard?
- **Edge-case confirmation** — are nulls, duplicates, and excluded categories handled as intended?
- **Date range verification** — does `MIN(order_date)` and `MAX(order_date)` in the result match the intended window?

---

## Quick Reference Checklist

- [ ] Header block present with original and precise business question
- [ ] All tables and join keys listed in the header
- [ ] Every filter has a comment explaining the business rationale
- [ ] Aggregations reference the team or document that defines the metric
- [ ] Known limitations flagged with `-- NOTE:`
- [ ] Validation results recorded before the query is shared
