-- =============================================================================
-- Chapter 9: Common Table Expressions — Writing SQL That Humans Can Actually Read
-- The Science of Learning SQL: An Evidence-Based, Step-by-Step Guide to
-- Mastering Databases, Queries, Joins, and Real-World Data Analysis
-- for Complete Beginners
--
-- PURPOSE:
--   Executable, annotated SQL scripts covering every major CTE concept from
--   Chapter 9:
--     1.  Setup — practice tables and sample data
--     2.  The problem: deeply nested subqueries
--     3.  Single CTE replacing a nested subquery
--     4.  Chained (multi-step) CTEs
--     5.  Recursive CTEs — org-chart traversal
--     6.  CTEs vs. subqueries vs. temporary tables comparison
--     7.  Chapter exercises with worked solutions
--
--   Run these scripts in order against any SQLite, PostgreSQL, or MySQL 8+
--   instance.  Syntax notes for each engine are provided where they differ.
--
--   COMPATIBILITY NOTES:
--     • SQLite  3.35+  : all scripts work as written
--     • PostgreSQL 12+ : all scripts work as written
--     • MySQL 8.0+     : all scripts work as written
--     • MySQL < 8      : CTEs are NOT supported; upgrade or use temp tables
-- =============================================================================


-- =============================================================================
-- SECTION 0: SETUP — Create and Populate Practice Tables
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 0-A: employees table
--      Used for single-CTE, chained-CTE, and recursive org-chart examples.
--      The manager_id column creates the hierarchy: every employee either
--      points to their manager or has NULL (= top of the org chart).
-- -----------------------------------------------------------------------------

DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    employee_id   INTEGER      PRIMARY KEY,
    full_name     VARCHAR(60)  NOT NULL,
    department    VARCHAR(40)  NOT NULL,
    job_title     VARCHAR(60)  NOT NULL,
    salary        DECIMAL(10,2) NOT NULL,
    hire_date     DATE         NOT NULL,
    manager_id    INTEGER      REFERENCES employees(employee_id)
    -- NULL manager_id means this person is the root of the hierarchy (CEO/MD)
);

INSERT INTO employees (employee_id, full_name, department, job_title, salary, hire_date, manager_id)
VALUES
-- Level 0 — the root (no manager)
(1,  'Amara Osei',         'Executive',    'Chief Executive Officer',      180000.00, '2015-03-01', NULL),

-- Level 1 — direct reports to the CEO
(2,  'Beatriz Sousa',      'Engineering',  'VP of Engineering',            140000.00, '2016-06-15', 1),
(3,  'Carlos Mendez',      'Sales',        'VP of Sales',                  135000.00, '2016-09-01', 1),
(4,  'Diana Petrov',       'Finance',      'Chief Financial Officer',      145000.00, '2017-01-10', 1),

-- Level 2 — managers reporting to VPs
(5,  'Ethan Clarke',       'Engineering',  'Engineering Manager',          110000.00, '2018-02-20', 2),
(6,  'Fatima Al-Hassan',   'Engineering',  'Engineering Manager',          108000.00, '2018-05-14', 2),
(7,  'George Tanaka',      'Sales',        'Sales Manager',                 95000.00, '2018-07-01', 3),
(8,  'Hannah Müller',      'Finance',      'Finance Manager',              100000.00, '2018-11-30', 4),

-- Level 3 — individual contributors
(9,  'Ivan Petrov',        'Engineering',  'Senior Software Engineer',      90000.00, '2019-03-15', 5),
(10, 'Julia Santos',       'Engineering',  'Software Engineer',             78000.00, '2020-06-01', 5),
(11, 'Kevin Okafor',       'Engineering',  'Software Engineer',             76000.00, '2020-08-15', 5),
(12, 'Layla Nasser',       'Engineering',  'Senior Software Engineer',      88000.00, '2019-11-01', 6),
(13, 'Marcus Webb',        'Engineering',  'Junior Software Engineer',      65000.00, '2021-01-10', 6),
(14, 'Nina Johansson',     'Sales',        'Account Executive',             72000.00, '2019-04-22', 7),
(15, 'Omar Farouq',        'Sales',        'Account Executive',             70000.00, '2019-09-01', 7),
(16, 'Priya Sharma',       'Sales',        'Sales Development Rep',         58000.00, '2021-03-15', 7),
(17, 'Quentin Dubois',     'Finance',      'Financial Analyst',             75000.00, '2020-02-01', 8),
(18, 'Rosa Lima',          'Finance',      'Financial Analyst',             73000.00, '2020-07-20', 8);


