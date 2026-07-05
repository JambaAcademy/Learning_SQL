-- =============================================================================
-- Chapter 14 Data Quality Audit Scripts
-- The Science of Learning SQL: An Evidence-Based, Step-by-Step Guide to
-- Mastering Databases, Queries, Joins, and Real-World Data Analysis
-- for Complete Beginners
--
-- PURPOSE:
--   Reusable audit query library for detecting NULLs, blanks, duplicates,
--   outliers, impossible values, and orphaned foreign key records as described
--   throughout Chapter 14: Data Quality and Cleaning in SQL.
--
-- HOW TO USE:
--   Run each section independently against the practice datasets supplied with
--   the book.  Every query is annotated with the Chapter 14 concept it
--   illustrates.  Replace schema/table/column names with your own where noted.
--
-- PRACTICE DATASET TABLES ASSUMED:
--   customers      (customer_id, first_name, last_name, email, phone,
--                   country, signup_date, age)
--   orders         (order_id, customer_id, order_date, ship_date,
--                   status, total_amount)
--   order_items    (item_id, order_id, product_id, quantity, unit_price)
--   products       (product_id, product_name, category, list_price, stock_qty)
--   employees      (employee_id, department_id, hire_date, salary, job_title)
--   departments    (department_id, department_name)
--
-- COMPATIBILITY: Standard SQL (ANSI); notes flag dialect differences for
--   MySQL 8+, PostgreSQL 13+, and SQLite 3.35+.
-- =============================================================================


-- =============================================================================
-- SECTION 1: UNDERSTANDING WHAT MAKES DATA DIRTY
-- Chapter 14, "What Makes Data Dirty and Why It Silently Corrupts Analysis"
--
-- Before writing fix queries, build a structural picture of every table.
-- These meta-queries expose row counts, column counts, and basic shape so
-- you know the scale of the problem.
-- =============================================================================

-- 1a. Row count per practice table
--     Run this first to establish a baseline before any cleaning.
SELECT 'customers'   AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL
SELECT 'orders',                    COUNT(*)              FROM orders
UNION ALL
SELECT 'order_items',               COUNT(*)              FROM order_items
UNION ALL
SELECT 'products',                  COUNT(*)              FROM products
UNION ALL
SELECT 'employees',                 COUNT(*)              FROM employees
UNION ALL
SELECT 'departments',               COUNT(*)              FROM departments;

-- 1b. Completeness summary for the customers table
--     Counts non-NULL values per column so you see which columns are sparse.
--     Dirty data often hides in columns that look populated at first glance.
SELECT
    COUNT(*)                          AS total_rows,
    COUNT(customer_id)                AS has_customer_id,
    COUNT(first_name)                 AS has_first_name,
    COUNT(last_name)                  AS has_last_name,
    COUNT(email)                      AS has_email,
    COUNT(phone)                      AS has_phone,
    COUNT(country)                    AS has_country,
    COUNT(signup_date)                AS has_signup_date,
    COUNT(age)                        AS has_age
FROM customers;

-- 1c. Same completeness pattern applied to orders
SELECT
    COUNT(*)                          AS total_rows,
    COUNT(order_id)                   AS has_order_id,
    COUNT(customer_id)                AS has_customer_id,
    COUNT(order_date)                 AS has_order_date,
    COUNT(ship_date)                  AS has_ship_date,
    COUNT(status)                     AS has_status,
    COUNT(total_amount)               AS has_total_amount
FROM orders;

-- 1d. Percentage completeness per column (customers)
--     Dividing by CAST(COUNT(*) AS FLOAT) avoids integer division in SQLite.
--     In PostgreSQL/MySQL you can use COUNT(*)::NUMERIC or COUNT(*) * 1.0.
SELECT
    ROUND(COUNT(customer_id)  * 100.0 / COUNT(*), 2) AS pct_customer_id,
    ROUND(COUNT(first_name)   * 100.0 / COUNT(*), 2) AS pct_first_name,
    ROUND(COUNT(last_name)    * 100.0 / COUNT(*), 2) AS pct_last_name,
    ROUND(COUNT(email)        * 100.0 / COUNT(*), 2) AS pct_email,
    ROUND(COUNT(phone)        * 100.0 / COUNT(*), 2) AS pct_phone,
    ROUND(COUNT(country)      * 100.0 / COUNT(*), 2) AS pct_country,
    ROUND(COUNT(signup_date)  * 100.0 / COUNT(*), 2) AS pct_signup_date,
    ROUND(COUNT(age)          * 100.0 / COUNT(*), 2) AS pct_age
