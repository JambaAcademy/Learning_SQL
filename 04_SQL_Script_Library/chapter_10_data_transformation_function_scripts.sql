-- ============================================================
-- Chapter 10 Data Transformation Function Scripts
-- The Science of Learning SQL: An Evidence-Based, Step-by-Step
-- Guide to Mastering Databases, Queries, Joins, and Real-World
-- Data Analysis for Complete Beginners
--
-- Purpose: Demonstrate string, date, and numeric transformation
-- functions that clean and reshape raw, inconsistent data into
-- analysis-ready output directly inside SELECT statements,
-- without altering the underlying source tables.
--
-- Chapter: Chapter 10 - String, Date, and Numeric Functions:
--          Cleaning and Transforming Real-World Data
--
-- Dialect: Standard ANSI SQL with widely supported extensions.
--          Notes are included where syntax may vary between
--          MySQL, PostgreSQL, and SQL Server.
-- ============================================================


-- ============================================================
-- SECTION 1: SAMPLE DATA SETUP
-- Create and populate a realistic, intentionally messy dataset
-- that mirrors the kinds of raw tables working analysts face.
-- ============================================================

-- Drop tables if they already exist so the script is re-runnable
DROP TABLE IF EXISTS raw_customers;
DROP TABLE IF EXISTS raw_orders;
DROP TABLE IF EXISTS raw_products;

-- Create a raw_customers table with the kinds of formatting
-- inconsistencies found in data exported from CRM systems:
-- extra whitespace, mixed letter cases, and unformatted phone
-- numbers that would break any automated matching process.
CREATE TABLE raw_customers (
    customer_id   INTEGER        PRIMARY KEY,
    full_name     VARCHAR(100),
    email         VARCHAR(150),
    phone         VARCHAR(30),
    city          VARCHAR(80),
    signup_date   VARCHAR(30),   -- stored as text, not DATE
    lifetime_spend DECIMAL(10,4) -- extra decimal precision, needs rounding
);

-- Insert deliberately messy rows to give every function
-- a realistic problem to solve.
INSERT INTO raw_customers VALUES
    (1,  '  alice johnson ',  'ALICE@EXAMPLE.COM',  '(555) 123-4567', '  new york  ', '2022-03-15', 1847.5623),
    (2,  'BOB SMITH',         'bob@example.com',    '555.987.6543',   'Chicago',       '2021-11-02', 304.1000),
    (3,  'carol  white',      'Carol@Example.COM',  '5551234000',     'LOS ANGELES',   '2023-07-28', 9210.8891),
    (4,  '  David Lee  ',     'DAVID@EXAMPLE.COM',  '(555)321-9876',  '  houston  ',   '2020-01-09', 52.2500),
    (5,  'EMMA DAVIS',        'emma@example.com',   '555 456 7890',   'Phoenix',        '2023-12-01', 7654.3317),
    (6,  'frank  miller',     'Frank@EXAMPLE.com',  '(555) 000-1111', '  Seattle  ',   '2019-06-22', 125.0050),
    (7,  '  Grace Kim  ',     'grace@example.com',  '555-222-3333',   'BOSTON',        '2022-09-14', 3300.7749),
    (8,  'henry BROWN',       'HENRY@example.COM',  '(555)888-9999',  'Denver',        '2021-04-30', 870.6600);

-- Create a raw_orders table with date values stored as plain
-- text strings — a common export artifact from legacy systems.
CREATE TABLE raw_orders (
    order_id      INTEGER PRIMARY KEY,
    customer_id   INTEGER,
    order_date    VARCHAR(30),   -- text, not DATE
    ship_date     VARCHAR(30),   -- text, not DATE
    amount        DECIMAL(10,4),
    category      VARCHAR(50),
    region        VARCHAR(40)
);

INSERT INTO raw_orders VALUES
    (1001, 1, '2024-01-05', '2024-01-08', 249.9900, 'electronics', 'EAST'),
    (1002, 2, '2024-01-12', '2024-01-15', 89.9500,  'BOOKS',       'Midwest'),
    (1003, 3, '2024-02-03', '2024-02-07', 1500.0000,'Electronics', 'west'),
    (1004, 4, '2024-02-18', '2024-02-20', 34.5000,  'books',       'SOUTH'),
    (1005, 5, '2024-03-01', '2024-03-06', 799.9900, 'ELECTRONICS', 'West'),
    (1006, 6, '2024-03-22', '2024-03-25', 19.9900,  'Books',       'east'),
    (1007, 7, '2024-04-10', '2024-04-14', 450.0000, 'Clothing',    'EAST'),
    (1008, 8, '2024-04-29', '2024-05-03', 120.5000, 'clothing',    'Midwest'),
    (1009, 1, '2024-05-15', '2024-05-18', 75.0000,  'CLOTHING',    'East'),
    (1010, 3, '2024-06-02', '2024-06-06', 2200.0000,'electronics', 'West');

