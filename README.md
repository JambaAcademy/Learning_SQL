# The Science of Learning SQL: An Evidence-Based, Step-by-Step Guide to Mastering Databases, Queries, Joins, and Real-World Data Analysis for Complete Beginners
### Code Examples, Datasets & Environment Setup

![Genre](https://img.shields.io/badge/Genre-Technical-blue) ![Chapters](https://img.shields.io/badge/Chapters-16-lightgrey) ![License](https://img.shields.io/badge/License-MIT-yellow)

This companion repository provides all the SQL scripts, sample datasets, and practice exercises referenced throughout *The Science of Learning SQL*, giving you a ready-made environment so you can focus on understanding concepts rather than setting up files from scratch. Each folder corresponds to a chapter in the book, from the foundational principles of cognitive science and database architecture covered in the early chapters to the practical query-building skills introduced through SELECT, WHERE, sorting, and aggregate functions. Having working code alongside the text means you can run every example immediately, experiment with variations, and observe the results in real time — a practice-first approach that aligns directly with the evidence-based learning methods the book advocates. You will also find guided exercises with solutions that reinforce each chapter's material, helping you build genuine retention rather than passive familiarity. Whether you are setting up your first database or working through GROUP BY aggregations for business analysis, this repository is designed to be your hands-on partner at every step of the journey.

---

## Table of Contents

1. [About This Repository](#about-this-repository)
2. [About the Book](#about-the-book)
3. [How to Use This Repository](#how-to-use-this-repository)
4. [Repository Map](#repository-map)
5. [Getting Started](#getting-started)
6. [Chapter-by-Chapter Guide](#chapter-by-chapter-guide)
   - [Chapter 1: Why Your Brain Learns SQL Better With a System — The Cognitive Science Behind Technical Skill Acquisition](#chapter-1)
   - [Chapter 2: The Architecture of a Relational Database — Tables, Rows, Columns, and the Logic Behind the Structure](#chapter-2)
   - [Chapter 3: Your First SELECT Statement — Asking Questions of a Database in Plain English](#chapter-3)
   - [Chapter 4: Filtering Rows With WHERE — Retrieving Only the Data You Actually Need](#chapter-4)
   - [Chapter 5: Sorting and Limiting Results — Controlling What You See and in What Order](#chapter-5)
   - [Chapter 6: Aggregate Functions and GROUP BY — Turning Raw Rows Into Business Insights](#chapter-6)
   - [Chapter 7: Joins Demystified — Combining Data From Multiple Tables Without Losing Your Mind](#chapter-7)
   - [Chapter 8: Advanced Filtering With Subqueries — Queries Inside Queries](#chapter-8)
   - [Chapter 9: Common Table Expressions — Writing SQL That Humans Can Actually Read](#chapter-9)
   - [Chapter 10: String, Date, and Numeric Functions — Cleaning and Transforming Real-World Data](#chapter-10)
   - [Chapter 11: Window Functions — Analytical Power Without Collapsing Your Rows](#chapter-11)
   - [Chapter 12: Database Design and Data Modelling — Understanding the Structure Behind the Queries You Write](#chapter-12)
   - [Chapter 13: Writing Queries for Real Business Questions — From Vague Request to Executable SQL](#chapter-13)
   - [Chapter 14: Data Quality and Cleaning in SQL — Identifying and Fixing Dirty Data at the Source](#chapter-14)
   - [Chapter 15: Performance and Optimisation — Writing SQL That Doesn't Bring a Database to Its Knees](#chapter-15)
   - [Chapter 16: From Learner to Practitioner — Building a Portfolio, Passing Interviews, and Working With Data Professionally](#chapter-16)
7. [Key Topics Covered](#key-topics-covered)
8. [Contributing](#contributing)
9. [License](#license)

---

## About This Repository

Official companion repository for **"The Science of Learning SQL: An Evidence-Based, Step-by-Step Guide to Mastering Databases, Queries, Joins, and Real-World Data Analysis for Complete Beginners"** — 16 chapters · 100 sections.

This repository is designed to be used **alongside the book, not instead of it**.
Every file in this repo maps to at least one chapter. The
[Chapter-by-Chapter Guide](#chapter-by-chapter-guide) below links every chapter
to its exact companion files, the learning points it covers, and the section
headings it contains — so you always know where you are and what to open next.

**Everything in this repository:**

- **`code-scripts/`** — Working code stubs for every chapter (one sub-folder, one `main.*` file, one `README.md` per chapter)
- **`config-setup/`** — `requirements.txt`, `pyproject.toml`, `package.json`, `Dockerfile`, `.env.example`
- **`datasets/`** — Sample CSV dataset; add chapter-specific data as you progress
- **`assets/`** — Every figure and diagram from the book at print resolution
- **`docs/`** — Cheat sheets, errata corrections, and supplementary reading
- **`GLOSSARY.md`** — Full book glossary, auto-generated from book content
- **`REFERENCES.md`** — Complete bibliography, auto-generated from book content
- **`pyproject.toml`** — Python package manifest; `pip install -e .` installs all deps
- **`.github/workflows/ci.yml`** — CI pipeline: tests + lint run on every push
- **`CONTRIBUTING.md`** — How to submit corrections, improvements, or extra examples

---

## About the Book

**"The Science of Learning SQL: An Evidence-Based, Step-by-Step Guide to Mastering Databases, Queries, Joins, and Real-World Data Analysis for Complete Beginners"** is a technical book spanning 16 chapters · 100 sections.
**Topics covered include:** # SEO Keywords: The Science of Learning SQL, ## Critical (25), SQL for beginners, learn SQL from scratch, SQL tutorial for beginners, SQL for data analysts, SQL for complete beginners, SQL queries explained, SQL step by step guide, SQL for career changers, SQL for business analysts, SQL for data analysis, relational database for beginners, SQL beginner book, SQL self-study guide, SQL fundamentals, learn SQL fast, SQL for non-programmers, SQL for marketing professionals, SQL database tutorial, SQL for job seekers, SQL skills for data jobs, SQL for working professionals, SQL for recent graduates, SQL certification preparation, SQL for data-driven decisions, SQL beginner to advanced, ---, ## High Priority (25)…



Each chapter builds on the last. The companion materials in this repository
mirror that structure — each chapter folder contains stub files pre-labelled
with the book's section headings so you can implement examples in sequence
as you read.

---

## How to Use This Repository

Use this repository **actively**, not passively. The code stubs are intentionally incomplete —
they are an invitation to practise, not a reference to copy.

### Recommended Per-Chapter Workflow

| Step | Action | Where |
|------|--------|-------|
| 1 | Read the full chapter — understand concepts before touching code | Book |
| 2 | Open the chapter folder and read its `README.md` | `code-scripts/chapter-XX/README.md` |
| 3 | Study the `# TODO` comments — each one maps to a section heading in the book | `main.*` |
| 4 | Implement each section using the book's examples as a guide | `main.*` |
| 5 | Run your code and test edge cases | Terminal |
| 6 | Extend beyond the stub — change parameters, swap datasets, experiment | `main.*` |
| 7 | Add `test_main.py` to your chapter folder; the CI workflow picks it up on push | `code-scripts/chapter-XX/test_main.py` |

### Understanding the `# TODO` Pattern

Every chapter stub has `# TODO` comments that map 1-to-1 with the book's section headings:

```python
def main():
    # TODO: Section 1 — Data Loading and Cleaning
    # TODO: Section 2 — Feature Engineering
    # TODO: Section 3 — Model Training
    # TODO: Section 4 — Evaluation and Interpretation
    print("Chapter complete")
```

Implement each block after you finish reading that section in the book.

### Parallel Reference Files

Keep these open alongside the book as you read:

- **`GLOSSARY.md`** — look up any unfamiliar term immediately; don't wait until the end of the chapter
- **`datasets/sample_data.csv`** — load this early; many examples reference it directly
- **`assets/`** — higher-resolution versions of every figure printed in the book

### Running CI Locally

The `.github/workflows/ci.yml` runs on every GitHub push. To replicate it locally before pushing:

```bash
pip install pytest flake8
pytest code-scripts/ -v --tb=short
flake8 code-scripts/ --max-line-length=100
```


---

## Repository Map

```
github_repo/
├── .github/
│   └── workflows/
│       └── ci.yml
├── 01_Learning_System_and_Cognitive_Tools/
│   ├── 12-Week_SQL_Learning_Roadmap_and_Schedule.csv
│   ├── 12-Week_SQL_Learning_Roadmap_and_Schedule.xlsx
│   ├── Active_Recall_Self-Quiz_Bank.md
│   ├── Active_Recall_Self-Quiz_Bank.pdf
│   ├── SQL_Knowledge_Retention_Tracker.csv
│   ├── SQL_Knowledge_Retention_Tracker.xlsx
│   ├── SQL_Spaced_Repetition_Flashcard_Deck.md
│   ├── SQL_Spaced_Repetition_Flashcard_Deck.pdf
│   ├── progressive_skill_layering_dependency_map.png
│   └── progressive_skill_layering_dependency_map.svg
├── 02_Database_Architecture_and_Schema_References/
│   ├── Data_Dictionary_Template.csv
│   ├── Data_Dictionary_Template.xlsx
│   ├── Normalisation_Worked_Example_1NF_to_3NF.md
│   ├── Normalisation_Worked_Example_1NF_to_3NF.pdf
│   ├── Primary_and_Foreign_Key_Relationship_Cheat_Sheet.md
│   ├── Primary_and_Foreign_Key_Relationship_Cheat_Sheet.pdf
│   ├── Relational_Database_Concept_Reference_Card.md
│   ├── Relational_Database_Concept_Reference_Card.pdf
│   ├── sample_business_database_schema_diagram.png
│   ├── sample_business_database_schema_diagram.svg
│   ├── star_schema_vs_snowflake_schema_comparison_diagram.png
│   └── star_schema_vs_snowflake_schema_comparison_diagram.svg
├── 03_Practice_Datasets/
│   ├── dirty_data_cleaning_dataset.csv
│   ├── e_commerce_time_series_sales_dataset.csv
│   ├── employee_and_department_hr_dataset.csv
│   ├── organisational_hierarchy_dataset.csv
│   └── retail_orders_practice_dataset.csv
├── 04_SQL_Script_Library/
│   ├── chapter_10_data_transformation_function_scripts.sql
│   ├── chapter_11_window_function_scripts.sql
│   ├── chapter_14_data_quality_audit_scripts.sql
│   ├── chapter_3_5_foundational_query_scripts.sql
│   ├── chapter_6_aggregation_and_group_by_scripts.sql
│   ├── chapter_7_join_type_demonstration_scripts.sql
│   ├── chapter_8_subquery_pattern_scripts.sql
│   └── chapter_9_cte_and_recursive_cte_scripts.sql
├── 05_Syntax_References_and_Cheat_Sheets/
│   ├── Aggregate_vs_Window_Function_Comparison_Reference.md
│   ├── Aggregate_vs_Window_Function_Comparison_Reference.pdf
│   ├── SQL_Syntax_Master_Cheat_Sheet.md
│   ├── SQL_Syntax_Master_Cheat_Sheet.pdf
│   ├── String_Date_and_Numeric_Function_Quick_Reference.md
│   ├── String_Date_and_Numeric_Function_Quick_Reference.pdf
│   ├── join_type_visual_reference_card.png
│   ├── join_type_visual_reference_card.svg
│   ├── sql_logical_execution_order_vs_written_order_diagram.png
│   └── sql_logical_execution_order_vs_written_order_diagram.svg
├── 06_Exercises_and_Assessments/
│   ├── Chapter-by-Chapter_Exercise_Workbook.md
│   ├── Chapter-by-Chapter_Exercise_Workbook.pdf
│   ├── Data_Quality_Audit_Exercise_Workbook.md
│   ├── Real_Business_Question_Translation_Exercises.md
│   ├── SQL_Skills_Diagnostic_Assessment.md
│   ├── SQL_Skills_Diagnostic_Assessment.pdf
│   ├── end_of_book_cumulative_capstone_challenge.sql
│   └── joins_challenge_exercise_set.sql
├── 07_Query_Planning_and_Workflow_Templates/
│   ├── Iterative_Query_Build_Log_Template.csv
│   ├── Iterative_Query_Build_Log_Template.xlsx
│   ├── Query_Documentation_and_Comment_Standards_Guide.md
│   ├── Query_Planning_Worksheet.md
│   ├── Results_Validation_Sanity-Check_Checklist.csv
│   ├── Results_Validation_Sanity-Check_Checklist.xlsx
│   └── Stakeholder_Request_Decomposition_Framework.md
├── 08_Data_Quality_and_Cleaning_Toolkit/
│   ├── Data_Quality_Issue_Log_Template.csv
│   ├── Data_Quality_Issue_Log_Template.xlsx
│   ├── category_standardisation_case_when_script.sql
│   ├── data_quality_audit_sql_script_library.sql
│   ├── duplicate_detection_and_deduplication_script.sql
│   └── referential_integrity_audit_script.sql
├── 09_Performance_and_Optimisation_Guides/
│   ├── Execution_Plan_Reading_Walkthrough.md
│   ├── Query_Optimisation_Principles_Reference_Guide.md
│   ├── SQL_Performance_Anti-Patterns_Cheat_Sheet.md
│   ├── indexing_strategy_decision_guide.png
│   └── indexing_strategy_decision_guide.svg
├── 10_Career_and_Portfolio_Resources/
│   ├── Five_SQL_Interview_Question_Types_Preparation_Guide.md
│   ├── SQL_Portfolio_Project_Template_and_Guide.md
│   ├── SQL_Skills_Self-Assessment_and_Career_Readiness_Tracker.csv
│   ├── SQL_Skills_Self-Assessment_and_Career_Readiness_Tracker.xlsx
│   ├── Stakeholder_Clarifying_Questions_Playbook.md
│   ├── Tutorial_SQL_vs_Production_SQL_Gap_Analysis_Guide.md
│   ├── portfolio_project_interactive_showcase_page.html
│   └── sql_interview_practice_question_bank.sql
├── assets/
│   └── README.md
├── code-scripts/
│   ├── chapter-01/
│   │   └── main.py
│   ├── chapter-02/
│   │   └── main.py
│   ├── chapter-03/
│   │   └── main.py
│   ├── chapter-04/
│   │   └── main.py
│   ├── chapter-05/
│   │   └── main.py
│   ├── chapter-06/
│   │   └── main.py
│   ├── chapter-07/
│   │   └── main.py
│   ├── chapter-08/
│   │   └── main.py
│   ├── chapter-09/
│   │   └── main.py
│   ├── chapter-10/
│   │   └── main.py
│   ├── chapter-11/
│   │   └── main.py
│   ├── chapter-12/
│   │   └── main.py
│   ├── chapter-13/
│   │   └── main.py
│   ├── chapter-14/
│   │   └── main.py
│   ├── chapter-15/
│   │   └── main.py
│   └── chapter-16/
│       └── main.py
├── docs/
│   ├── README.md
│   └── mind-map.md
├── CONTRIBUTING.md
├── GLOSSARY.md
├── LICENSE
├── PROGRESS.md
├── RESOURCES_INDEX.md
├── book-mockup.png
└── study-guide.md
```

### Folder & File Reference

| Path | Contents | Best used |
|------|----------|-----------|
| `code-scripts/` | Chapter code stubs — one sub-folder per chapter with a `main.*` file and `README.md` | Open while reading each chapter |
| `config-setup/` | `requirements.txt`, `pyproject.toml`, `package.json`, `Dockerfile`, `.env.example` | One-time environment setup |
| `datasets/` | Sample CSV dataset for hands-on exercises; add chapter-specific files as `chapter-XX-<desc>.csv` | During data-heavy chapters |
| `assets/` | High-resolution figures, diagrams, and charts from the book (print-quality) | Reference alongside the text |
| `docs/` | Cheat sheets, errata corrections, `mind-map.md` (book structure diagram), and supplementary reading | After finishing each chapter |
| `GLOSSARY.md` | Complete book glossary — auto-generated from the book's back matter | Quick term lookup while reading |
| `REFERENCES.md` | Full bibliography and citation list from the book | Source verification and further research |
| `study-guide.md` | Per-chapter comprehension Q&A, discussion prompts, and 'Test Yourself' checklists | After reading each chapter |
| `PROGRESS.md` | Reading progress checklist — tick each chapter as you finish it | Throughout reading |
| `pyproject.toml` | Python package manifest — run `pip install -e .` from the repo root to install all dependencies | One-time Python setup |
| `CONTRIBUTING.md` | Full guide for submitting corrections, improvements, or extra examples | When you spot an error or want to contribute |
| `.github/` | GitHub Actions CI workflow — automatically runs tests and linting on every push | After you add your own tests |
| `README.md` | This file — the master guide to the entire companion repository | Orientation and navigation |


---

## Getting Started

### Prerequisites

- Python 3.10 or newer (3.11 / 3.12 recommended)
- Node.js 18+ (for JavaScript/TypeScript chapters)
- Docker (optional — for containerised environments)

### Set Up the Python Environment

```bash
# 1. Clone or download this repository
git clone <your-repo-url>
cd github_repo

# 2. Create and activate a virtual environment
python -m venv .venv
source .venv/bin/activate        # macOS / Linux
.venv\Scripts\activate          # Windows

# 3. Install all dependencies
pip install -r config-setup/requirements.txt

# 4. Verify
python --version && pip list
```

### Set Up the Node.js Environment *(if applicable)*

```bash
cd config-setup
npm install
```

### Run Chapter Examples

```bash
cd code-scripts/chapter-01
python main.py
```

### Run in Docker

```bash
docker build -t book-companion .
docker run book-companion
```

---

## Chapter-by-Chapter Guide

Each chapter in the book has dedicated companion materials in this repository. Use this guide to navigate both in parallel — every section below tells you exactly what the chapter covers, which sections it contains, and which files in this repository correspond to it.

<a name="chapter-1"></a>

---

### Chapter 1: Why Your Brain Learns SQL Better With a System — The Cognitive Science Behind Technical Skill Acquisition

**What you will learn in this chapter:**

- Passive exposure to SQL syntax creates only temporary familiarity, not durable skill, because the forgetting curve erases unreinforced learning within days.
- Spaced repetition and active recall build lasting SQL fluency by forcing your brain to reconstruct knowledge rather than simply recognise it.
- Progressive skill layering ensures every new SQL concept rests on a foundation your brain has already consolidated, preventing cognitive overload.
- Configuring a structured learning system before writing your first query transforms SQL acquisition from frustrating repetition into measurable, compounding progress.

<details>
<summary><strong>Sections covered in this chapter</strong> (expand to see all headings)</summary>

1. The Forgetting Curve and Why Most SQL Tutorials Fail You
2. How Spaced Repetition Rewires Technical Memory
3. Active Recall vs. Passive Reading: What the Research Says
4. Progressive Skill Layering: Building SQL Knowledge Like a Pyramid

</details>

**Companion resources in this repository:**

| Resource | Path | What it contains |
|----------|------|------------------|
| Code stub | [`code-scripts/chapter-01/`](code-scripts/chapter-01/) | Runnable skeleton with one `# TODO` comment per section heading |
| Chapter guide | [`code-scripts/chapter-01/README.md`](code-scripts/chapter-01/README.md) | Run instructions, file descriptions, and expected output |
| Section TODOs | Inside `main.*` | 4 TODO marker(s) — one per section heading listed above |

> **Key takeaway:** Passive exposure to SQL syntax creates only temporary familiarity, not durable skill, because the forgetting curve erases unreinforced learning within days.

<a name="chapter-2"></a>

---

### Chapter 2: The Architecture of a Relational Database — Tables, Rows, Columns, and the Logic Behind the Structure

**What you will learn in this chapter:**

- A relational database organises data into separate, interconnected tables rather than one flat, sprawling spreadsheet.
- Each row in a table represents one complete, individual record, while each column enforces a specific data type.
- Primary keys uniquely identify every row, preventing duplicate records and giving each entry a reliable, permanent address.
- Foreign keys link tables together, creating the relationships that make cross-table queries and real-world analysis possible.

<details>
<summary><strong>Sections covered in this chapter</strong> (expand to see all headings)</summary>

1. Why Data Lives in Tables: The Filing Cabinet Analogy
2. Rows, Records, and What a Single Unit of Data Actually Means
3. Columns, Fields, and the Anatomy of a Data Type
4. How Tables Relate to Each Other: The Core Idea Behind Relational Databases

</details>

**Companion resources in this repository:**

| Resource | Path | What it contains |
|----------|------|------------------|
| Code stub | [`code-scripts/chapter-02/`](code-scripts/chapter-02/) | Runnable skeleton with one `# TODO` comment per section heading |
| Chapter guide | [`code-scripts/chapter-02/README.md`](code-scripts/chapter-02/README.md) | Run instructions, file descriptions, and expected output |
| Section TODOs | Inside `main.*` | 4 TODO marker(s) — one per section heading listed above |

> **Key takeaway:** A relational database organises data into separate, interconnected tables rather than one flat, sprawling spreadsheet.

<a name="chapter-3"></a>

---

### Chapter 3: Your First SELECT Statement — Asking Questions of a Database in Plain English

**What you will learn in this chapter:**

- The SELECT statement is SQL's core retrieval tool, translating plain-English business questions into structured instructions a database understands.
- Controlling which columns appear in your results — rather than retrieving everything — keeps queries efficient and outputs immediately readable.
- Duplicate rows and unclear column labels are solvable with DISTINCT and aliases, giving your results professional clarity without changing underlying data.
- SQL error messages are precise diagnostic feedback, not failures — reading them carefully tells you exactly what the database needs corrected.

<details>
<summary><strong>Sections covered in this chapter</strong> (expand to see all headings)</summary>

1. What a Query Actually Is: Translating Business Questions Into SQL
2. The Anatomy of a SELECT Statement: Keywords, Clauses, and Syntax Rules
3. Selecting Specific Columns vs. Selecting Everything With the Asterisk
4. Writing Your First Query and Reading the Output Table
5. Aliasing Columns: Giving Your Results Readable Names With AS
6. Eliminating Duplicates With DISTINCT

</details>

**Companion resources in this repository:**

| Resource | Path | What it contains |
|----------|------|------------------|
| Code stub | [`code-scripts/chapter-03/`](code-scripts/chapter-03/) | Runnable skeleton with one `# TODO` comment per section heading |
| Chapter guide | [`code-scripts/chapter-03/README.md`](code-scripts/chapter-03/README.md) | Run instructions, file descriptions, and expected output |
| Section TODOs | Inside `main.*` | 6 TODO marker(s) — one per section heading listed above |

> **Key takeaway:** The SELECT statement is SQL's core retrieval tool, translating plain-English business questions into structured instructions a database understands.

<a name="chapter-4"></a>

---

### Chapter 4: Filtering Rows With WHERE — Retrieving Only the Data You Actually Need

**What you will learn in this chapter:**

- The WHERE clause filters rows before results are returned, making it the most frequently used tool in professional SQL workflows.
- Comparison operators like =, >, and < let you write precise conditions that retrieve exactly the rows your question demands.
- Logical operators AND and OR allow you to combine multiple filtering conditions, giving a single query the power to answer complex business questions.
- NULL values require special handling using IS NULL syntax because standard comparison operators cannot detect the absence of data.

<details>
<summary><strong>Sections covered in this chapter</strong> (expand to see all headings)</summary>

1. Why Filtering Is the Most Frequently Used Skill in Real Analyst Work
2. Comparison Operators: Equal, Not Equal, Greater Than, Less Than
3. Filtering Text With Exact Matches and Case Sensitivity Traps
4. Filtering Numbers and Dates: Ranges, Boundaries, and Edge Cases
5. Combining Conditions With AND, OR, and NOT
6. Pattern Matching With LIKE and Wildcard Characters

</details>

**Companion resources in this repository:**

| Resource | Path | What it contains |
|----------|------|------------------|
| Code stub | [`code-scripts/chapter-04/`](code-scripts/chapter-04/) | Runnable skeleton with one `# TODO` comment per section heading |
| Chapter guide | [`code-scripts/chapter-04/README.md`](code-scripts/chapter-04/README.md) | Run instructions, file descriptions, and expected output |
| Section TODOs | Inside `main.*` | 6 TODO marker(s) — one per section heading listed above |

> **Key takeaway:** The WHERE clause filters rows before results are returned, making it the most frequently used tool in professional SQL workflows.

<a name="chapter-5"></a>

---

### Chapter 5: Sorting and Limiting Results — Controlling What You See and in What Order

**What you will learn in this chapter:**

- `ORDER BY` and `LIMIT` transform raw, unordered query results into precisely shaped answers that directly serve real business decisions.
- SQL's written clause order differs from its logical execution order, a distinction that confuses beginners and experienced developers alike.
- Sorting by multiple columns lets you control result sequence with precision when a single column produces ties or ambiguity.
- Combining `ORDER BY`, `LIMIT`, and `WHERE` in one statement lets you filter, rank, and cap results within a single coherent query.

<details>
<summary><strong>Sections covered in this chapter</strong> (expand to see all headings)</summary>

1. Why Output Order Matters in Business Reporting
2. Sorting Results With ORDER BY: Ascending and Descending Logic
3. Sorting by Multiple Columns and Understanding Sort Priority
4. Limiting Output With LIMIT and OFFSET for Pagination
5. Combining WHERE and ORDER BY in a Single Query
6. The Logical Order of SQL Clauses vs. the Written Order: A Critical Distinction
7. Practical Exercise: Building a Top-Ten Customer Report From Scratch
8. Chapter Review: Key Terms, Active Recall Questions, and Mini-Challenge

</details>

**Companion resources in this repository:**

| Resource | Path | What it contains |
|----------|------|------------------|
| Code stub | [`code-scripts/chapter-05/`](code-scripts/chapter-05/) | Runnable skeleton with one `# TODO` comment per section heading |
| Chapter guide | [`code-scripts/chapter-05/README.md`](code-scripts/chapter-05/README.md) | Run instructions, file descriptions, and expected output |
| Section TODOs | Inside `main.*` | 8 TODO marker(s) — one per section heading listed above |

> **Key takeaway:** `ORDER BY` and `LIMIT` transform raw, unordered query results into precisely shaped answers that directly serve real business decisions.

<a name="chapter-6"></a>

---

### Chapter 6: Aggregate Functions and GROUP BY — Turning Raw Rows Into Business Insights

**What you will learn in this chapter:**

- Aggregate functions like COUNT, SUM, AVG, MIN, and MAX collapse thousands of raw rows into single, meaningful business metrics.
- GROUP BY segments aggregated results by category, region, or time period, enabling precise, slice-level data analysis.
- The WHERE clause filters individual rows before aggregation, while HAVING filters aggregated results after grouping occurs.
- Mastering aggregation transforms you from someone who retrieves data into someone who genuinely analyses and interprets it.

<details>
<summary><strong>Sections covered in this chapter</strong> (expand to see all headings)</summary>

1. What Aggregation Means: Collapsing Many Rows Into One Meaningful Number
2. The Five Core Aggregate Functions: COUNT, SUM, AVG, MIN, MAX
3. Grouping Data With GROUP BY: Segmenting Results by Category
4. The Difference Between WHERE and HAVING: Filtering Before and After Aggregation
5. Counting Nulls vs. Counting Values: A Trap Every Beginner Falls Into
6. Combining Aggregates With Aliases for Readable Analytical Output
7. Real-World Exercise: Monthly Revenue Summary by Product Category
8. Chapter Review: Key Terms, Active Recall Questions, and Mini-Challenge

</details>

**Companion resources in this repository:**

| Resource | Path | What it contains |
|----------|------|------------------|
| Code stub | [`code-scripts/chapter-06/`](code-scripts/chapter-06/) | Runnable skeleton with one `# TODO` comment per section heading |
| Chapter guide | [`code-scripts/chapter-06/README.md`](code-scripts/chapter-06/README.md) | Run instructions, file descriptions, and expected output |
| Section TODOs | Inside `main.*` | 8 TODO marker(s) — one per section heading listed above |

> **Key takeaway:** Aggregate functions like COUNT, SUM, AVG, MIN, and MAX collapse thousands of raw rows into single, meaningful business metrics.

<a name="chapter-7"></a>

---

### Chapter 7: Joins Demystified — Combining Data From Multiple Tables Without Losing Your Mind

**What you will learn in this chapter:**

- A JOIN combines rows from multiple tables temporarily using shared keys, leaving the original tables completely untouched.
- INNER, LEFT, RIGHT, and FULL OUTER JOINs each serve distinct analytical purposes depending on which unmatched rows you need.
- Relational databases deliberately split data across tables to eliminate redundancy, making joins essential rather than optional for real analysis.
- A missing or incorrect JOIN condition creates a Cartesian product, multiplying rows uncontrollably and silently corrupting your query results.

<details>
<summary><strong>Sections covered in this chapter</strong> (expand to see all headings)</summary>

1. Why Joins Exist: The Problem With Storing Everything in One Table
2. The Concept of a Join: Matching Rows Across Tables on a Shared Key
3. INNER JOIN: Returning Only the Rows That Match on Both Sides
4. LEFT JOIN: Keeping All Rows From the Left Table Regardless of Matches
5. RIGHT JOIN and FULL OUTER JOIN: Completing the Picture
6. Joining More Than Two Tables: Chaining Joins in a Single Query

</details>

**Companion resources in this repository:**

| Resource | Path | What it contains |
|----------|------|------------------|
| Code stub | [`code-scripts/chapter-07/`](code-scripts/chapter-07/) | Runnable skeleton with one `# TODO` comment per section heading |
| Chapter guide | [`code-scripts/chapter-07/README.md`](code-scripts/chapter-07/README.md) | Run instructions, file descriptions, and expected output |
| Section TODOs | Inside `main.*` | 6 TODO marker(s) — one per section heading listed above |

> **Key takeaway:** A JOIN combines rows from multiple tables temporarily using shared keys, leaving the original tables completely untouched.

<a name="chapter-8"></a>

---

### Chapter 8: Advanced Filtering With Subqueries — Queries Inside Queries

**What you will learn in this chapter:**

- A subquery is a complete SELECT statement nested inside another query, executing first to supply a dynamic value to the outer query.
- Subqueries eliminate the fragile practice of hardcoding calculated values, keeping filters accurate even as underlying data changes over time.
- The database engine always resolves the inner query first, making its result available to the outer query exactly like a literal typed value.
- Subqueries enable analysts to filter against averages, identify missing records, and build temporary result sets within a single executable statement.

<details>
<summary><strong>Sections covered in this chapter</strong> (expand to see all headings)</summary>

1. What a Subquery Is and When You Need One Instead of a Join
2. Scalar Subqueries: Returning a Single Value to Filter Against
3. Subqueries in the WHERE Clause With IN and NOT IN
4. Correlated Subqueries: When the Inner Query References the Outer Query
5. Subqueries in the FROM Clause: Creating Temporary Derived Tables
6. Performance Intuition: When Subqueries Slow Things Down and Why
7. Real-World Exercise: Finding Customers Who Have Never Placed an Order
8. Chapter Review: Key Terms, Active Recall Questions, and Mini-Challenge

</details>

**Companion resources in this repository:**

| Resource | Path | What it contains |
|----------|------|------------------|
| Code stub | [`code-scripts/chapter-08/`](code-scripts/chapter-08/) | Runnable skeleton with one `# TODO` comment per section heading |
| Chapter guide | [`code-scripts/chapter-08/README.md`](code-scripts/chapter-08/README.md) | Run instructions, file descriptions, and expected output |
| Section TODOs | Inside `main.*` | 8 TODO marker(s) — one per section heading listed above |

> **Key takeaway:** A subquery is a complete SELECT statement nested inside another query, executing first to supply a dynamic value to the outer query.

<a name="chapter-9"></a>

---

### Chapter 9: Common Table Expressions — Writing SQL That Humans Can Actually Read

**What you will learn in this chapter:**

- A CTE uses the WITH clause to name a logical step, making complex queries readable by replacing nested subqueries with clearly labelled blocks.
- Deeply nested subqueries obscure analytical intent, forcing readers to mentally unwind layers before understanding what question the query answers.
- Multiple CTEs can be chained sequentially, allowing multi-step analyses to be written as discrete, human-readable stages rather than tangled expressions.
- Recursive CTEs extend this structure to hierarchical data, enabling traversal of relationships like organisational charts that flat queries cannot handle.

<details>
<summary><strong>Sections covered in this chapter</strong> (expand to see all headings)</summary>

1. Why Complex Queries Become Unreadable and What CTEs Solve
2. The WITH Clause: Syntax, Structure, and How the Database Processes It
3. Replacing Nested Subqueries With Named CTEs for Clarity
4. Chaining Multiple CTEs Together in a Single Query
5. Recursive CTEs: Traversing Hierarchical Data Like Org Charts and Categories
6. CTEs vs. Subqueries vs. Temporary Tables: Choosing the Right Tool
7. Real-World Exercise: Multi-Step Sales Funnel Analysis Using Chained CTEs
8. Chapter Review: Key Terms, Active Recall Questions, and Mini-Challenge

</details>

**Companion resources in this repository:**

| Resource | Path | What it contains |
|----------|------|------------------|
| Code stub | [`code-scripts/chapter-09/`](code-scripts/chapter-09/) | Runnable skeleton with one `# TODO` comment per section heading |
| Chapter guide | [`code-scripts/chapter-09/README.md`](code-scripts/chapter-09/README.md) | Run instructions, file descriptions, and expected output |
| Section TODOs | Inside `main.*` | 8 TODO marker(s) — one per section heading listed above |

> **Key takeaway:** A CTE uses the WITH clause to name a logical step, making complex queries readable by replacing nested subqueries with clearly labelled blocks.

<a name="chapter-10"></a>

---

### Chapter 10: String, Date, and Numeric Functions — Cleaning and Transforming Real-World Data

**What you will learn in this chapter:**

- SQL's built-in string, date, and numeric functions transform raw, inconsistent data into clean, analysis-ready output without modifying source tables.
- Real-world datasets frequently contain mixed text formats, inconsistent date representations, and imprecise numeric values that block accurate analysis.
- Functions like TRIM, UPPER, LOWER, and ROUND solve formatting inconsistencies directly inside SELECT statements, eliminating the need for spreadsheet preprocessing.
- Mastering transformation functions bridges the gap between textbook-perfect practice data and the genuinely messy datasets working analysts encounter daily.

<details>
<summary><strong>Sections covered in this chapter</strong> (expand to see all headings)</summary>

1. Why Raw Data Is Almost Never Analysis-Ready
2. String Functions: UPPER, LOWER, TRIM, CONCAT, SUBSTRING, and REPLACE
3. Parsing and Formatting Dates With DATEPART, DATEADD, and DATEDIFF
4. Extracting Year, Month, and Day for Time-Series Grouping
5. Numeric Functions: ROUND, FLOOR, CEILING, ABS, and CAST
6. Using CASE WHEN to Create Conditional Columns and Buckets
7. Real-World Exercise: Standardising a Messy Customer Name and Date Dataset
8. Chapter Review: Key Terms, Active Recall Questions, and Mini-Challenge

</details>

**Companion resources in this repository:**

| Resource | Path | What it contains |
|----------|------|------------------|
| Code stub | [`code-scripts/chapter-10/`](code-scripts/chapter-10/) | Runnable skeleton with one `# TODO` comment per section heading |
| Chapter guide | [`code-scripts/chapter-10/README.md`](code-scripts/chapter-10/README.md) | Run instructions, file descriptions, and expected output |
| Section TODOs | Inside `main.*` | 8 TODO marker(s) — one per section heading listed above |

> **Key takeaway:** SQL's built-in string, date, and numeric functions transform raw, inconsistent data into clean, analysis-ready output without modifying source tables.

<a name="chapter-11"></a>

---

### Chapter 11: Window Functions — Analytical Power Without Collapsing Your Rows

**What you will learn in this chapter:**

- Window functions perform aggregate-style calculations across a defined row set while preserving every individual row in the result.
- The OVER clause defines the window — the specific partition and ordering that each calculation runs across.
- Functions like ROW_NUMBER, RANK, LAG, and LEAD enable ranking, sequencing, and row-to-row comparison without collapsing data.
- Knowing instinctively when to reach for window functions instead of GROUP BY distinguishes a working analyst from a beginner.

<details>
<summary><strong>Sections covered in this chapter</strong> (expand to see all headings)</summary>

1. The Problem Window Functions Solve That GROUP BY Cannot
2. The OVER Clause: Defining the Window Frame Your Calculation Runs Across
3. ROW_NUMBER, RANK, and DENSE_RANK: Ranking Rows Within Groups
4. LAG and LEAD: Comparing a Row to the Row Before or After It
5. Running Totals and Moving Averages With SUM and AVG Over a Window
6. PARTITION BY vs. GROUP BY: Understanding the Critical Difference

</details>

**Companion resources in this repository:**

| Resource | Path | What it contains |
|----------|------|------------------|
| Code stub | [`code-scripts/chapter-11/`](code-scripts/chapter-11/) | Runnable skeleton with one `# TODO` comment per section heading |
| Chapter guide | [`code-scripts/chapter-11/README.md`](code-scripts/chapter-11/README.md) | Run instructions, file descriptions, and expected output |
| Section TODOs | Inside `main.*` | 6 TODO marker(s) — one per section heading listed above |

> **Key takeaway:** Window functions perform aggregate-style calculations across a defined row set while preserving every individual row in the result.

<a name="chapter-12"></a>

---

### Chapter 12: Database Design and Data Modelling — Understanding the Structure Behind the Queries You Write

**What you will learn in this chapter:**

- Normalisation splits data into focused tables to eliminate redundancy, protecting accuracy and preventing the update anomalies that corrupt analytical results.
- A schema functions as a database blueprint, connecting tables through primary and foreign keys that define every meaningful JOIN you will ever write.
- Star and snowflake schemas represent the two dominant data warehouse structures, and recognising which one you are querying shapes how you approach analytical reports.
- Indexes control query performance so directly that a single missing one can transform a two-second result into a two-minute bottleneck.

<details>
<summary><strong>Sections covered in this chapter</strong> (expand to see all headings)</summary>

1. Why Analysts Who Understand Schema Design Write Better Queries
2. Normalisation: What It Is, Why It Matters, and the Three Normal Forms
3. Star Schema vs. Snowflake Schema: The Data Warehouse Structures You Will Actually Query
4. Fact Tables and Dimension Tables: The Building Blocks of Analytical Databases
5. Indexes: What They Are and Why They Make Queries Fast or Slow
6. Reading Production Database Documentation and Data Dictionaries
7. Designing a Simple Schema From a Business Requirement: A Worked Example
8. Chapter Review: Key Terms, Active Recall Questions, and Mini-Challenge

</details>

**Companion resources in this repository:**

| Resource | Path | What it contains |
|----------|------|------------------|
| Code stub | [`code-scripts/chapter-12/`](code-scripts/chapter-12/) | Runnable skeleton with one `# TODO` comment per section heading |
| Chapter guide | [`code-scripts/chapter-12/README.md`](code-scripts/chapter-12/README.md) | Run instructions, file descriptions, and expected output |
| Section TODOs | Inside `main.*` | 8 TODO marker(s) — one per section heading listed above |

> **Key takeaway:** Normalisation splits data into focused tables to eliminate redundancy, protecting accuracy and preventing the update anomalies that corrupt analytical results.

<a name="chapter-13"></a>

---

### Chapter 13: Writing Queries for Real Business Questions — From Vague Request to Executable SQL

**What you will learn in this chapter:**

- Vague business requests are the normal starting point of analytical work, not a failure of communication to overcome.
- Translating fuzzy stakeholder questions into precise SQL requires a repeatable decomposition framework applied before touching a keyboard.
- Building queries in deliberate layers — identifying tables, keys, and filters first — produces more reliable and auditable results.
- Validating outputs against known benchmarks and documenting query logic ensures colleagues can trust and reproduce your analytical work.

<details>
<summary><strong>Sections covered in this chapter</strong> (expand to see all headings)</summary>

1. Translating Stakeholder Requests Into Precise Analytical Questions
2. The Query Planning Habit: Sketching Logic Before Writing a Single Line of Code
3. Identifying the Right Tables, Keys, and Joins Before Opening a Query Editor
4. Iterative Query Building: Starting Small and Adding Complexity Gradually
5. Validating Your Results: Sanity-Checking Outputs Against Known Benchmarks
6. Documenting Queries With Comments for Collaboration and Reproducibility

</details>

**Companion resources in this repository:**

| Resource | Path | What it contains |
|----------|------|------------------|
| Code stub | [`code-scripts/chapter-13/`](code-scripts/chapter-13/) | Runnable skeleton with one `# TODO` comment per section heading |
| Chapter guide | [`code-scripts/chapter-13/README.md`](code-scripts/chapter-13/README.md) | Run instructions, file descriptions, and expected output |
| Section TODOs | Inside `main.*` | 6 TODO marker(s) — one per section heading listed above |

> **Key takeaway:** Vague business requests are the normal starting point of analytical work, not a failure of communication to overcome.

<a name="chapter-14"></a>

---

### Chapter 14: Data Quality and Cleaning in SQL — Identifying and Fixing Dirty Data at the Source

**What you will learn in this chapter:**

- Dirty data hides inside structurally normal tables, silently corrupting aggregations, skewing averages, and excluding rows from JOIN results.
- SQL's filtering, string functions, and conditional logic are precise instruments for auditing data quality without leaving your query editor.
- Inconsistent formatting, duplicate records, NULL values, and impossible dates each require targeted detection queries before any fix is applied.
- Trusting your query results requires first interrogating the underlying data systematically, treating quality checks as core analytical work, not preprocessing chores.

<details>
<summary><strong>Sections covered in this chapter</strong> (expand to see all headings)</summary>

1. What Makes Data Dirty and Why It Silently Corrupts Analysis
2. Detecting Nulls, Blanks, and Placeholder Values Across a Dataset
3. Finding and Handling Duplicates With ROW_NUMBER and Deduplication Queries
4. Identifying Outliers and Impossible Values With Statistical Filters
5. Standardising Inconsistent Categories Using CASE WHEN and String Functions
6. Auditing Referential Integrity: Orphaned Records and Broken Foreign Keys

</details>

**Companion resources in this repository:**

| Resource | Path | What it contains |
|----------|------|------------------|
| Code stub | [`code-scripts/chapter-14/`](code-scripts/chapter-14/) | Runnable skeleton with one `# TODO` comment per section heading |
| Chapter guide | [`code-scripts/chapter-14/README.md`](code-scripts/chapter-14/README.md) | Run instructions, file descriptions, and expected output |
| Section TODOs | Inside `main.*` | 6 TODO marker(s) — one per section heading listed above |

> **Key takeaway:** Dirty data hides inside structurally normal tables, silently corrupting aggregations, skewing averages, and excluding rows from JOIN results.

<a name="chapter-15"></a>

---

### Chapter 15: Performance and Optimisation — Writing SQL That Doesn't Bring a Database to Its Knees

**What you will learn in this chapter:**

- Correct query results and query efficiency are separate skills; production databases punish technically right but poorly optimised SQL at scale.
- Indexes act as pre-sorted references that let the database retrieve targeted rows without scanning every record in the table.
- Reading execution plans reveals exactly where a query spends its processing time, enabling precise fixes without guesswork or database administrator support.
- Performance optimisation is a foundational professional skill, not an advanced one, because inefficient habits on small datasets become costly failures in production.

<details>
<summary><strong>Sections covered in this chapter</strong> (expand to see all headings)</summary>

1. Why Query Performance Matters Beyond Just Getting the Right Answer
2. How a Database Engine Executes a Query: The Logical Processing Order
3. Reading and Interpreting an Execution Plan Without Being a DBA
4. Indexing Strategies: Which Columns to Index and Which to Leave Alone

</details>

**Companion resources in this repository:**

| Resource | Path | What it contains |
|----------|------|------------------|
| Code stub | [`code-scripts/chapter-15/`](code-scripts/chapter-15/) | Runnable skeleton with one `# TODO` comment per section heading |
| Chapter guide | [`code-scripts/chapter-15/README.md`](code-scripts/chapter-15/README.md) | Run instructions, file descriptions, and expected output |
| Section TODOs | Inside `main.*` | 4 TODO marker(s) — one per section heading listed above |

> **Key takeaway:** Correct query results and query efficiency are separate skills; production databases punish technically right but poorly optimised SQL at scale.

<a name="chapter-16"></a>

---

### Chapter 16: From Learner to Practitioner — Building a Portfolio, Passing Interviews, and Working With Data Professionally

**What you will learn in this chapter:**

- Building a public portfolio with real datasets proves analytical thinking to employers more convincingly than listing SQL on a resume.
- Production SQL environments contain messy, inconsistent data that tutorials never replicate, so expecting imperfection accelerates professional adaptation.
- Data analyst interviews consistently test five recurring question types, and preparing structured verbal responses to each dramatically improves performance outcomes.
- A twelve-week spaced repetition review schedule deliberately maintains SQL fluency, ensuring hard-won skills compound rather than quietly erode after learning ends.

<details>
<summary><strong>Sections covered in this chapter</strong> (expand to see all headings)</summary>

1. The Gap Between Tutorial SQL and Production SQL: What Changes on the Job
2. Building a Public SQL Portfolio With Real Datasets and Documented Analysis
3. The Five SQL Interview Question Types and How to Approach Each One
4. Working With Business Stakeholders: Asking the Right Clarifying Questions

</details>

**Companion resources in this repository:**

| Resource | Path | What it contains |
|----------|------|------------------|
| Code stub | [`code-scripts/chapter-16/`](code-scripts/chapter-16/) | Runnable skeleton with one `# TODO` comment per section heading |
| Chapter guide | [`code-scripts/chapter-16/README.md`](code-scripts/chapter-16/README.md) | Run instructions, file descriptions, and expected output |
| Section TODOs | Inside `main.*` | 4 TODO marker(s) — one per section heading listed above |

> **Key takeaway:** Building a public portfolio with real datasets proves analytical thinking to employers more convincingly than listing SQL on a resume.

---


## Key Topics Covered

The following topics and terms are explored in depth throughout the book and defined in full in [`GLOSSARY.md`](GLOSSARY.md).

# SEO Keywords: The Science of Learning SQL

## Critical (25)

SQL for beginners, learn SQL from scratch, SQL tutorial for beginners, SQL for data analysts, SQL for complete beginners, SQL queries explained, SQL step by step guide, SQL for career changers, SQL for business analysts, SQL for data analysis, relational database for beginners, SQL beginner book, SQL self-study guide, SQL fundamentals, learn SQL fast, SQL for non-programmers, SQL for marketing professionals, SQL database tutorial, SQL for job seekers, SQL skills for data jobs, SQL for working professionals, SQL for recent graduates, SQL certification preparation, SQL for data-driven decisions, SQL beginner to advanced

---

## High Priority (25)

SELECT statement tutorial, JOIN clause explained, SQL WHERE clause, SQL data filtering, SQL aggregate functions, primary key and foreign key, SQL subquery tutorial, common table expression CTE, window functions SQL, SQL GROUP BY explained, SQL ORDER BY tutorial, SQL HAVING clause, SQL inner join outer join, SQL left join right join, SQL for business intelligence, SQL for data science beginners, SQL real-world examples, SQL query writing practice, SQL for spreadsheet users, SQL vs Excel for data analysis, SQL for reporting, SQL for database querying, SQL for analytics roles, SQL spaced repetition learning, SQL active recall practice

---

## Important (25)

evidence-based SQL learning, SQL cognitive science approach, SQL progressive skill building, SQL for data exploration, SQL messy data cleaning, SQL trend analysis, SQL multi-table queries, SQL for enterprise data, SQL for software developers, SQL for operations professionals, SQL for financial analysts, SQL for product managers, SQL for HR analytics, SQL for e-commerce data, SQL for customer data analysis, SQL relational database architecture, SQL table design basics, SQL data modelling for beginners, SQL foreign key relationships, SQL practical exercises, SQL with expected outputs, SQL problem-solving techniques, SQL for business reporting, SQL query optimisation basics, SQL readable query writing

---

## Normal (25)

SQL book Amazon, best SQL book for beginners, SQL guide 2024, SQL for career development, SQL upskilling guide, SQL for tech roles, SQL structured query language, SQL database management basics, SQL for non-technical professionals, SQL for team collaboration, SQL to replace manual reporting, SQL reduce dependency on developers, SQL confidence building, SQL for data conversations, SQL for decision makers, SQL learning roadmap, SQL practice datasets, SQL real business scenarios, SQL from zero to proficient, SQL for analyst interviews, SQL interview preparation, SQL hands-on learning, SQL for data literacy, SQL knowledge retention strategies, SQL for professional growth

---

## Contributing

Found an error in the code, a broken link, or want to add a better example?
See [CONTRIBUTING.md](CONTRIBUTING.md) for the full guide.

**Quick path:**

1. **Fork** this repository
2. **Branch**: `git checkout -b fix/short-description`
3. **Change**: keep each PR focused on one fix or improvement
4. **PR**: open a Pull Request against `main` — describe what you changed and why

**Issue labels:**
| Label | Use when |
|-------|---------|
| `bug` | Code doesn't run or produces wrong output |
| `enhancement` | Better example, additional exercise, or clarifying note |
| `book-content` | Error in the book text itself |
| `broken-link` | A URL or file path is dead |

All contributions are welcome — corrections, translations, and additional exercises especially.

---

## License

Code examples in this repository are released under the **MIT License** — free to use,
adapt, and redistribute with attribution.

Book text, figures, and branded assets remain the copyright of the author.
Do not reproduce book content without written permission.

---

*Companion repository for **"The Science of Learning SQL: An Evidence-Based, Step-by-Step Guide to Mastering Databases, Queries, Joins, and Real-World Data Analysis for Complete Beginners"** · 16 chapters · 100 sections · Generated automatically.*
