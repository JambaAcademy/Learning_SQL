-- =============================================================================
-- Chapter 7 Join Type Demonstration Scripts
-- "The Science of Learning SQL: An Evidence-Based, Step-by-Step Guide to
--  Mastering Databases, Queries, Joins, and Real-World Data Analysis
--  for Complete Beginners"
--
-- Purpose:
--   Provide fully runnable, annotated SQL demonstrations for every join type
--   covered in Chapter 7: Joins Demystified. Each section builds on the
--   chapter's core ideas:
--     1. Why joins exist (eliminating redundancy across tables)
--     2. How a shared key links rows without modifying the original tables
--     3. INNER JOIN  -- matched rows only
--     4. LEFT JOIN   -- all left-table rows, matched or not
--     5. RIGHT JOIN  -- all right-table rows, matched or not
--     6. FULL OUTER JOIN -- every row from both sides
--     7. Chaining three or more tables in a single query
--     8. The Cartesian product danger (missing or wrong JOIN condition)
--
-- Run environment: Standard ANSI SQL (compatible with PostgreSQL, MySQL 8+,
--   SQLite 3.39+, and SQL Server with minor dialect notes where flagged).
-- =============================================================================


-- =============================================================================
-- SECTION 0: BUILD THE SAMPLE SCHEMA
-- =============================================================================

-- The chapter explains that relational databases deliberately split data across
-- tables to eliminate redundancy. We model a small retail scenario with four
-- tables: customers, orders, order_items, and products. Each table stores one
-- kind of fact; joins reunite the facts at query time without duplicating data.

-- Drop tables if they already exist so the script is safe to re-run.
-- (Use DROP TABLE IF EXISTS -- standard in most modern engines.)

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS employees;

-- -------------------------------------------------------------------------
-- customers: one row per customer
-- customer_id is the primary key that other tables reference as a foreign key.
-- -------------------------------------------------------------------------
CREATE TABLE customers (
    customer_id   INTEGER      PRIMARY KEY,
    first_name    VARCHAR(50)  NOT NULL,
    last_name     VARCHAR(50)  NOT NULL,
    email         VARCHAR(100),
    city          VARCHAR(50)
);

-- -------------------------------------------------------------------------
-- products: one row per product in the catalogue
-- -------------------------------------------------------------------------
CREATE TABLE products (
    product_id    INTEGER      PRIMARY KEY,
    product_name  VARCHAR(100) NOT NULL,
    category      VARCHAR(50),
    unit_price    DECIMAL(8,2) NOT NULL
);

-- -------------------------------------------------------------------------
-- orders: one row per order placed by a customer
-- customer_id is the shared key that links orders back to customers.
-- -------------------------------------------------------------------------
CREATE TABLE orders (
    order_id      INTEGER      PRIMARY KEY,
    customer_id   INTEGER,     -- foreign key referencing customers.customer_id
    order_date    DATE         NOT NULL,
    status        VARCHAR(20)  DEFAULT 'pending'
);

-- -------------------------------------------------------------------------
-- order_items: one row per line item within an order
-- Links to both orders (via order_id) and products (via product_id).
-- -------------------------------------------------------------------------
CREATE TABLE order_items (
    item_id       INTEGER      PRIMARY KEY,
    order_id      INTEGER,     -- foreign key referencing orders.order_id
    product_id    INTEGER,     -- foreign key referencing products.product_id
    quantity      INTEGER      NOT NULL,
    line_price    DECIMAL(8,2) NOT NULL
);

-- -------------------------------------------------------------------------
-- departments and employees: used later to demonstrate RIGHT JOIN clearly
-- -------------------------------------------------------------------------
CREATE TABLE departments (
    dept_id       INTEGER      PRIMARY KEY,
    dept_name     VARCHAR(50)  NOT NULL
);

CREATE TABLE employees (
    employee_id   INTEGER      PRIMARY KEY,
    full_name     VARCHAR(100) NOT NULL,
    dept_id       INTEGER      -- NULL means not yet assigned to a department
);


-- =============================================================================
-- SECTION 1: POPULATE THE TABLES WITH REALISTIC SAMPLE DATA
-- =============================================================================

-- Insert customers -- note customer_id 5 (Elena Marsh) will have NO orders,
-- which is essential for demonstrating LEFT JOIN unmatched rows later.
INSERT INTO customers VALUES (1, 'Alice',  'Nguyen',   'alice@example.com',  'Chicago');
INSERT INTO customers VALUES (2, 'Bob',    'Okafor',   'bob@example.com',    'Houston');
INSERT INTO customers VALUES (3, 'Carmen', 'Reyes',    'carmen@example.com', 'Phoenix');
INSERT INTO customers VALUES (4, 'David',  'Kim',      'david@example.com',  'Chicago');
INSERT INTO customers VALUES (5, 'Elena',  'Marsh',    'elena@example.com',  'Seattle');

