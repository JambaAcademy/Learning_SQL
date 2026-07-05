-- =============================================================================
-- JOINS CHALLENGE EXERCISE SET
-- The Science of Learning SQL: An Evidence-Based, Step-by-Step Guide to
-- Mastering Databases, Queries, Joins, and Real-World Data Analysis
-- for Complete Beginners
--
-- Related Chapter: Chapter 7 — Joins Demystified: Combining Data From
-- Multiple Tables Without Losing Your Mind
--
-- Purpose: This exercise set applies spaced repetition and active recall
-- principles from Chapter 1 to reinforce join concepts introduced in
-- Chapter 7. Each exercise builds on the previous one, following the
-- progressive skill layering model: every new join type rests on a
-- foundation your brain has already consolidated.
--
-- Instructions: Work through each exercise in order. Before running any
-- statement, predict what the output will look like. This active recall
-- step — not passive reading — is what builds durable SQL fluency.
--
-- Schema used throughout: a small retail database with four tables:
--   customers, orders, products, order_items
-- =============================================================================


-- =============================================================================
-- SECTION 0: SCHEMA AND SAMPLE DATA SETUP
-- Run this section first to create the practice environment.
-- These tables model the relational principle from Chapter 2: data is
-- deliberately split across tables to eliminate redundancy, which is
-- exactly why joins are essential rather than optional.
-- =============================================================================

-- Drop tables if they already exist so the script is safely re-runnable.
-- The order matters: child tables (with foreign keys) must be dropped before
-- the parent tables they reference.

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

-- customers table
-- Each row is one complete individual record (Chapter 2).
-- customer_id is the primary key — it uniquely identifies every customer
-- and gives each row a reliable, permanent address.

CREATE TABLE customers (
    customer_id   INTEGER      NOT NULL,
    first_name    VARCHAR(50)  NOT NULL,
    last_name     VARCHAR(50)  NOT NULL,
    city          VARCHAR(50),
    email         VARCHAR(100),
    PRIMARY KEY (customer_id)
);

-- products table
-- product_id is the primary key.
-- category allows GROUP BY analysis from Chapter 6.

CREATE TABLE products (
    product_id    INTEGER       NOT NULL,
    product_name  VARCHAR(100)  NOT NULL,
    category      VARCHAR(50),
    unit_price    DECIMAL(8,2)  NOT NULL,
    stock_qty     INTEGER       NOT NULL DEFAULT 0,
    PRIMARY KEY (product_id)
);

-- orders table
-- order_id is the primary key.
-- customer_id is a foreign key linking back to customers — this is the
-- shared key that makes cross-table queries possible (Chapter 2 & 7).
-- Notice that order_id 1006 references customer_id 9, which does NOT
-- exist in the customers table. This intentional orphan row lets you
-- observe how different join types handle unmatched records.

CREATE TABLE orders (
    order_id      INTEGER      NOT NULL,
    customer_id   INTEGER,
    order_date    DATE         NOT NULL,
    status        VARCHAR(20)  NOT NULL DEFAULT 'pending',
    PRIMARY KEY (order_id)
);

-- order_items table
-- Links orders to products. Each row records one product line within one order.
-- Both order_id and product_id are foreign keys — this table sits at the
-- intersection of two relationships, making it a classic junction table.

CREATE TABLE order_items (
    item_id       INTEGER       NOT NULL,
    order_id      INTEGER       NOT NULL,
    product_id    INTEGER       NOT NULL,
    quantity      INTEGER       NOT NULL,
    sale_price    DECIMAL(8,2)  NOT NULL,
    PRIMARY KEY (item_id)
);

-- -------------------------
-- Insert customer records
-- -------------------------
-- customer_id 7 has no orders — useful for LEFT JOIN exercises.
-- customer_id 9 is intentionally absent — order 1006 will be an orphan.

INSERT INTO customers (customer_id, first_name, last_name, city, email)
VALUES
    (1,  'Amara',   'Osei',      'Chicago',     'amara.osei@email.com'),
    (2,  'Lena',    'Fischer',   'Berlin',      'lena.fischer@email.com'),
    (3,  'Carlos',  'Mendez',    'Madrid',      'carlos.mendez@email.com'),
    (4,  'Priya',   'Sharma',    'Mumbai',      'priya.sharma@email.com'),
    (5,  'James',   'Whitfield', 'London',      'james.whitfield@email.com'),
    (6,  'Yuki',    'Tanaka',    'Tokyo',       NULL),
    (7,  'Fatima',  'Al-Hassan', 'Dubai',       'fatima.alhassan@email.com'),
    (8,  'Marco',   'Rossi',     'Rome',        'marco.rossi@email.com');

