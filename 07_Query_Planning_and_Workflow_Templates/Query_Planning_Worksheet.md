# Query Planning Worksheet
### *The Science of Learning SQL* — Chapter 13 Companion Template

Use this worksheet **before** opening a query editor. Completing every section transforms a vague stakeholder request into a structured, auditable SQL plan you can execute with confidence.

---

## Section 1 — Capture the Raw Stakeholder Request

Write down the original question exactly as it was asked, fuzzy wording and all. Resist the urge to clean it up yet.

> **Raw request:**
> _______________________________________________________________
> _______________________________________________________________

*Why this matters:* Chapter 13 establishes that vague requests are the normal starting point of analytical work. Preserving the original wording helps you verify later that your SQL actually answers what was asked.

---

## Section 2 — Restate as a Precise Analytical Question

Decompose the request into a single, unambiguous question with explicit boundaries.

| Element | Your Answer |
|---|---|
| **What metric or value is needed?** | |
| **For which entity or group?** | |
| **Over what time period?** | |
| **Any explicit exclusions or edge cases?** | |
| **Expected output format (count, sum, list, etc.)?** | |

> **Restated analytical question:**
> _______________________________________________________________
> _______________________________________________________________

---

## Section 3 — Identify Required Tables

List every table you believe holds data relevant to this question. Note the primary key for each.

| Table Name | What It Contains | Primary Key | Confirmed? ✓ |
|---|---|---|---|
| | | | |
| | | | |
| | | | |
| | | | |

- [ ] I have checked the database schema or data dictionary to confirm these tables exist.
- [ ] I know which table holds the **fact** data (transactions, events, records) versus **dimension** data (customers, products, dates).

---

## Section 4 — Map the Join Logic

Sketch how the tables connect before writing a single line of code. Identify the foreign key relationships that link each pair.

| Left Table | Join Type | Right Table | Join Condition (ON clause) |
|---|---|---|---|
| | INNER / LEFT / RIGHT | | `__ .__ = __ .__` |
| | INNER / LEFT / RIGHT | | `__ .__ = __ .__` |
| | INNER / LEFT / RIGHT | | `__ .__ = __ .__` |

> **⚠ Join caution:** Will any join produce duplicate rows? If so, note your deduplication strategy here:
> _______________________________________________________________

---

## Section 5 — List Filters and Conditions

Translate every constraint from Section 2 into explicit WHERE or HAVING clause logic.

| Filter | Column | Operator | Value | Clause Type |
|---|---|---|---|---|
| Date range | | `BETWEEN` | | WHERE |
| Status / category | | `=` / `IN` | | WHERE |
| Minimum threshold | | `>=` | | HAVING |
| Exclusion | | `<>` / `NOT IN` | | WHERE |

- [ ] Date filters reference the correct date column (order date vs. ship date vs. payment date).
- [ ] NULL handling is considered for each filtered column.

---

## Section 6 — Sketch the SELECT and GROUP BY Columns

List what you plan to return and how rows should be aggregated.

- **Columns to SELECT:**
  1. _______________________________________________________________
  2. _______________________________________________________________
  3. _______________________________________________________________

- **Aggregate functions needed** (COUNT, SUM, AVG, MAX, MIN):
  - _______________________________________________________________

- **GROUP BY columns** (every non-aggregated SELECT column):
  - _______________________________________________________________

- **ORDER BY / LIMIT:**
  - _______________________________________________________________

---

## Section 7 — Iterative Build Order

Chapter 13 recommends starting small and adding complexity gradually. Plan your build sequence here.

- [ ] **Step 1 — Single table, no filters:** Confirm row count makes sense.
- [ ] **Step 2 — Add one join:** Verify row count before and after; investigate unexpected changes.
- [ ] **Step 3 — Apply WHERE filters:** Re-check row count against a known benchmark.
- [ ] **Step 4 — Add aggregations and GROUP BY:** Spot-check individual group totals manually.
- [ ] **Step 5 — Add remaining joins and filters:** Full query, validated end to end.

---

## Section 8 — Validation Benchmarks

Before declaring results final, define at least two sanity checks.

| Benchmark | Expected Value | Actual Value | Pass? |
|---|---|---|---|
| Total row count from source table | | | |
| Known total (e.g., annual revenue from report) | | | |
| Spot-check single record by ID | | | |

---

## Section 9 — Query Documentation Block

Paste this comment block at the top of your finished `.sql` file.

```sql
-- ============================================================
-- Query:       [Short descriptive name]
-- Author:      [Your name]
-- Date:        [YYYY-MM-DD]
-- Request:     [Paste raw stakeholder request from Section 1]
-- Question:    [Paste restated analytical question from Section 2]
-- Tables used: [Comma-separated list]
-- Validated:   [Yes / No — benchmark used]
-- Notes:       [Known limitations, assumptions, or caveats]
-- ============================================================
```

---

*Complete this worksheet for every non-trivial query. The habit of planning before coding — not the query itself — is what separates reproducible analytical work from one-time guesswork.*