-- -----------------------------------------------------------------------------
-- 0-B: orders and order_items tables
--      Used for the chained multi-CTE example (multi-step sales analysis).
-- -----------------------------------------------------------------------------

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    order_id      INTEGER       PRIMARY KEY,
    customer_id   INTEGER       NOT NULL,
    order_date    DATE          NOT NULL,
    status        VARCHAR(20)   NOT NULL   -- 'completed', 'pending', 'cancelled'
);

CREATE TABLE order_items (
    item_id       INTEGER       PRIMARY KEY,
    order_id      INTEGER       NOT NULL   REFERENCES orders(order_id),
    product_name  VARCHAR(80)   NOT NULL,
    category      VARCHAR(40)   NOT NULL,
    quantity      INTEGER       NOT NULL,
    unit_price    DECIMAL(10,2) NOT NULL
);

INSERT INTO orders (order_id, customer_id, order_date, status) VALUES
(1001, 201, '2023-01-05', 'completed'),
(1002, 202, '2023-01-12', 'completed'),
(1003, 203, '2023-02-03', 'cancelled'),
(1004, 201, '2023-02-18', 'completed'),
(1005, 204, '2023-03-07', 'completed'),
(1006, 205, '2023-03-22', 'pending'),
(1007, 202, '2023-04-10', 'completed'),
(1008, 203, '2023-04-29', 'completed'),
(1009, 206, '2023-05-14', 'completed'),
(1010, 204, '2023-05-30', 'cancelled');

INSERT INTO order_items (item_id, order_id, product_name, category, quantity, unit_price) VALUES
(1,  1001, 'Wireless Keyboard',   'Electronics',  2,  45.99),
(2,  1001, 'USB-C Hub',           'Electronics',  1,  29.99),
(3,  1002, 'Desk Lamp',           'Office',       3,  22.50),
(4,  1002, 'Notebook Pack',       'Stationery',   5,   8.99),
(5,  1003, 'Monitor Stand',       'Office',       1,  55.00),   -- cancelled order
(6,  1004, 'Wireless Mouse',      'Electronics',  1,  39.99),
(7,  1004, 'Mousepad XL',         'Office',       2,  18.00),
(8,  1005, 'Mechanical Keyboard', 'Electronics',  1, 129.00),
(9,  1005, 'Webcam HD',           'Electronics',  1,  89.99),
(10, 1006, 'Standing Desk Mat',   'Office',       1,  45.00),   -- pending order
(11, 1007, 'USB-C Hub',           'Electronics',  2,  29.99),
(12, 1007, 'HDMI Cable 2m',       'Electronics',  3,  12.99),
(13, 1008, 'Notebook Pack',       'Stationery',  10,   8.99),
(14, 1008, 'Pen Set',             'Stationery',   4,   6.50),
(15, 1009, 'Webcam HD',           'Electronics',  2,  89.99),
(16, 1009, 'Ring Light',          'Electronics',  1,  65.00),
(17, 1010, 'Desk Lamp',           'Office',       2,  22.50);   -- cancelled order


-- =============================================================================
-- SECTION 1: THE PROBLEM — Deeply Nested Subqueries
-- =============================================================================
-- Chapter 9 opens by showing how analytical queries grow into illegible nests.
-- The reader must mentally unwind every layer before grasping the intent.
-- This example finds departments whose average salary exceeds the company-wide
-- average, then lists employees in those departments who earn above their own
-- department average.  Written as nested subqueries, intent is buried.
-- =============================================================================

-- ❌ HARD TO READ — three levels of nesting obscure what we are asking
SELECT
    e.full_name,
    e.department,
    e.salary
FROM employees AS e
WHERE e.department IN (
    -- Which departments beat the company average?
    SELECT department
    FROM employees
    GROUP BY department
    HAVING AVG(salary) > (
        -- What is the company-wide average salary?
        SELECT AVG(salary)
        FROM employees
    )
)
AND e.salary > (
    --
