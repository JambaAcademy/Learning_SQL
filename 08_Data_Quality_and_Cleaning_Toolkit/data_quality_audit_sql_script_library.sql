-- =============================================================================
-- DATA QUALITY AUDIT SQL SCRIPT LIBRARY
-- The Science of Learning SQL: An Evidence-Based, Step-by-Step Guide to
-- Mastering Databases, Queries, Joins, and Real-World Data Analysis
-- for Complete Beginners
--
-- Purpose: A structured, reusable library of SQL scripts for auditing and
--          cleaning data quality issues in relational databases.
--          Each section maps to core concepts from the book, reinforcing
--          spaced repetition and active recall (Chapter 1) by revisiting
--          SELECT, WHERE, NULL handling, aggregation, joins, and subqueries
--          in a practical, real-world context.
--
-- Chapters Referenced:
--   Ch 2  - Tables, rows, columns, primary keys, foreign keys
--   Ch 3  - SELECT statements and column control
--   Ch 4  - WHERE clause, NULL handling, comparison operators
--   Ch 5  - ORDER BY, LIMIT for prioritising audit findings
--   Ch 6  - Aggregate functions and GROUP BY for summary metrics
--   Ch 7  - JOINs to detect orphaned or mismatched records across tables
--   Ch 8  - Subqueries to filter against calculated thresholds dynamically
--
-- How to use this library:
--   Run each block independently against your target database.
--   Replace table and column names with your actual schema objects.
--   Read every comment before executing -- that active recall practice
--   is itself a learning technique validated by the book's Chapter 1 research.
-- =============================================================================


-- =============================================================================
-- SECTION 1: SCHEMA RECONNAISSANCE
-- Understanding your table structure before auditing it
-- (Chapter 2: Tables, Rows, Columns, and the Logic Behind the Structure)
-- =============================================================================

-- Before writing any audit query, a professional analyst inspects the
-- structure of each table. This mirrors the book's filing-cabinet analogy:
-- you need to know what drawers exist before you can check what is missing.

-- Count the total number of rows in the primary subject table.
-- This establishes your baseline population for every percentage calculation
-- that follows. Without this number, audit findings have no denominator.
SELECT COUNT(*) AS total_row_count
FROM customers;

-- Count total rows in a related transactions table.
-- Comparing this to the customers count reveals the expected join cardinality.
SELECT COUNT(*) AS total_transaction_count
FROM transactions;

-- Retrieve one sample row to visually confirm column names and data types.
-- Chapter 3 emphasises controlling which columns appear in results; here we
-- deliberately use SELECT * only for initial schema discovery, not reporting.
SELECT *
FROM customers
LIMIT 5;

-- List every distinct data type present in the orders table by sampling
-- the first non-null value from each column. This is a manual approach
-- compatible with standard SQL when INFORMATION_SCHEMA is unavailable.
SELECT
    MIN(customer_id)    AS sample_customer_id,
    MIN(order_date)     AS sample_order_date,
    MIN(order_total)    AS sample_order_total,
    MIN(status)         AS sample_status,
    MIN(region)         AS sample_region
FROM orders;


-- =============================================================================
-- SECTION 2: NULL VALUE AUDIT
-- Detecting the absence of data across every critical column
-- (Chapter 4: NULL values require IS NULL syntax -- standard operators fail)
-- =============================================================================

-- NULL is not zero and not an empty string. As Chapter 4 explains, standard
-- comparison operators like = or <> cannot detect NULL because NULL represents
-- the complete absence of a value. IS NULL is the only reliable syntax.

-- Audit NULL counts for every business-critical column in the customers table.
-- Each line uses SUM with a CASE expression to count NULLs per column in one
-- pass, avoiding the need to run a separate query for every column.
SELECT
    COUNT(*)                                                        AS total_rows,
    SUM(CASE WHEN customer_id   IS NULL THEN 1 ELSE 0 END)         AS null_customer_id,
    SUM(CASE WHEN first_name    IS NULL THEN 1 ELSE 0 END)         AS null_first_name,
    SUM(CASE WHEN last_name     IS NULL THEN 1 ELSE 0 END)         AS null_last_name,
    SUM(CASE WHEN email         IS NULL THEN 1 ELSE 0 END)         AS null_email,
    SUM(CASE WHEN phone         IS NULL THEN 1 ELSE 0 END)         AS null_phone,
    SUM(CASE WHEN signup_date   IS NULL THEN 1 ELSE 0 END)         AS null_signup_date,
    SUM(CASE WHEN country       IS NULL THEN 1 ELSE 0 END)         AS null_country
FROM customers;