-- Insert products -- product_id 5 (Desk Lamp) will have NO order_items,
-- useful for FULL OUTER JOIN demonstrations.
INSERT INTO products VALUES (1, 'Wireless Keyboard', 'Electronics', 49.99);
INSERT INTO products VALUES (2, 'Ergonomic Mouse',   'Electronics', 34.99);
INSERT INTO products VALUES (3, 'Notebook Set',      'Stationery',  12.50);
INSERT INTO products VALUES (4, 'Standing Desk Mat', 'Office',      59.00);
INSERT INTO products VALUES (5, 'Desk Lamp',         'Office',      27.99);

-- Insert orders -- order_id 4 references customer_id 9, which does NOT exist
-- in the customers table. This orphaned foreign key will show up in RIGHT JOIN
-- and FULL OUTER JOIN results but will be absent from INNER JOIN results.
INSERT INTO orders VALUES (1, 1, '2024-01-10', 'shipped');
INSERT INTO orders VALUES (2, 2, '2024-01-15', 'delivered');
INSERT INTO orders VALUES (3, 3, '2024-02-01', 'pending');
INSERT INTO orders VALUES (4, 9, '2024-02-14', 'pending');  -- customer_id 9 is orphaned

-- Insert order_items -- covers products 1-4; product 5 (Desk Lamp) is never ordered.
INSERT INTO order_items VALUES (1, 1, 1, 2, 99.98);   -- order 1: 2x Wireless Keyboard
INSERT INTO order_items VALUES (2, 1, 3, 1, 12.50);   -- order 1: 1x Notebook Set
INSERT INTO order_items VALUES (3, 2, 2, 1, 34.99);   -- order 2: 1x Ergonomic Mouse
INSERT INTO order_items VALUES (4, 3, 4, 1, 59.00);   -- order 3: 1x Standing Desk Mat
INSERT INTO order_items VALUES (5, 4, 1, 1, 49.99);   -- order 4 (orphaned): 1x Keyboard

-- Insert departments -- dept_id 3 (Legal) has no employees assigned.
INSERT INTO departments VALUES (1, 'Engineering');
INSERT INTO departments VALUES (2, 'Marketing');
INSERT INTO departments VALUES (3, 'Legal');

-- Insert employees -- employee_id 4 (Sam) has NULL dept_id (unassigned).
INSERT INTO employees VALUES (1, 'Priya Patel',   1);
INSERT INTO employees VALUES (2, 'Jordan Lee',    2);
INSERT INTO employees VALUES (3, 'Marcus Webb',   1);
INSERT INTO employees VALUES (4, 'Sam Torres',    NULL);


-- =============================================================================
-- SECTION 2: THE CARTESIAN PRODUCT WARNING
-- =============================================================================

-- Chapter 7 warns that a missing JOIN condition silently multiplies every row
-- in one table with every row in the other, producing a Cartesian product.
-- With 5 customers and 4 orders, the result has 5 x 4 = 20 rows -- none of
-- which represent real customer-order relationships.
--
-- DO NOT use this pattern in real analysis. It is shown here purely to
-- illustrate the danger the chapter describes.

-- DANGER EXAMPLE: Cartesian product (no JOIN condition)
-- Expected row count: 5 customers x 4 orders = 20 rows
SELECT
    c.customer_id,
    c.first_name,
    o.order_id,
    o.order_date
FROM customers c, orders o   -- old-style comma syntax with no WHERE condition
ORDER BY c.customer_id, o.order_id;

-- The same accidental Cartesian product can happen with modern JOIN syntax
-- if you forget the ON clause (some engines raise a syntax error; others allow it).
-- This query is intentionally left commented out to avoid breaking the script,
-- but the pattern to avoid looks like:
--
--   SELECT * FROM customers JOIN orders;   -- missing ON clause = Cartesian product
--
-- Always verify your row count makes sense before trusting JOIN results.


-- =============================================================================
-- SECTION 3: INNER JOIN -- ONLY ROWS THAT MATCH ON BOTH SIDES
-- =============================================================================

-- Chapter 7 defines INNER JOIN as returning only the rows where the shared key
-- exists in BOTH tables. Rows with no match on either side are discarded.
--
-- Here we join customers to orders on the shared key customer_id.
-- Expected result: 3 rows (customers 1, 2, 3 each have one order).
-- Customer 5 (Elena, no orders) is excluded.
-- Order 4 (orphaned customer_id 9) is excluded because no customer row matches.

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    o.order_id,
    o.order_date,
    o.status
FROM customers AS c
INNER JOIN orders AS o
    ON c.customer_id = o.customer_id   -- shared key: the JOIN condition
ORDER BY c.customer_id;

-- -------------------------------------------------------------------------
-- Practical INNER JOIN: show each customer's total spending
-- Only customers who have placed at least one order appear in the result.
-- -------------------------------------------------------------------------

SELECT
    c.customer_id,
    c.first_name ||