FROM customers;


-- =============================================================================
-- SECTION 2: DETECTING NULLs, BLANKS, AND PLACEHOLDER VALUES
-- Chapter 14, "Detecting Nulls, Blanks, and Placeholder Values Across a Dataset"
--
-- NULLs and empty strings behave differently in SQL.
-- NULL means the value is unknown; '' means the field was stored as empty.
-- Placeholder values ('N/A', 'unknown', '0000-00-00') are the sneakiest
-- because they pass NOT NULL constraints while still being meaningless.
-- =============================================================================

-- 2a. Find all customers with a NULL email address
--     IS NULL is the only correct operator — email = NULL always returns FALSE.
SELECT
    customer_id,
    first_name,
    last_name,
    email
FROM customers
WHERE email IS NULL;

-- 2b. Find customers where email is NULL OR stored as a blank string
--     Both conditions silently exclude rows from JOIN and GROUP BY results.
SELECT
    customer_id,
    first_name,
    last_name,
    email,
    CASE
        WHEN email IS NULL     THEN 'NULL'
        WHEN TRIM(email) = ''  THEN 'BLANK'
    END AS problem_type
FROM customers
WHERE email IS NULL
   OR TRIM(email) = '';

-- 2c. Detect common placeholder values across the customers table
--     Chapter 14 warns that placeholders corrupt aggregations just as NULLs do.
SELECT
    customer_id,
    first_name,
    last_name,
    email,
    phone,
    country
FROM customers
WHERE
    LOWER(TRIM(email))   IN ('n/a', 'na', 'none', 'unknown', 'null', '-', '.')
 OR LOWER(TRIM(phone))   IN ('n/a', 'na', 'none', 'unknown', 'null', '-', '0000000000')
 OR LOWER(TRIM(country)) IN ('n/a', 'na', 'none', 'unknown', 'null', '-');

-- 2d. NULL audit across orders: flag every NULL per column in one pass
--     Useful when you need a row-level report of which fields are missing.
SELECT
    order_id,
    CASE WHEN customer_id  IS NULL THEN 'Y' ELSE 'N' END AS null_customer_id,
    CASE WHEN order_date   IS NULL THEN 'Y' ELSE 'N' END AS null_order_date,
    CASE WHEN ship_date    IS NULL THEN 'Y' ELSE 'N' END AS null_ship_date,
    CASE WHEN status       IS NULL THEN 'Y' ELSE 'N' END AS null_status,
    CASE WHEN total_amount IS NULL THEN 'Y' ELSE 'N' END AS null_total_amount
FROM orders
WHERE
    customer_id  IS NULL
 OR order_date   IS NULL
 OR ship_date    IS NULL
 OR status       IS NULL
 OR total_amount IS NULL;

-- 2e. Count of NULL vs. non-NULL values for the age column in customers
--     Gives a quick summary before deciding on an imputation or exclusion strategy.
SELECT
    SUM(CASE WHEN age IS NULL THEN 1 ELSE 0 END) AS null_age_count,
    SUM(CASE WHEN age IS NOT NULL THEN 1 ELSE 0 END) AS non_null_age_count,
    COUNT(*) AS total_rows
FROM customers;

-- 2f. Detect NULLs in numeric columns that should always have a value
--     unit_price and quantity must never be NULL in a valid order_items row.
SELECT
    item_id,
    order_id,
    product_id,
    quantity,
    unit_price
FROM order_items
WHERE quantity  IS NULL
   OR unit_price IS NULL;

-- 2g. Identify products with NULL or zero list_price
--     Zero price is not the same as NULL but is equally dangerous in revenue sums.
SELECT
    product_id,
    product_name,
    category,
    list_price,
    CASE
        WHEN list_price IS NULL THEN 'NULL_PRICE'
        WHEN list_price = 0    THEN 'ZERO_PRICE'
    END AS price_problem
FROM products
WHERE list_price IS NULL
   OR list_price = 0;


-- =============================================================================
-- SECTION 3: FINDING AND HANDLING DUPLICATES
-- Chapter 14, "Finding and Handling Duplicates With ROW_NUMBER and
-- Deduplication Queries"
--
-- Duplicates inflate counts, double-count revenue, and create fan-out in JOINs.
-- ROW_NUMBER() with PARTITION BY is the precision instrument Chapter 14
-- recommends for isolating true duplicates before any DELETE or UPDATE.
-- =============================================================================

-- 3a. Detect exact duplicate rows in customers (all columns identical)
--
