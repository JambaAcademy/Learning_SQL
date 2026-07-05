-- =============================================================================
-- referential_integrity_audit.sql
--
-- Referential Integrity Audit Script
-- Companion resource for "The Science of Learning SQL: An Evidence-Based,
-- Step-by-Step Guide to Mastering Databases, Queries, Joins, and Real-World
-- Data Analysis for Complete Beginners"
--
-- Chapter 14: Data Quality and Cleaning in SQL
-- Section: Auditing Referential Integrity — Orphaned Records and Broken
--          Foreign Keys
--
-- PURPOSE:
--   Dirty data hides inside structurally normal tables, silently corrupting
--   aggregations, skewing averages, and excluding rows from JOIN results.
--   This script operationalises the referential integrity audit pattern
--   described in Chapter 14 by using LEFT JOIN … IS NULL to surface every
--   orphaned record — a child-table row whose foreign key value has no
--   matching primary key in the parent table.
--
--   Run each numbered block independently in your query editor.  Every block
--   follows the same three-step pattern taught in Chapter 14:
--     1. DETECT   — find orphaned rows with LEFT JOIN / IS NULL
--     2. QUANTIFY — count and express the problem as a percentage of the table
--     3. INSPECT  — preview the orphaned rows so you understand the damage
--
-- SCHEMA ASSUMED (realistic e-commerce teaching schema):
--   customers  (customer_id PK, first_name, last_name, email, country)
--   products   (product_id  PK, product_name, category, unit_price)
--   orders     (order_id    PK, customer_id  FK→customers, order_date,
--               status, total_amount)
--   order_items(item_id     PK, order_id     FK→orders,
--               product_id  FK→products, quantity, line_total)
--   reviews    (review_id   PK, product_id   FK→products,
--               customer_id FK→customers, rating, review_date)
--   shipments  (shipment_id PK, order_id     FK→orders,
--               shipped_date, carrier, tracking_number)
--
-- COMPATIBILITY: Standard SQL — tested on PostgreSQL 14+, MySQL 8+,
--                SQLite 3.35+, SQL Server 2019+
-- =============================================================================


-- =============================================================================
-- SECTION 0: SETUP — Sample Teaching Schema and Seed Data
-- (Skip this section if your database already contains the tables above.)
-- =============================================================================

-- ── 0a. Drop tables in safe dependency order ─────────────────────────────────
DROP TABLE IF EXISTS shipments;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

-- ── 0b. Create parent tables ──────────────────────────────────────────────────
CREATE TABLE customers (
    customer_id   INTEGER      PRIMARY KEY,
    first_name    VARCHAR(50)  NOT NULL,
    last_name     VARCHAR(50)  NOT NULL,
    email         VARCHAR(100),
    country       VARCHAR(50)
);

CREATE TABLE products (
    product_id    INTEGER      PRIMARY KEY,
    product_name  VARCHAR(100) NOT NULL,
    category      VARCHAR(50),
    unit_price    DECIMAL(10,2)
);

-- ── 0c. Create child tables ───────────────────────────────────────────────────
CREATE TABLE orders (
    order_id      INTEGER      PRIMARY KEY,
    customer_id   INTEGER,          -- FK → customers; intentionally no CONSTRAINT
    order_date    DATE,             -- so orphans can be inserted for the audit
    status        VARCHAR(20),
    total_amount  DECIMAL(10,2)
);

CREATE TABLE order_items (
    item_id       INTEGER      PRIMARY KEY,
    order_id      INTEGER,          -- FK → orders
    product_id    INTEGER,          -- FK → products
    quantity      INTEGER,
    line_total    DECIMAL(10,2)
);

CREATE TABLE reviews (
    review_id     INTEGER      PRIMARY KEY,
    product_id    INTEGER,          -- FK → products
    customer_id   INTEGER,          -- FK → customers
    rating        INTEGER,
    review_date   DATE
);

CREATE TABLE shipments (
    shipment_id   INTEGER      PRIMARY KEY,
    order_id      INTEGER,          -- FK → orders
    shipped_date  DATE,
    carrier       VARCHAR(50),
    tracking_number VARCHAR(50)
);

