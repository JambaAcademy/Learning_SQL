# Stakeholder Request Decomposition Framework

*Companion to Chapters 13 & 16 — The Science of Learning SQL*

---

## Purpose

Vague stakeholder requests are not a communication failure — they are the normal starting point of analytical work. This framework gives you a repeatable, layer-by-layer process for converting fuzzy business questions into precise SQL before you open a query editor. Apply it every time, without exception.

---

## Phase 1: Capture the Raw Request

Write the stakeholder's words down verbatim. Resist the urge to interpret or clarify yet.

- **Raw request:** *(paste or quote exactly)*
- **Requested by:** *(name / role)*
- **Date received:**
- **Deadline:**

> **Example raw request:** *"Can you pull something on how our top customers are doing lately?"*

---

## Phase 2: Ask the Five Clarifying Questions

Before touching a keyboard, ask these questions in writing or in a brief meeting. Document every answer. (Chapter 16 calls this *asking the right clarifying questions* — it is a professional habit, not a sign of confusion.)

| # | Clarifying Question | Stakeholder's Answer |
|---|---------------------|----------------------|
| 1 | What metric defines "doing well"? (revenue, orders, logins, etc.) | |
| 2 | What time period does "lately" mean? (last 30 days, this quarter, YTD?) | |
| 3 | How is "top customer" defined? (top 10 by lifetime spend? Any threshold?) | |
| 4 | What level of detail is needed? (one row per customer, or a summary total?) | |
| 5 | Where will this output go? (dashboard, email, spreadsheet, presentation?) |  |

---

## Phase 3: Write the Precise Analytical Question

Rewrite the request as a single, unambiguous sentence using the answers above.

**Template:**
> *"Return [metric] for [segment/filter] grouped by [dimension], covering [date range], ordered by [sort logic], limited to [row count or threshold]."*

**Example output:**
> *"Return total revenue and order count for the top 20 customers by lifetime spend, grouped by customer ID and name, covering the last 90 days, ordered by revenue descending."*

---

## Phase 4: Sketch the Query Logic (No Code Yet)

Identify every structural element before writing SQL. This is the *Query Planning Habit* from Chapter 13.

- **Tables needed:** *(list each table)*
- **Primary keys / foreign keys:** *(identify join columns)*
- **Join types required:** *(INNER, LEFT, etc., and why)*
- **Filter conditions (WHERE):** *(date range, status flags, exclusions)*
- **Grouping columns (GROUP BY):** *(dimensions for aggregation)*
- **Aggregation functions:** *(SUM, COUNT, AVG, etc.)*
- **Sort and limit:** *(ORDER BY, TOP / LIMIT)*

---

## Phase 5: Build Iteratively — Start Small

Chapter 13's *iterative query building* principle: never write the full query in one pass. Use this sequence:

1. **Row check** — SELECT \* FROM the primary table with a LIMIT 10 to confirm structure and data types.
2. **Filter test** — Add your WHERE clause alone and verify row counts make sense.
3. **Join test** — Add one join at a time; check for unexpected row multiplication.
4. **Aggregation test** — Add GROUP BY and aggregation; spot-check two or three groups manually.
5. **Final assembly** — Combine all clauses; apply ORDER BY and LIMIT.

---

## Phase 6: Validate Against Known Benchmarks

Before delivering results, sanity-check outputs against at least two independent reference points (Chapter 13: *Validating Your Results*).

- [ ] Does the total match a known figure (e.g., last month's report, a dashboard total)?
- [ ] Does the row count match the expected number of customers / products / orders?
- [ ] Are NULL values handled intentionally (COALESCE, IS NOT NULL filters)?
- [ ] Does the date range boundary behave as expected (inclusive vs. exclusive)?

---

## Phase 7: Document the Query

Every delivered query must include inline comments for collaboration and reproducibility (Chapter 13). Use this comment block at the top:

```sql
-- Request: [one-sentence precise analytical question]
-- Requested by: [name / role]
-- Date: [YYYY-MM-DD]
-- Tables used: [list]
-- Key filters: [date range, segment logic]
-- Known limitations: [any caveats, exclusions, or data quality notes]
-- Validated against: [benchmark source]
```

---

## Quick-Reference Checklist

| Step | Action | Done? |
|------|--------|-------|
| 1 | Raw request captured verbatim | ☐ |
| 2 | Five clarifying questions answered | ☐ |
| 3 | Precise analytical question written | ☐ |
| 4 | Tables, keys, joins, and filters sketched | ☐ |
| 5 | Query built in iterative layers | ☐ |
| 6 | Output validated against benchmarks | ☐ |
| 7 | Query documented with comment block | ☐ |

---

*Consistent use of this framework is what separates tutorial SQL from production SQL — and practitioners from learners.*