-- Create a raw_products table with numeric values that need
-- rounding, bucketing, and conditional labelling.
CREATE TABLE raw_products (
    product_id    INTEGER PRIMARY KEY,
    product_name  VARCHAR(100),
    list_price    DECIMAL(10,4),
    cost_price    DECIMAL(10,4),
    weight_kg     DECIMAL(8,4),
    stock_qty     INTEGER
);

INSERT INTO raw_products VALUES
    (101, 'Wireless Headphones',  79.9900,  42.5000,  0.3500, 142),
    (102, 'USB-C Hub',            34.9900,  18.2500,  0.1200,  87),
    (103, 'Mechanical Keyboard', 129.9900,  67.8800,  1.1500,  34),
    (104, 'Laptop Stand',         49.9900,  22.3300,  0.8800, 210),
    (105, 'Webcam HD',            89.9900,  45.6700,  0.2700,  56),
    (106, 'Monitor 27"',         399.9900, 210.0000,  5.6000,   8),
    (107, 'Mouse Ergonomic',      54.9900,  28.1100,  0.1900, 175),
    (108, 'Desk Lamp LED',        39.9900,  17.5500,  1.0300,  92);


-- ============================================================
-- SECTION 2: STRING FUNCTIONS
-- UPPER, LOWER, TRIM, CONCAT, SUBSTRING, REPLACE
--
-- These functions fix text inconsistencies that would otherwise
-- cause GROUP BY clauses, JOIN conditions, and WHERE filters
-- to produce silently wrong results.
-- ============================================================

-- UPPER: Normalise all email addresses to lowercase for
-- consistent matching. Analysts often use LOWER rather than
-- UPPER for emails because convention favours lowercase.
-- LOWER converts every character to its lowercase equivalent.
SELECT
    customer_id,
    full_name,
    email                          AS raw_email,
    LOWER(email)                   AS clean_email
FROM raw_customers;

-- TRIM: Remove leading and trailing whitespace from full_name
-- and city. Without TRIM, '  alice johnson ' and 'alice johnson'
-- are treated as different values, breaking GROUP BY and JOIN.
SELECT
    customer_id,
    full_name                      AS raw_name,
    TRIM(full_name)                AS trimmed_name,
    city                           AS raw_city,
    TRIM(city)                     AS trimmed_city
FROM raw_customers;

-- Combine TRIM and UPPER to produce a fully standardised name
-- column. Chaining functions is the normal pattern in SQL —
-- the innermost function executes first.
SELECT
    customer_id,
    UPPER(TRIM(full_name))         AS standardised_name,
    LOWER(TRIM(email))             AS standardised_email,
    UPPER(TRIM(city))              AS standardised_city
FROM raw_customers;

-- CONCAT: Build a display label by joining the cleaned name
-- and city into a single readable string.
-- Standard ANSI SQL uses the CONCAT function; some databases
-- also support the || operator (PostgreSQL, SQLite).
SELECT
    customer_id,
    CONCAT(
        UPPER(TRIM(full_name)),
        ' — ',
        UPPER(TRIM(city))
    )                              AS customer_label
FROM raw_customers;

-- REPLACE: Strip all non-digit characters from phone numbers
-- so they can be stored or compared in a uniform format.
-- Each REPLACE call removes one type of separator character.
-- Nesting REPLACE calls handles multiple separator styles.
SELECT
    customer_id,
    phone                          AS raw_phone,
    REPLACE(
        REPLACE(
            REPLACE(
                REPLACE(phone, '(', ''),
            ')', ''),
        '-', ''),
    ' ', '')                       AS digits_only_phone
FROM raw_customers;

-- SUBSTRING (SUBSTR in some dialects): Extract the domain
-- portion of an email address. POSITION finds where '@' sits;
-- SUBSTRING then copies everything after that character.
-- This technique is useful for grouping customers by email
-- provider without a separate domain column.
SELECT
    customer_id,
    LOWER(TRIM(email))             AS clean_email,
    SUBSTRING(
        LOWER(TRIM(email))
        FROM POSITION('@' IN LOWER(TRIM(email))) + 1
    )
