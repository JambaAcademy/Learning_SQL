-- =============================================================================
-- SQL INTERVIEW PRACTICE QUESTION BANK
-- "The Science of Learning SQL: An Evidence-Based, Step-by-Step Guide to
--  Mastering Databases, Queries, Joins, and Real-World Data Analysis
--  for Complete Beginners"
--
-- PURPOSE:
--   This script provides a structured bank of interview-style SQL questions and
--   model answers drawn directly from the book's eight core chapters. Each
--   section maps to one chapter, reinforcing spaced repetition and active recall
--   as recommended in Chapter 1. Work through these questions independently
--   first, then compare your output to the annotated model answers below.
--
-- CHAPTERS COVERED:
--   Ch 1 - Cognitive Science of SQL Learning
--   Ch 2 - Relational Database Architecture
--   Ch 3 - SELECT Statements
--   Ch 4 - Filtering With WHERE
--   Ch 5 - Sorting and Limiting Results
--   Ch 6 - Aggregate Functions and GROUP BY
--   Ch 7 - Joins
--   Ch 8 - Subqueries
--
-- DIALECT: Standard ANSI SQL (compatible with PostgreSQL, MySQL, SQLite,
--          SQL Server with minor adjustments noted inline)
-- =============================================================================


-- =============================================================================
-- SECTION 0: SCHEMA SETUP
-- Build the practice database used throughout all interview questions.
-- These tables mirror the relational structure described in Chapter 2:
-- separate, interconnected tables, each row a single record, each column
-- a specific data type, primary keys for unique identification, and foreign
-- keys to link tables together.
-- =============================================================================

-- Drop tables in reverse dependency order so foreign key constraints
-- do not block re-creation when you run this script multiple times.
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS regions;

-- -----------------------------------------------------------------------
-- regions: a lookup table with no foreign key dependencies.
-- Primary key: region_id uniquely identifies every row (Ch 2).
-- -----------------------------------------------------------------------
CREATE TABLE regions (
    region_id   INTEGER      PRIMARY KEY,
    region_name VARCHAR(50)  NOT NULL
);

-- -----------------------------------------------------------------------
-- departments: links to regions via a foreign key (Ch 2).
-- -----------------------------------------------------------------------
CREATE TABLE departments (
    department_id   INTEGER      PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    region_id       INTEGER      REFERENCES regions(region_id)
);

