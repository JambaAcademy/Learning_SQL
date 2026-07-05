-- =============================================================================
-- Duplicate Detection and Deduplication Script
-- =============================================================================
-- Companion script for:
--   "The Science of Learning SQL: An Evidence-Based, Step-by-Step Guide to
--    Mastering Databases, Queries, Joins, and Real-World Data Analysis
--    for Complete Beginners"
--
-- Covers concepts from:
--   Chapter 11 — Window Functions (ROW_NUMBER, PARTITION BY, OVER clause)
--   Chapter 14 — Data Quality and Cleaning (Detecting and Handling Duplicates)
--
-- PURPOSE:
--   This script walks through every stage of duplicate detection and
--   deduplication using the window function pattern taught in Chapters 11
--   and 14.  Each block is self-contained, annotated, and immediately
--   runnable against the sample tables created in Section 1.
--
-- PATTERN SUMMARY (Chapter 11 / Chapter 14):
--   ROW_NUMBER() OVER (PARTITION BY <key columns> ORDER BY <tiebreak column>)
--   assigns a sequential integer to each row within each group defined by
--   PARTITION BY.  Rows where rn = 1 are the "keeper" record for that group;
--   rows where rn > 1 are duplicates.  Because ROW_NUMBER is a window
--   function, every row is preserved in the intermediate result — unlike
--   GROUP BY, which collapses rows and loses the detail needed to audit
--   and selectively delete duplicates.
--
-- COMPATIBILITY: Standard SQL / SQLite 3.25+, PostgreSQL 9.4+, MySQL 8.0+
-- =============================================================================


-- =============================================================================
-- SECTION 1: Sample Data Setup
-- =============================================================================
-- We create two realistic tables that mirror the kinds of messy, real-world
-- datasets discussed in Chapter 14.  Run this section once to build the
-- playground used by every query below.

-- -----------------------------------------------------------------------------
-- 1a. customers — a customer registry with duplicate rows introduced by
--     repeated imports, manual data entry, and system migrations.
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS customers (
    customer_id   INTEGER,          -- source-system surrogate key (NOT guaranteed unique here)
    first_name    TEXT,
    last_name     TEXT,
    email         TEXT,
    signup_date   TEXT,             -- stored as ISO-8601 text: 'YYYY-MM-DD'
    region        TEXT,
    created_at    TEXT              -- row-creation timestamp used as tiebreaker
);

-- Truncate before re-seeding so the script is safely re-runnable
DELETE FROM customers;

INSERT INTO customers VALUES
-- Genuine unique customers
(1001, 'Alice',   'Nkosi',     'alice.nkosi@example.com',    '2023-01-15', 'North', '2023-01-15 09:00:00'),
(1002, 'Bernard', 'Okafor',    'bernard.okafor@example.com', '2023-02-20', 'South', '2023-02-20 11:30:00'),
(1003, 'Clara',   'Mensah',    'clara.mensah@example.com',   '2023-03-05', 'East',  '2023-03-05 14:15:00'),
(1004, 'David',   'Eze',       'david.eze@example.com',      '2023-04-10', 'West',  '2023-04-10 08:45:00'),
(1005, 'Esther',  'Boateng',   'esther.boateng@example.com', '2023-05-22', 'North', '2023-05-22 16:00:00'),

-- Exact duplicates (identical on every column) — common after double imports
(1001, 'Alice',   'Nkosi',     'alice.nkosi@example.com',    '2023-01-15', 'North', '2023-01-15 09:00:00'),

-- Near-duplicate: same email, different created_at (later re-import)
(1002, 'Bernard', 'Okafor',    'bernard.okafor@example.com', '2023-02-20', 'South', '2023-02-20 14:00:00'),

-- Near-duplicate: same customer_id, capitalisation difference in name
(1003, 'CLARA',   'Mensah',    'clara.mensah@example.com',   '2023-03-05', 'East',  '2023-03-05 15:00:00'),

-- Near-duplicate: same email, different customer_id (split record)
(9003, 'Clara',   'Mensah',    'clara.mensah@example.com',   '2023-03-05', 'East',  '2023-03-05 16:30:00'),

-- Unique customer added after initial load
(1006, 'Felix',   'Asante',    'felix.asante@example.com',   '2023-06-01', 'South', '2023-06-01 10:00:00');

