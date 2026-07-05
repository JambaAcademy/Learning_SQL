-- =============================================================================
-- Chapter 11: Window Function Scripts
-- The Science of Learning SQL: An Evidence-Based, Step-by-Step Guide to
-- Mastering Databases, Queries, Joins, and Real-World Data Analysis
-- =============================================================================
--
-- PURPOSE:
--   Executable, annotated SQL scripts covering every major window function
--   pattern introduced in Chapter 11. Run these against the practice datasets
--   to reinforce ROW_NUMBER, RANK, DENSE_RANK, LAG, LEAD, running totals,
--   and moving averages — all using OVER and PARTITION BY.
--
-- COMPATIBILITY:
--   PostgreSQL 12+  (syntax notes for SQLite / MySQL 8+ included as comments)
--
-- PRACTICE DATASET TABLES USED:
--   sales        (sale_id, employee_id, department, sale_date, amount)
--   employees    (employee_id, first_name, last_name, department, hire_date, salary)
--   products     (product_id, product_name, category, unit_price, units_sold)
--   orders       (order_id, customer_id, order_date, total_amount, status)
--   daily_revenue(revenue_date, department, daily_total)
-- =============================================================================


-- =============================================================================
-- SECTION 0: CREATE AND POPULATE PRACTICE TABLES
-- Run this block once to set up the data used by every script below.
-- =============================================================================

-- ----------------------------------------------------------------------------
-- 0.1  employees
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
    employee_id  INT          PRIMARY KEY,
    first_name   VARCHAR(50)  NOT NULL,
    last_name    VARCHAR(50)  NOT NULL,
    department   VARCHAR(50)  NOT NULL,
    hire_date    DATE         NOT NULL,
    salary       NUMERIC(10,2) NOT NULL
);

INSERT INTO employees VALUES
  (1,  'Maria',   'Santos',   'Sales',     '2019-03-15', 72000),
  (2,  'James',   'Okafor',   'Sales',     '2020-07-01', 65000),
  (3,  'Priya',   'Nair',     'Sales',     '2018-11-20', 81000),
  (4,  'Luca',    'Ferretti', 'Marketing', '2021-01-10', 68000),
  (5,  'Aisha',   'Diallo',   'Marketing', '2019-06-05', 74000),
  (6,  'Tom',     'Bergmann', 'Marketing', '2020-09-22', 68000),
  (7,  'Yuki',    'Tanaka',   'Engineering','2017-04-30',95000),
  (8,  'Carlos',  'Mendez',   'Engineering','2018-08-14',91000),
  (9,  'Fatima',  'Al-Rashid','Engineering','2020-02-28',88000),
  (10, 'Sophie',  'Laurent',  'Engineering','2021-05-17',85000),
  (11, 'Derek',   'Owusu',    'HR',        '2019-10-03', 61000),
  (12, 'Mei',     'Chen',     'HR',        '2022-01-25', 58000);

-- ----------------------------------------------------------------------------
-- 0.2  sales
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS sales;
CREATE TABLE sales (
    sale_id     INT           PRIMARY KEY,
    employee_id INT           NOT NULL,
    department  VARCHAR(50)   NOT NULL,
    sale_date   DATE          NOT NULL,
    amount      NUMERIC(10,2) NOT NULL
);

INSERT INTO sales VALUES
  (1,  1,  'Sales',     '2024-01-05', 4200),
  (2,  2,  'Sales',     '2024-01-07', 3100),
  (3,  3,  'Sales',     '2024-01-09', 5800),
  (4,  1,  'Sales',     '2024-01-15', 6200),
  (5,  2,  'Sales',     '2024-01-18', 2900),
  (6,  3,  'Sales',     '2024-01-20', 7100),
  (7,  4,  'Marketing', '2024-01-06', 3300),
  (8,  5,  'Marketing', '2024-01-08', 4700),
  (9,  6,  'Marketing', '2024-01-11', 3300),
  (10, 4,  'Marketing', '2024-01-19', 5100),
  (11, 5,  'Marketing', '2024-01-22', 4200),
  (12, 6,  'Marketing', '2024-01-25', 3900),
  (13, 7,  'Engineering','2024-01-04',1800),
  (14, 8,  'Engineering','2024-01-12',2200),
  (15, 9,  'Engineering','2024-01-16',1500),
  (16, 10, 'Engineering','2024-01-23',2600);