-- -----------------------------------------------------------------------
-- employees: each row is one individual employee record (Ch 2).
-- manager_id is a self-referencing foreign key (an employee's own manager).
-- -----------------------------------------------------------------------
CREATE TABLE employees (
    employee_id   INTEGER      PRIMARY KEY,
    first_name    VARCHAR(50)  NOT NULL,
    last_name     VARCHAR(50)  NOT NULL,
    department_id INTEGER      REFERENCES departments(department_id),
    hire_date     DATE,
    salary        NUMERIC(10,2),
    manager_id    INTEGER      REFERENCES employees(employee_id)
);

-- -----------------------------------------------------------------------
-- customers: each row is one customer record.
-- -----------------------------------------------------------------------
CREATE TABLE customers (
    customer_id   INTEGER      PRIMARY KEY,
    first_name    VARCHAR(50)  NOT NULL,
    last_name     VARCHAR(50)  NOT NULL,
    email         VARCHAR(100),
    city          VARCHAR(50),
    country       VARCHAR(50),
    signup_date   DATE
);

-- -----------------------------------------------------------------------
-- products: each row is one product offered for sale.
-- -----------------------------------------------------------------------
CREATE TABLE products (
    product_id    INTEGER       PRIMARY KEY,
    product_name  VARCHAR(100)  NOT NULL,
    category      VARCHAR(50),
    unit_price    NUMERIC(10,2),
    stock_qty     INTEGER
);

-- -----------------------------------------------------------------------
-- orders: each row is one order placed by one customer.
-- Foreign key to customers enforces referential integrity (Ch 2).
-- -----------------------------------------------------------------------
CREATE TABLE orders (
    order_id      INTEGER      PRIMARY KEY,
    customer_id   INTEGER      REFERENCES customers(customer_id),
    employee_id   INTEGER      REFERENCES employees(employee_id),
    order_date    DATE,
    status        VARCHAR(20)
);

-- -----------------------------------------------------------------------
-- order_items: resolves the many-to-many relationship between orders and
-- products. Each row is one line item on one order (Ch 2).
-- -----------------------------------------------------------------------
CREATE TABLE order_items (
    item_id     INTEGER       PRIMARY KEY,
    order_id    INTEGER       REFERENCES orders(order_id),
    product_id  INTEGER       REFERENCES products(product_id),
    quantity    INTEGER,
    unit_price  NUMERIC(10,2)
);


-- =============================================================================
-- SECTION 0B: SAMPLE DATA POPULATION
-- Insert enough rows to make every interview question return meaningful results.
-- =============================================================================

INSERT INTO regions VALUES
    (1, 'North America'),
    (2, 'Europe'),
    (3, 'Asia Pacific'),
    (4, 'Latin America');

INSERT INTO departments VALUES
    (10, 'Sales',      1),
    (20, 'Marketing',  2),
    (30, 'Engineering',1),
    (40, 'Support',    3),
    (50, 'Finance',    2),
    (60, 'Logistics',  4);

-- Employees inserted in two passes because of the self-referencing manager_id.
-- First pass: managers (manager_id left NULL).
INSERT INTO employees (employee_id, first_name, last_name, department_id, hire_date, salary, manager_id) VALUES
    (1,  'Diana',   'Okafor',    10, '2018-03-15', 95000.00, NULL),
    (2,  'Marcus',  'Holt',      20, '2017-07-01', 88000.00, NULL),
    (3,  'Priya',   'Nair',      30, '2019-01-10', 110000.00, NULL),
    (4,  'James',   'Whitfield', 40, '2016-11-22', 72000.00, NULL),
    (5,  'Sofia',   'Reyes',     50, '2020-06-30', 81000.00, NULL);

-- Second pass: individual contributors who report to managers above.
INSERT INTO employees (employee_id, first_name, last_name, department_id, hire_date, salary, manager_id) VALUES
    (6,  'Liam',    'Chen',      10, '2021-02-14', 62000.00, 1),
    (7,  'Amara',   'Diallo',    10, '2022-08-01', 58000.00, 1),
    (8,  'Tomasz',  'Kowalski',  20, '2020-03-20', 65000.00, 2),
    (9,  'Fatima',  'Al-Hassan', 30, '2021-09-05', 97000.00, 3),
    (10, 'Kenji',   'Yamamoto',  30, '2022-01-17', 91000.00, 3),
    (11, 'Brigitte','Moreau',    40, '2023-04-11', 54000.00, 4),
    (12, 'Ravi',    'Sharma',    50, '2019-12-01', 76000.00, 5),
    (13, 'Elena',   'Popescu',   60, '2020-07-15', 69000.00, NULL),
    (14, 'Omar',    'Farouk',    60, '2023-06-01', 51000.00, 13),
    (15, 'Yuki',    'Tanaka',    40, '2021-11-30', 57000.00, 4);

INSERT INTO customers VALUES
    (101, 'Alice',   'Morgan',   'alice@example.com',   'New York',    'USA',    '2021-01-15'),
    (102, 'Bruno',   'Santos',   'bruno@example.com',   'Sao Paulo',   'Brazil', '2021-03-22'),
    (103, 'Chloe',   'Dupont',   'chloe@example.com',   'Paris',       'France', '2021-06-10'),
    (104, 'David',   'Kim',      'david@example.com',   'Seoul',       'Korea',  '2022-02-28'),
    (105, 'Esme',    'Larsson',  'esme@example.com',    'Stockholm',   'Sweden', '2022-05-17'),
    (106, 'Femi',    'Adeyemi',  'femi@example.com',    'Lagos',       'Nigeria','2022-09-03'),
    (107, 'Grace',   'Liu',      'grace@example.com',   'Shanghai',    'China',  '2023-01-20'),
    (108, 'Hiro',    'Nakamura', 'hiro@example.com',    'Tokyo',       'Japan',  '2023-03-08'),
    (109, 'Ingrid',  'Hansen',   NULL,                  'Oslo',        'Norway', '2023-07-14'),
    (110, 'Jorge',   'Martinez', 'jorge@example.com',   'Mexico City', 'Mexico', '2023-11-01');

INSERT INTO products VALUES
    (201, 'Wireless Keyboard',   'Electronics',  79.99,  150),
    (202, 'USB-C Hub',           'Electronics',  49.99,  200),
    (203, 'Standing Desk',       'Furniture',   349.00,   40),
    (204, 'Ergonomic Chair',     'Furniture',   499.00,   25),
    (205, 'Notebook Set',        'Stationery',   12.99,  500),
    (206,