-- -----------------------------------------------------------------------------
-- 1b. orders — transaction records; duplicates here silently inflate revenue
--     totals (exactly the "silent corruption" scenario from Chapter 14).
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS orders (
    order_id      INTEGER,
    customer_id   INTEGER,
    order_date    TEXT,
    product       TEXT,
    amount        REAL,
    created_at    TEXT
);

DELETE FROM orders;

INSERT INTO orders VALUES
(5001, 1001, '2023-07-01', 'Laptop',     1200.00, '2023-07-01 08:00:00'),
(5002, 1002, '2023-07-02', 'Monitor',     350.00, '2023-07-02 09:00:00'),
(5003, 1003, '2023-07-03', 'Keyboard',     75.00, '2023-07-03 10:00:00'),
(5004, 1004, '2023-07-04', 'Mouse',        45.00, '2023-07-04 11:00:00'),
(5005, 1005, '2023-07-05', 'Webcam',      120.00, '2023-07-05 12:00:00'),

-- Exact duplicate order row (double-posted by the payment gateway)
(5001, 1001, '2023-07-01', 'Laptop',     1200.00, '2023-07-01 08:00:00'),

-- Near-duplicate: same order_id, slightly different created_at (retry)
(5002, 1002, '2023-07-02', 'Monitor',     350.00, '2023-07-02 09:05:00'),

-- Duplicate with different order_id (system assigned a new ID on retry)
(5006, 1003, '2023-07-03', 'Keyboard',    75.00, '2023-07-03 10:02:00');


-- =============================================================================
-- SECTION 2: Counting Duplicates — First Audit Pass (Chapter 14)
-- =============================================================================
-- Before touching any data, Chapter 14 teaches us to DETECT first.
-- These queries count how many rows share the same business key so we
-- understand the scale of the problem.

-- -----------------------------------------------------------------------------
-- 2a. Count duplicate customers by email (the natural business key)
-- -----------------------------------------------------------------------------
-- HOW IT WORKS:
--   GROUP BY collapses rows to one per email.  HAVING COUNT(*) > 1 keeps
--   only the groups that have more than one row — those are our duplicates.
--   This is the simplest audit query and answers "how bad is it?"
-- -----------------------------------------------------------------------------
SELECT
    email,
    COUNT(*)        AS total_rows,
    COUNT(*) - 1    AS duplicate_count   -- how many extra copies exist
FROM customers
GROUP BY email
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- -----------------------------------------------------------------------------
-- 2b. Count duplicate orders by order_id
-- -----------------------------------------------------------------------------
SELECT
    order_id,
    COUNT(*)        AS total_rows,
    COUNT(*) - 1    AS duplicate_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- -----------------------------------------------------------------------------
-- 2c. Broader audit — duplicates on multiple business-key columns
--     (same customer_id AND email, catching split records)
-- -----------------------------------------------------------------------------
SELECT
    customer_id,
    email,
    COUNT(*)        AS total_rows
FROM customers
GROUP BY customer_id, email
HAVING COUNT(*) > 1
ORDER BY total_rows DESC;


-- =============================================================================
-- SECTION 3: ROW_NUMBER — Labelling Every Duplicate (Chapter 11 + 14)
-- =============================================================================
-- GROUP BY told us duplicates exist.  ROW_NUMBER tells us WHICH specific rows
-- are the duplicates — and which one to keep.
--
-- Chapter 11 explains: ROW_NUMBER() OVER (PARTITION BY ... ORDER BY ...)
--   • PARTITION BY  — resets the counter for each distinct group (like a
--                     sub-GROUP BY that doesn't collapse rows).
--   • ORDER BY      — decides which row within the group gets rn = 1 (the
--                     "keeper") and which get rn = 2, 3, … (the duplicates).
--   • The OVER clause is what makes this a window function, not an aggregate.
--     Every input row appears in the output — nothing is collapsed.

-- -----------------------------------------------------------------------------
-- 3a. Label customer rows by email — earliest created_at wins (rn = 1)
-- -----------------------------------------------------------------------------
SELECT
    customer_id,
    first_name,
    last_name,
    email,
    signup_date,
    region,
    created_at,
    -- Window function: assign a rank within each email group.
    -- The row with the earliest created_at gets rn = 1 (our keeper).
    ROW_NUMBER() OVER (
        PARTITION BY email          --