-- Express NULL counts as a percentage of total rows.
-- Percentages communicate severity far more clearly than raw counts when
-- comparing tables of different sizes -- a key data storytelling principle.
SELECT
    'email'                                                         AS column_name,
    COUNT(*)                                                        AS total_rows,
    SUM(CASE WHEN email IS NULL THEN 1 ELSE 0 END)                 AS null_count,
    ROUND(
        100.0 * SUM(CASE WHEN email IS NULL THEN 1 ELSE 0 END)
        / COUNT(*), 2
    )                                                               AS null_pct
FROM customers

UNION ALL

SELECT
    'phone',
    COUNT(*),
    SUM(CASE WHEN phone IS NULL THEN 1 ELSE 0 END),
    ROUND(
        100.0 * SUM(CASE WHEN phone IS NULL THEN 1 ELSE 0 END)
        / COUNT(*), 2
    )
FROM customers

UNION ALL

SELECT
    'country',
    COUNT(*),
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END),
    ROUND(
        100.0 * SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END)
        / COUNT(*), 2
    )
FROM customers

ORDER BY null_pct DESC;

-- Retrieve the actual rows where a critical field is NULL so you can
-- inspect them directly. Chapter 4 shows that WHERE combined with IS NULL
-- filters rows before results are returned -- exactly what we need here.
SELECT
    customer_id,
    first_name,
    last_name,
    email,
    signup_date
FROM customers
WHERE email IS NULL
ORDER BY signup_date DESC;

-- Find rows where ANY of several important columns are NULL simultaneously.
-- Logical OR (Chapter 4) lets one WHERE clause catch multiple NULL patterns.
SELECT
    customer_id,
    first_name,
    last_name,
    email,
    phone,
    country
FROM customers
WHERE email   IS NULL
   OR phone   IS NULL
   OR country IS NULL
ORDER BY customer_id;

-- Find rows where ALL of several columns are populated (no NULLs).
-- This is the complement of the query above -- it identifies clean records.
-- Logical AND (Chapter 4) requires every condition to be true simultaneously.
SELECT
    customer_id,
    first_name,
    last_name,
    email,
    phone,
    country
FROM customers
WHERE email   IS NOT NULL
  AND phone   IS NOT NULL
  AND country IS NOT NULL
ORDER BY customer_id;


-- =============================================================================
-- SECTION 3: DUPLICATE RECORD DETECTION
-- Using GROUP BY and HAVING to surface repeated values
-- (Chapter 6: GROUP BY segments results; HAVING filters after aggregation)
-- =============================================================================

-- Chapter 6 distinguishes WHERE (filters rows before grouping) from HAVING
-- (filters groups after aggregation). Duplicate detection is a textbook case
-- for HAVING because you need to count occurrences first, then keep only
-- those groups where the count exceeds one.

-- Detect duplicate email addresses in the customers table.
-- A primary key (Chapter 2) guarantees row uniqueness, but it does not
-- prevent two rows from sharing the same email value. This query finds those.
SELECT
    email,
    COUNT(*)    AS occurrence_count
FROM customers
WHERE email IS NOT NULL
GROUP BY email
HAVING COUNT(*) > 1
ORDER BY occurrence_count DESC;

-- Detect duplicate combinations of first name, last name, and signup date.
-- Grouping on multiple columns (Chapter 6) lets you define "duplicate"
-- at whatever granularity your business rules require.
SELECT
    first_name,
    last_name,
    signup_date,
    COUNT(*)    AS occurrence_count
FROM customers
GROUP BY
    first_name,
    last_name,
    signup_date
HAVING COUNT(*) > 1
ORDER BY occurrence_count DESC;

-- Retrieve the full rows involved in email duplicates so you can compare them.
-- This uses a subquery (Chapter 8) to supply the list of duplicate emails
-- dynamically. The inner query runs first and its result feeds the outer WHERE.
SELECT
    customer_id,
    first_name,
    last_name,
    email,
    signup_date,
    country
FROM customers
WHERE email IN (
    SELECT email
    FROM customers
    WHERE email IS NOT NULL
    GROUP BY email
    HAVING COUNT(*) > 1
)
ORDER BY email, customer_id;

-- Count total duplicate rows vs total rows to gauge severity.
-- The subquery isolates the duplicate email values; the outer query counts
-- how many customer rows carry those emails.
SELECT
    COUNT(*)    AS rows_involved_in_email_duplicates
FROM customers
WHERE email IN (
    SELECT email
    FROM customers
    WHERE email IS NOT NULL
    GROUP BY email
    HAVING COUNT(*) > 1
);

-- Detect duplicate order records by matching on multiple business keys.
-- Two orders from the same customer on the same date for the same amount
-- are almost certainly data entry errors rather than legitimate repeat orders.
SELECT
    customer_id,
    order_date,
    order_total,
    COUNT(*)    AS duplicate_count
FROM orders
GROUP BY
    customer_id,
    order_date,
    order_total
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;


-- =============================================================================
--
