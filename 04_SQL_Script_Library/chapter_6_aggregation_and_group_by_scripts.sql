-- =============================================================================
-- Chapter 6: Aggregate Functions and GROUP BY
-- Turning Raw Rows Into Business Insights
-- "The Science of Learning SQL: An Evidence-Based, Step-by-Step Guide to
--  Mastering Databases, Queries, Joins, and Real-World Data Analysis
--  for Complete Beginners"
-- =============================================================================
-- PURPOSE:
--   This script accompanies Chapter 6 and demonstrates every core aggregation
--   concept introduced in the chapter: COUNT, SUM, AVG, MIN, MAX, GROUP BY,
--   WHERE vs. HAVING, NULL counting traps, and readable aliases.
--   Work through each section in order. Every statement is self-contained and
--   runnable against the sample schema created in the SETUP section below.
-- =============================================================================


-- =============================================================================
-- SECTION 0: SETUP — Create and Populate Sample Tables
-- =============================================================================

-- We use two tables throughout this script:
--   orders   : one row per customer order
--   products : one row per product in a catalogue
-- These tables mirror the kind of real-world retail data discussed in Chapter 6.

CREATE TABLE products (
    product_id   INTEGER      PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category     VARCHAR(50)  NOT NULL,
    unit_price   DECIMAL(10,2) NOT NULL
);

CREATE TABLE orders (
    order_id    INTEGER       PRIMARY KEY,
    customer_id INTEGER       NOT NULL,
    product_id  INTEGER       NOT NULL,
    region      VARCHAR(50)   NOT NULL,
    order_date  DATE          NOT NULL,
    quantity    INTEGER       NOT NULL,
    discount    DECIMAL(5,2),          -- intentionally allows NULL
    status      VARCHAR(20)   NOT NULL
);

-- Populate products
INSERT INTO products (product_id, product_name, category, unit_price) VALUES
(1,  'Wireless Mouse',      'Electronics',  29.99),
(2,  'USB-C Hub',           'Electronics',  49.99),
(3,  'Standing Desk',       'Furniture',   349.00),
(4,  'Ergonomic Chair',     'Furniture',   499.00),
(5,  'Notebook Pack',       'Stationery',    8.50),
(6,  'Ballpoint Pens x10', 'Stationery',    4.25),
(7,  'Monitor 27"',         'Electronics', 299.99),
(8,  'Desk Lamp',           'Furniture',    39.99),
(9,  'Sticky Notes',        'Stationery',    3.10),
(10, 'Webcam HD',           'Electronics',  79.99);

-- Populate orders (some discount values are NULL to demonstrate NULL traps)
INSERT INTO orders (order_id, customer_id, product_id, region, order_date, quantity, discount, status) VALUES
(1001, 201, 1,  'North', '2024-01-05',  2, 5.00,  'Completed'),
(1002, 202, 3,  'South', '2024-01-12',  1, NULL,  'Completed'),
(1003, 203, 5,  'East',  '2024-01-18',  5, 1.00,  'Completed'),
(1004, 204, 7,  'West',  '2024-01-22',  1, 20.00, 'Completed'),
(1005, 201, 2,  'North', '2024-02-03',  3, NULL,  'Completed'),
(1006, 205, 4,  'South', '2024-02-09',  1, 50.00, 'Cancelled'),
(1007, 206, 6,  'East',  '2024-02-14',  4, NULL,  'Completed'),
(1008, 207, 8,  'West',  '2024-02-19',  2, 5.00,  'Completed'),
(1009, 208, 9,  'North', '2024-03-02', 10, NULL,  'Completed'),
(1010, 203, 10, 'East',  '2024-03-07',  1, 10.00, 'Completed'),
(1011, 209, 1,  'South', '2024-03-11',  3, NULL,  'Completed'),
(1012, 210, 3,  'West',  '2024-03-15',  1, 30.00, 'Completed'),
(1013, 202, 7,  'North', '2024-03-20',  2, NULL,  'Cancelled'),
(1014, 211, 5,  'South', '2024-04-01',  6, 2.00,  'Completed'),
(1015, 212, 2,  'East',  '2024-04-08',  2, NULL,  'Completed'),
(1016, 204, 6,  'West',  '2024-04-13',  8, 1.50,  'Completed'),
(1017, 213, 4,  'North', '2024-04-17',  1, NULL,  'Completed'),
(1018, 201, 10, 'South', '2024-04-22',  1, 8.00,  'Completed'),
(1019, 214, 8,  'East',  '2024-04-28',  3, NULL,  'Completed'),
(1020, 215, 9,  'West',  '2024-05-05', 12, 3.00,  'Completed');


