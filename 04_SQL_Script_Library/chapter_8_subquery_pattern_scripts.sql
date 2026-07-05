-- =============================================================================
-- Chapter 8 Subquery Pattern Scripts
-- The Science of Learning SQL: An Evidence-Based, Step-by-Step Guide to
-- Mastering Databases, Queries, Joins, and Real-World Data Analysis
-- for Complete Beginners
--
-- Chapter 8: Advanced Filtering With Subqueries — Queries Inside Queries
--
-- Purpose:
--   This script demonstrates every major subquery pattern introduced in
--   Chapter 8.  Each section is self-contained and runnable in sequence.
--   The inner query always executes first; its result is handed to the
--   outer query exactly as if you had typed a literal value.  Working
--   through these examples will show you how subqueries eliminate fragile
--   hardcoded values, let you filter against computed results, identify
--   missing records, and build temporary derived tables — all inside a
--   single executable statement.
--
-- Schema assumed throughout this script:
--   employees  (employee_id, first_name, last_name, department_id, salary,
--               hire_date, manager_id)
--   departments(department_id, department_name, location)
--   orders     (order_id, customer_id, order_date, total_amount, status)
--   customers  (customer_id, first_name, last_name, email, region)
--   products   (product_id, product_name, category, unit_price, stock_qty)
--   order_items(order_item_id, order_id, product_id, quantity, line_total)
--
-- Run these CREATE / INSERT blocks first to build the practice data set,
-- then work through each numbered section in order.
-- =============================================================================


-- =============================================================================
-- SECTION 0: BUILD THE PRACTICE SCHEMA AND SAMPLE DATA
-- =============================================================================

-- Drop tables if they already exist so the script is safely re-runnable.
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;

-- departments: referenced by employees
CREATE TABLE departments (
    department_id   INTEGER PRIMARY KEY,
    department_name VARCHAR(60)  NOT NULL,
    location        VARCHAR(60)
);

-- employees: the main workforce table used throughout Chapter 8 examples
CREATE TABLE employees (
    employee_id   INTEGER PRIMARY KEY,
    first_name    VARCHAR(40) NOT NULL,
    last_name     VARCHAR(40) NOT NULL,
    department_id INTEGER     REFERENCES departments(department_id),
    salary        NUMERIC(10,2),
    hire_date     DATE,
    manager_id    INTEGER     REFERENCES employees(employee_id)
);

-- customers: used in IN / NOT IN and correlated subquery examples
CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    first_name  VARCHAR(40) NOT NULL,
    last_name   VARCHAR(40) NOT NULL,
    email       VARCHAR(80),
    region      VARCHAR(40)
);

-- orders: used for scalar, IN, and derived-table subquery examples
CREATE TABLE orders (
    order_id     INTEGER PRIMARY KEY,
    customer_id  INTEGER REFERENCES customers(customer_id),
    order_date   DATE,
    total_amount NUMERIC(10,2),
    status       VARCHAR(20)
);

-- products: used in NOT IN and correlated subquery examples
CREATE TABLE products (
    product_id   INTEGER PRIMARY KEY,
    product_name VARCHAR(80) NOT NULL,
    category     VARCHAR(40),
    unit_price   NUMERIC(10,2),
    stock_qty    INTEGER
);

-- order_items: line-level detail linking orders to products
CREATE TABLE order_items (
    order_item_id INTEGER PRIMARY KEY,
    order_id      INTEGER REFERENCES orders(order_id),
    product_id    INTEGER REFERENCES products(product_id),
    quantity      INTEGER,
    line_total    NUMERIC(10,2)
);

-- ---- Seed departments -------------------------------------------------------
INSERT INTO departments VALUES (1, 'Engineering',  'New York');
INSERT INTO departments VALUES (2, 'Marketing',    'Chicago');
INSERT INTO departments VALUES (3, 'Finance',      'New York');
INSERT INTO departments VALUES (4, 'Sales',        'Los Angeles');
INSERT INTO departments VALUES (5, 'HR',           'Chicago');

