# Stakeholder Clarifying Questions Playbook

*Companion to Chapter 13 and Chapter 16 — The Science of Learning SQL*

---

## Why Clarifying Questions Come First

Vague business requests are the **normal starting point** of analytical work, not a communication failure to fix. As Chapter 13 establishes, translating a fuzzy stakeholder question into executable SQL requires a repeatable decomposition framework applied *before* you open a query editor. This playbook gives you that framework in the form of ready-to-use questions you can ask in any stakeholder meeting, Slack thread, or email exchange.

Asking the right questions up front prevents you from building the wrong query — and from validating outputs against a benchmark that nobody actually agreed on.

---

## The Five Clarifying Question Categories

Use these categories as a mental checklist. You do not need to ask every question every time; use judgment to identify which categories are most ambiguous for the request in front of you.

### 1. Scope & Population
*Who or what should be included in this analysis?*

- Are we looking at all customers, or only active ones? How is "active" defined?
- Should the results include internal test accounts, demo users, or employees?
- Is this analysis for a specific region, product line, or business unit?
- Are there any records we should explicitly exclude, and why?

### 2. Time Window & Grain
*What period does this cover, and at what level of detail?*

- What date range should I use — calendar year, fiscal year, or rolling window?
- Should dates be based on when a record was created, updated, or completed?
- Do you need results aggregated by day, week, month, or quarter?
- If a customer appears multiple times in the window, should I count each event or deduplicate?

### 3. Metric Definitions
*What exactly are we measuring, and how is it calculated?*

- When you say "revenue," do you mean gross sales, net of refunds, or recognized revenue?
- Does "active user" mean logged in at least once, or performed a specific action?
- Should I count distinct customers or total transactions?
- Are there any edge cases — partial refunds, pending orders, free trials — that should be handled a specific way?

### 4. Output Format & Delivery
*What does a useful answer actually look like for you?*

- Do you need a single summary number, a breakdown by category, or a row-level export?
- Will this go into a dashboard, a slide deck, or a spreadsheet?
- Who else will see these results, and do they need to interpret the query logic themselves?
- Is this a one-time pull or something that will be refreshed regularly?

### 5. Priority & Deadline
*How urgent is this, and what trade-offs are acceptable?*

- When do you need a first pass — is a directional estimate useful, or does it need to be exact?
- If I have to choose between speed and completeness, which matters more right now?
- Is there a known benchmark or prior report I should reconcile my numbers against?

---

## Quick-Reference Question Matrix

| Category | Core Risk If Skipped | Example Clarifying Question |
|---|---|---|
| Scope & Population | Wrong rows included or excluded | "Should test accounts be excluded?" |
| Time Window & Grain | Mismatched date logic | "Is this calendar year or fiscal year?" |
| Metric Definitions | Calculating the wrong number | "Net revenue or gross revenue?" |
| Output Format | Delivering an unusable result | "Is this for a dashboard or a one-time export?" |
| Priority & Deadline | Over-engineering a quick question | "Do you need exact figures or a directional estimate?" |

---

## How to Use This in Practice

**Before the meeting:** Skim the request and flag every word that could mean two different things. "Recent," "active," "top," and "revenue" are common culprits.

**During the meeting:** Work through the five categories above. Take notes in plain language — these become the comments you embed in your query later, as Chapter 13's documentation guidance recommends.

**After the meeting:** Write one sentence summarizing what you are building and send it back to the stakeholder before writing a line of SQL. This surfaces misunderstandings cheaply.

**When you deliver results:** Reference the agreed-upon definitions explicitly. "This shows net revenue for active customers in the 2023 fiscal year, excluding test accounts" is a complete answer. A bare number is not.

---

## Interview Application

Chapter 16 identifies stakeholder communication as one of the five recurring SQL interview question types. When an interviewer asks *"Tell me about a time you worked with a messy or unclear request,"* walk them through this framework: you identified ambiguity, asked targeted clarifying questions, documented the agreed definitions, and validated your output against a known benchmark. That answer demonstrates exactly the professional habits production SQL environments require.

---

*Cross-reference: Chapter 13 — Translating Stakeholder Requests Into Precise Analytical Questions | Chapter 16 — Working With Business Stakeholders: Asking the Right Clarifying Questions*