-- =============================================================================
-- SECTION 1: What Aggregation Means — Collapsing Many Rows Into One Number
-- =============================================================================

-- Aggregation is the process of reducing many individual rows into a single
-- summary value. Without aggregation you see every order; with aggregation
-- you see the business story those orders tell.

-- The simplest aggregate: count every row in the orders table.
-- COUNT(*) counts ALL rows regardless of NULL values in any column.
-- This answers: "How many orders do we have in total?"
SELECT COUNT(*) AS total_orders
FROM orders;

-- Contrast with a plain SELECT that returns every raw row — 20 rows of noise:
-- SELECT * FROM orders;
-- Aggregation collapses those 20 rows into one meaningful metric.


-- =============================================================================
-- SECTION 2: The Five Core Aggregate Functions — COUNT, SUM, AVG, MIN, MAX
-- =============================================================================

-- -----------------------------------------------------------------------
-- 2a. COUNT — How many rows / non-NULL values exist?
-- -----------------------------------------------------------------------

-- Count all orders (every row, regardless of column content)
SELECT COUNT(*) AS total_orders
FROM orders;

-- Count only Completed orders using a filter inside COUNT with CASE.
-- This is a useful pattern for conditional counting.
SELECT COUNT(CASE WHEN status = 'Completed' THEN 1 END) AS completed_orders
FROM orders;

-- -----------------------------------------------------------------------
-- 2b. SUM — Add up a numeric column across all qualifying rows
-- -----------------------------------------------------------------------

-- Total quantity of all items ever ordered across the entire business.
-- SUM collapses every quantity value into one grand total.
SELECT SUM(quantity) AS total_units_ordered
FROM orders;

-- Total revenue potential: multiply quantity by unit_price for each order,
-- then sum. This requires joining to products to get the price.
-- Chapter 6 shows this as a real-world business metric example.
SELECT SUM(o.quantity * p.unit_price) AS gross_revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
WHERE o.status = 'Completed';

-- -----------------------------------------------------------------------
-- 2c. AVG — The arithmetic mean of a numeric column
-- -----------------------------------------------------------------------

-- Average quantity per order — tells us typical order size.
SELECT AVG(quantity) AS avg_order_quantity
FROM orders;

-- Average unit price across all products in the catalogue.
SELECT AVG(unit_price) AS avg_product_price
FROM products;

-- -----------------------------------------------------------------------
-- 2d. MIN — The smallest value in a column
-- -----------------------------------------------------------------------

-- Earliest order date in the dataset — when did business begin in this period?
SELECT MIN(order_date) AS first_order_date
FROM orders;

-- Cheapest product in the catalogue.
SELECT MIN(unit_price) AS cheapest_price
FROM products;

-- -----------------------------------------------------------------------
-- 2e. MAX — The largest value in a column
-- -----------------------------------------------------------------------

-- Most recent order date — the latest activity in the dataset.
SELECT MAX(order_date) AS most_recent_order_date
FROM orders;

-- Most expensive product in the catalogue.
SELECT MAX(unit_price) AS most_expensive_price
FROM products;

-- -----------------------------------------------------------------------
-- 2f. Using all five aggregate functions together in one query
-- -----------------------------------------------------------------------

-- A single query that produces a full summary dashboard row for quantity.
-- This is exactly the kind of "one meaningful number per metric" output
-- Chapter 6 describes as the goal of aggregation.
SELECT
    COUNT(*)          AS total_orders,
    SUM(quantity)     AS total_units,
    AVG(quantity)     AS avg_units_per_order,
    MIN(quantity)     AS smallest_order,
    MAX(quantity)     AS largest_order
FROM orders
WHERE status = 'Completed';


-- =============================================================================
-- SECTION 3: Grouping Data With GROUP BY — Segmenting Results by Category
-- =============================================================================

-- GROUP BY divides the rows into groups before the aggregate function is
-- applied. Instead of one number for the whole table, you get one number
-- PER GROUP. This is how you move from totals to breakdowns.

-- -----------------------------------------------------------------------
-- 3a. Group by a single column — orders per region
-- -----------------------------------------------------------------------

-- How many orders came from each region?
-- GROUP BY region creates one result row for each distinct region value.
SELECT
    region,
    COUNT(*) AS order_count
FROM orders
GROUP BY region
ORDER BY order_count DESC;

-- -----------------------------------------------------------------------
-- 3b. Group by category — revenue per product category
-- -------