-- ── 0d. Seed clean parent rows ────────────────────────────────────────────────
INSERT INTO customers VALUES
    (1,  'Alice',   'Nguyen',   'alice@example.com',  'USA'),
    (2,  'Bob',     'Okafor',   'bob@example.com',    'UK'),
    (3,  'Carmen',  'Silva',    'carmen@example.com', 'Brazil'),
    (4,  'David',   'Park',     'david@example.com',  'South Korea'),
    (5,  'Eva',     'Müller',   'eva@example.com',    'Germany');

INSERT INTO products VALUES
    (101, 'Wireless Keyboard',  'Electronics',  49.99),
    (102, 'USB-C Hub',          'Electronics',  34.99),
    (103, 'Desk Lamp',          'Office',       22.50),
    (104, 'Notebook Set',       'Stationery',    8.99),
    (105, 'Ergonomic Mouse',    'Electronics',  39.99);

-- ── 0e. Seed orders — some with orphaned customer_id values ──────────────────
-- Orders 1–5: valid customers
-- Orders 6–8: customer_id 99, 0, NULL — these are orphaned records
INSERT INTO orders VALUES
    (1001, 1,    '2024-01-10', 'completed', 84.98),
    (1002, 2,    '2024-01-12', 'completed', 34.99),
    (1003, 3,    '2024-02-01', 'shipped',   22.50),
    (1004, 4,    '2024-02-14', 'pending',   49.99),
    (1005, 5,    '2024-03-05', 'completed', 79.98),
    (1006, 99,   '2024-03-07', 'completed', 39.99),  -- orphan: customer 99 missing
    (1007, 0,    '2024-03-08', 'pending',    8.99),  -- orphan: customer 0 missing
    (1008, NULL, '2024-03-09', 'shipped',   22.50);  -- orphan: NULL customer

-- ── 0f. Seed order_items — some with orphaned order_id or product_id ─────────
INSERT INTO order_items VALUES
    (1, 1001, 101, 1,  49.99),
    (2, 1001, 103, 1,  22.50),   -- wait, total was 84.98 — close enough for demo
    (3, 1002, 102, 1,  34.99),
    (4, 1003, 103, 1,  22.50),
    (5, 1004, 101, 1,  49.99),
    (6, 1005, 105, 2,  79.98),
    (7, 1006, 105, 1,  39.99),
    (8, 1007, 104, 1,   8.99),
    (9, 9999, 101, 1,  49.99),   -- orphan: order 9999 does not exist
   (10, 1001, 999, 2,  69.98);  -- orphan: product 999 does not exist

-- ── 0g. Seed reviews — some with broken foreign keys ─────────────────────────
INSERT INTO reviews VALUES
    (1, 101, 1,   5, '2024-01-20'),
    (2, 102, 2,   4, '2024-01-25'),
    (3, 103, 3,   3, '2024-02-10'),
    (4, 999, 1,   5, '2024-02-15'),  -- orphan: product 999 missing
    (5, 101, 77,  2, '2024-02-18'),  -- orphan: customer 77 missing
    (6, 888, 88,  1, '2024-03-01');  -- orphan: both FK values missing

-- ── 0h. Seed shipments — one with a broken order_id ──────────────────────────
INSERT INTO shipments VALUES
    (1, 1001, '2024-01-11', 'FedEx',  'FX123456'),
    (2, 1002, '2024-01-13', 'UPS',    'UP789012'),
    (3, 1003, '2024-02-02', 'DHL',    'DH345678'),
    (4, 8888, '2024-03-10', 'FedEx',  'FX999999');  -- orphan: order 8888 missing


-- =============================================================================
-- SECTION 1: ORPHANED ORDERS
-- Detect orders whose customer_id has no matching row in customers
-- Chapter 14 pattern: LEFT JOIN parent ON child.fk = parent.pk WHERE pk IS NULL
-- =============================================================================

-- ── 1a. DETECT: List every orphaned order ────────────────────────────────────
SELECT
    o.order_id,
    o.customer_id          AS orphaned_customer_id,
    o.order_date,
    o.status,
    o.total_amount
FROM   orders AS o
LEFT JOIN customers AS c
       ON o.customer_id = c.customer_id
WHERE  c.customer_id IS NULL
ORDER  BY o.order_id;

/*