-- ----------------------------------------------------------------------------
-- 0.3  products
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS products;
CREATE TABLE products (
    product_id   INT           PRIMARY KEY,
    product_name VARCHAR(100)  NOT NULL,
    category     VARCHAR(50)   NOT NULL,
    unit_price   NUMERIC(8,2)  NOT NULL,
    units_sold   INT           NOT NULL
);

INSERT INTO products VALUES
  (1,  'Laptop Pro 15',    'Electronics',  1299.99, 340),
  (2,  'Wireless Mouse',   'Electronics',    29.99, 890),
  (3,  'USB-C Hub',        'Electronics',    49.99, 620),
  (4,  'Desk Chair',       'Furniture',     349.99, 210),
  (5,  'Standing Desk',    'Furniture',     599.99, 175),
  (6,  'Monitor Arm',      'Furniture',      89.99, 430),
  (7,  'Notebook Set',     'Stationery',      9.99,1200),
  (8,  'Gel Pens (10pk)',  'Stationery',      7.49,1850),
  (9,  'Whiteboard',       'Stationery',     59.99, 310),
  (10, 'Webcam HD',        'Electronics',    79.99, 540),
  (11, 'Bookcase',         'Furniture',     249.99, 130),
  (12, 'Sticky Notes',     'Stationery',      4.99,2100);

-- ----------------------------------------------------------------------------
-- 0.4  orders
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    order_id      INT           PRIMARY KEY,
    customer_id   INT           NOT NULL,
    order_date    DATE          NOT NULL,
    total_amount  NUMERIC(10,2) NOT NULL,
    status        VARCHAR(20)   NOT NULL
);

INSERT INTO orders VALUES
  (1001, 201, '2024-01-03',  450.00, 'Completed'),
  (1002, 202, '2024-01-05',  220.50, 'Completed'),
  (1003, 201, '2024-01-10',  875.00, 'Completed'),
  (1004, 203, '2024-01-12',  130.75, 'Cancelled'),
  (1005, 204, '2024-01-15', 1200.00, 'Completed'),
  (1006, 202, '2024-01-18',  340.00, 'Completed'),
  (1007, 205, '2024-01-20',  560.25, 'Pending'),
  (1008, 201, '2024-01-22',  990.00, 'Completed'),
  (1009, 203, '2024-01-25',  480.50, 'Completed'),
  (1010, 204, '2024-01-28',  750.00, 'Completed'),
  (1011, 206, '2024-02-01',  320.00, 'Completed'),
  (1012, 201, '2024-02-04', 1100.00, 'Completed'),
  (1013, 205, '2024-02-07',  640.75, 'Completed'),
  (1014, 202, '2024-02-10',  290.00, 'Cancelled'),
  (1015, 206, '2024-02-14',  810.00, 'Completed');

-- ----------------------------------------------------------------------------
-- 0.5  daily_revenue
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS daily_revenue;
CREATE TABLE daily_revenue (
    revenue_date DATE          NOT NULL,
    department   VARCHAR(50)   NOT NULL,
    daily_total  NUMERIC(10,2) NOT NULL,
    PRIMARY KEY (revenue_date, department)
);

INSERT INTO daily_revenue VALUES
  ('2024-01-01','Sales',      5200),
  ('2024-01-01','Marketing',  3100),
  ('2024-01-02','Sales',      4800),
  ('2024-01-02','Marketing',  2900),
  ('2024-01-03','Sales',      6100),
  ('2024-01-03','Marketing',  4200),
  ('2024-01-04','Sales',      5500),
  ('2024-01-04','Marketing',  3800),
  ('2024-01-05','Sales',      7200),
  ('2024-01-05','Marketing',  4600),
  ('2024-01-06','Sales',      6800),
  ('2024-01-06','Marketing',  5100),
  ('2024