-- ---- Seed employees ---------------------------------------------------------
-- Manager rows inserted first so foreign-key references resolve cleanly.
INSERT INTO employees VALUES (1,  'Diana',   'Reeves',  1, 98000.00, '2015-03-10', NULL);
INSERT INTO employees VALUES (2,  'Marcus',  'Holt',    2, 75000.00, '2016-07-22', NULL);
INSERT INTO employees VALUES (3,  'Priya',   'Anand',   3, 82000.00, '2017-01-15', NULL);
INSERT INTO employees VALUES (4,  'James',   'Okafor',  4, 67000.00, '2018-09-05', NULL);
INSERT INTO employees VALUES (5,  'Lucia',   'Torres',  5, 58000.00, '2019-04-30', NULL);
INSERT INTO employees VALUES (6,  'Ben',     'Shapiro', 1, 91000.00, '2015-11-20', 1);
INSERT INTO employees VALUES (7,  'Aisha',   'Kamara',  1, 74000.00, '2020-02-14', 1);
INSERT INTO employees VALUES (8,  'Tom',     'Nguyen',  2, 62000.00, '2021-06-01', 2);
INSERT INTO employees VALUES (9,  'Sara',    'Webb',    3, 79000.00, '2019-08-19', 3);
INSERT INTO employees VALUES (10, 'Carlos',  'Ruiz',    4, 54000.00, '2022-03-07', 4);
INSERT INTO employees VALUES (11, 'Mei',     'Zhang',   1, 105000.00,'2013-05-28', 1);
INSERT INTO employees VALUES (12, 'Oliver',  'Grant',   2, 71000.00, '2020-10-11', 2);
INSERT INTO employees VALUES (13, 'Fatima',  'Al-Said', 3, 88000.00, '2016-12-03', 3);
INSERT INTO employees VALUES (14, 'Derek',   'Moss',    4, 49000.00, '2023-01-16', 4);
INSERT INTO employees VALUES (15, 'Yuki',    'Tanaka',  5, 61000.00, '2021-09-22', 5);

-- ---- Seed customers ---------------------------------------------------------
INSERT INTO customers VALUES (1,  'Alice',   'Marsh',    'alice@example.com',   'East');
INSERT INTO customers VALUES (2,  'Bob',     'Finley',   'bob@example.com',     'West');
INSERT INTO customers VALUES (3,  'Carol',   'Dunn',     'carol@example.com',   'East');
INSERT INTO customers VALUES (4,  'David',   'Park',     'david@example.com',   'Central');
INSERT INTO customers VALUES (5,  'Eve',     'Lawson',   'eve@example.com',     'West');
INSERT INTO customers VALUES (6,  'Frank',   'Adler',    'frank@example.com',   'East');
INSERT INTO customers VALUES (7,  'Grace',   'Kim',      'grace@example.com',   'Central');
INSERT INTO customers VALUES (8,  'Henry',   'Owens',    'henry@example.com',   'West');
INSERT INTO customers VALUES (9,  'Irene',   'Bloom',    'irene@example.com',   'East');
INSERT INTO customers VALUES (10, 'Jack',    'Mercer',   'jack@example.com',    'Central');

-- ---- Seed products ----------------------------------------------------------
INSERT INTO products VALUES (1,  'Wireless Keyboard', 'Peripherals', 49.99,  200);
INSERT INTO products VALUES (2,  'USB-C Hub',         'Peripherals', 34.99,  150);
INSERT INTO products VALUES (3,  'Laptop Stand',      'Accessories', 29.99,   80);
INSERT INTO products VALUES (4,  'Monitor 27in',      'Displays',   349.99,   40);
INSERT INTO products VALUES (5,  'Noise-Cancel Headphones', 'Audio',129.99,   60);
INSERT INTO products VALUES (6,  'Webcam HD',         'Peripherals', 79.99,   90);
INSERT INTO products VALUES (7,  'Ergonomic Mouse',   'Peripherals', 44.99,  175);
INSERT INTO products VALUES (8,  'Desk Lamp LED',     'Accessories', 24.99,  300);
INSERT INTO products VALUES (9,  'SSD 1TB',           'Storage',    109.99,  120);
INSERT INTO products VALUES (10, 'Mechanical Keyboard','Peripherals',89.99,   55);

-- ---- Seed orders ------------------------------------------------------------
INSERT INTO orders VALUES (1001, 1,  '2024-01-05', 214.97, 'Completed');
INSERT INTO orders VALUES (1002, 2,  '2024-01-12', 349.99, 'Completed');
INSERT INTO orders VALUES (1003, 3,  '2024-01-18',  74.98, 'Completed');
INSERT INTO orders VALUES (1004, 4,  '2024-02-02', 129.99, 'Completed');
INSERT INTO orders VALUES (1005, 1,  '2024-02-14', 109.99, 'Completed');
INSERT INTO orders VALUES (1006, 5,  '2024-02-20', 469.97, 'Completed');
INSERT INTO orders VALUES (1007, 6,  '2024-03-01',  44.99, 'Completed');
INSERT INTO orders VALUES (1008, 7,  '2024-03-15', 259.98, 'Completed');
INSERT INTO orders VALUES (1009, 2,