-- -------------------------
-- Insert product records
-- -------------------------

INSERT INTO products (product_id, product_name, category, unit_price, stock_qty)
VALUES
    (101, 'Wireless Keyboard',   'Electronics',  49.99,  120),
    (102, 'USB-C Hub',           'Electronics',  34.99,   85),
    (103, 'Desk Lamp',           'Office',        24.99,  200),
    (104, 'Ergonomic Mouse',     'Electronics',  39.99,   60),
    (105, 'Notebook Set',        'Stationery',    12.99,  350),
    (106, 'Monitor Stand',       'Office',        59.99,   40),
    (107, 'Mechanical Keyboard', 'Electronics', 129.99,   25),
    (108, 'Cable Organiser',     'Office',         9.99,  500),
    (109, 'Webcam HD',           'Electronics',  79.99,   30);

-- -------------------------
-- Insert order records
-- -------------------------
-- order 1006 uses customer_id 9 which does not exist — intentional orphan.

INSERT INTO orders (order_id, customer_id, order_date, status)
VALUES
    (1001, 1, '2024-01-15', 'completed'),
    (1002, 2, '2024-01-22', 'completed'),
    (1003, 3, '2024-02-05', 'shipped'),
    (1004, 4, '2024-02-18', 'completed'),
    (1005, 1, '2024-03-02', 'pending'),
    (1006, 9, '2024-03-10', 'completed'),
    (1007, 5, '2024-03-14', 'shipped'),
    (1008, 6, '2024-03-20', 'pending'),
    (1009, 8, '2024-04-01', 'completed');

-- -------------------------
-- Insert order_items records
-- -------------------------
-- product_id 109 (Webcam HD) appears in no order_items rows — useful for
-- demonstrating how a RIGHT JOIN or FULL OUTER JOIN surfaces unmatched products.

INSERT INTO order_items (item_id, order_id, product_id, quantity, sale_price)
VALUES
    (1,  1001, 101, 1,  49.99),
    (2,  1001, 103, 2,  24.99),
    (3,  1002, 102, 1,  34.99),
    (4,  1002, 104, 1,  39.99),
    (5,  1003, 105, 3,  12.99),
    (6,  1003, 106, 1,  59.99),
    (7,  1004, 107, 1, 129.99),
    (8,  1005, 108, 4,   9.99),
    (9,  1006, 101, 2,  49.99),
    (10, 1007, 102, 1,  34.99),
    (11, 1007, 103, 1,  24.99),
    (12, 1008, 104, 2,  39.99),
    (13, 1009, 105, 5,  12.99),
    (14, 1009, 106, 1,  59.99);


-- =============================================================================
-- SECTION 1: CONCEPTUAL WARM-UP EXERCISES
-- Before writing joins, confirm you understand WHY they exist.
-- These queries inspect individual tables so you can predict join behaviour.
-- =============================================================================

-- EXERCISE 1A — Inspect the customers table
-- Active recall prompt: How many customers are there? Which customer has
-- no email? Which customer_id is intentionally absent (9)?
-- Connecting to Chapter 2: each row is one complete individual record.

SELECT
    customer_id,
    first_name,
    last_name,
    city,
    email
FROM customers
ORDER BY customer_id;

-- EXERCISE 1B — Inspect the orders table
-- Active recall prompt: Which order references customer_id 9?
-- That customer does not exist in the customers table. Predict what an
-- INNER JOIN will do with that row versus what a RIGHT JOIN will do.

SELECT
    order_id,
    customer_id,
    order_date,
    status
FROM orders
ORDER BY order_id;

-- EXERCISE 1C — Identify the customer with no orders
-- Chapter 7 principle: a LEFT JOIN keeps all rows from the left table
-- regardless of matches. Find which customer_id never appears in orders.
-- This is the row a LEFT JOIN will preserve that an INNER JOIN will drop.

SELECT customer_id
FROM customers
WHERE customer_id NOT IN (
    SELECT customer_id
    FROM orders
    WHERE customer_id IS NOT NULL
);

-- Expected result: customer_id 7 (Fatima Al-Hassan) has placed no orders.

-- EXERCISE 1D — Inspect order_items to find the unordered product
