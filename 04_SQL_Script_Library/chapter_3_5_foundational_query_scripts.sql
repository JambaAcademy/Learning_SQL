-- =============================================================================
-- Chapter 3–5 Foundational Query Scripts
-- The Science of Learning SQL: An Evidence-Based, Step-by-Step Guide to
-- Mastering Databases, Queries, Joins, and Real-World Data Analysis
-- for Complete Beginners
--
-- PURPOSE:
--   Annotated, executable SQL scripts covering every major concept introduced
--   in Chapters 3, 4, and 5.  Run these against the book's practice datasets
--   (employees, products, orders, customers) to see the expected outputs
--   described in the inline comments.
--
-- DATABASE:  SQLite 3.x (syntax is ANSI-compatible; minor adjustments noted
--            where PostgreSQL / MySQL behaviour differs)
-- HOW TO USE:
--   1. Open your SQLite client or DB Browser for SQLite.
--   2. Paste or source this entire file.
--   3. The CREATE TABLE / INSERT blocks build the practice data automatically.
--   4. Run each numbered query block individually and compare your output
--      with the "EXPECTED OUTPUT" comment that follows it.
-- =============================================================================


-- =============================================================================
-- SECTION 0 — BUILD THE PRACTICE DATASET
-- =============================================================================
-- These tables mirror the datasets used throughout Chapters 3–5.
-- If your instructor has already loaded them, skip to SECTION 1.

-- Drop tables if they already exist so this file is re-runnable.
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS employees;

-- ── employees ────────────────────────────────────────────────────────────────
-- Represents a company's workforce; used heavily in Chapter 3 examples.
CREATE TABLE employees (
    employee_id   INTEGER PRIMARY KEY,
    first_name    TEXT    NOT NULL,
    last_name     TEXT    NOT NULL,
    department    TEXT,
    job_title     TEXT,
    salary        REAL,
    hire_date     TEXT,          -- stored as ISO-8601 'YYYY-MM-DD'
    manager_id    INTEGER,       -- NULL for top-level managers
    email         TEXT
);

INSERT INTO employees VALUES
 (1,  'Alice',   'Nguyen',    'Engineering',  'Senior Engineer',   95000, '2019-03-15', NULL,  'alice.nguyen@company.com'),
 (2,  'Bob',     'Patel',     'Engineering',  'Junior Engineer',   62000, '2022-07-01', 1,     'bob.patel@company.com'),
 (3,  'Carol',   'Smith',     'Marketing',    'Marketing Manager', 78000, '2018-11-20', NULL,  'carol.smith@company.com'),
 (4,  'David',   'Kim',       'Marketing',    'Analyst',           54000, '2021-04-10', 3,     'david.kim@company.com'),
 (5,  'Eva',     'Johansson', 'Engineering',  'Senior Engineer',   97000, '2017-09-05', NULL,  'eva.johansson@company.com'),
 (6,  'Frank',   'Okafor',    'Sales',        'Sales Rep',         48000, '2023-01-18', NULL,  'frank.okafor@company.com'),
 (7,  'Grace',   'Liu',       'Sales',        'Sales Rep',         49500, '2022-10-03', NULL,  'grace.liu@company.com'),
 (8,  'Henry',   'Torres',    'HR',           'HR Specialist',     61000, '2020-06-22', NULL,  'henry.torres@company.com'),
 (9,  'Irene',   'Dubois',    'Engineering',  'Junior Engineer',   63000, '2023-03-11', 1,     NULL),   -- email unknown
 (10, 'James',   'Brown',     'HR',           'HR Manager',        75000, '2016-02-28', NULL,  'james.brown@company.com'),
 (11, 'Karen',   'Müller',    'Sales',        'Sales Manager',     82000, '2015-08-14', NULL,  'karen.muller@company.com'),
 (12, 'Leo',     'Chen',      'Marketing',    'Analyst',           54000, '2021-04-10', 3,     'leo.chen@company.com');

-- ── products ─────────────────────────────────────────────────────────────────
-- An electronics retailer's product catalogue; used in Chapter 4 filtering.
CREATE TABLE products (
    product_id    INTEGER PRIMARY KEY,
    product_name  TEXT    NOT NULL,
    category      TEXT,
    unit_price    REAL,
    stock_qty     INTEGER,
    supplier      TEXT,
    discontinued  INTEGER DEFAULT 0   -- 0 = active, 1 = discontinued
);

INSERT INTO products VALUES
 (101, 'Wireless Mouse',        'Peripherals',  29.99,  340, 'TechSource',    0),
 (102, 'Mechanical Keyboard',   'Peripherals',  89.99,   85, 'TechSource',    0),
 (103, 'USB-C Hub',             'Peripherals',  49.99,  210, 'GlobalGadgets', 0),
 (104, '27-inch Monitor',       'Displays',    349.99,   42, 'ViewPro',       0),
 (105, '4K Webcam',             'Peripherals',  79.99,    0, 'TechSource',    0),  -- out of stock
 (106, 'Laptop Stand',          'Accessories',  34.99,  175, 'ErgoWorld',     0),
 (107, 'Noise-Cancelling Headphones', 'Audio', 199.99,   60, 'SoundCo',       0),
 (108, 'Portable SSD 1TB',      'Storage',     109.99,   95, 'DataVault',     0),
 (109, 'Ethernet Adapter',      'Peripherals',  19.99,  500, 'GlobalGadgets', 0),
 (110, 'Smart LED Desk Lamp',   'Accessories',  44.99,  130, 'LumiTech',      0),
 (111, 'Trackball Mouse',       'Peripherals',  64.99,   22, 'ErgoWorld',     1),  -- discontinued
 (112, 'VGA Adapter',           'Peripherals',   9.99,   18, 'GlobalGadgets', 1),  -- discontinued
 (113, '32-inch Curved Monitor','Displays',    499.99,   15, 'ViewPro',       0),
 (114, 'Portable Charger 20000mAh','Accessories',39.99, 200, 'PowerUp',       0),
 (115, 'Blue Light Glasses',    'Accessories',  24.99,   88, 'ClearVision',   0);

-- ── customers ────────────────────────────────────────────────────────────────
-- Used in Chapter 4 NULL-handling and LIKE pattern-matching examples.
CREATE TABLE customers (
    customer_id   INTEGER PRIMARY KEY,
    first_name    TEXT    NOT NULL,
    last_name     TEXT    NOT NULL,
    city          TEXT,
    country       TEXT,
    email         TEXT,
    signup_date   TEXT,
    loyalty_tier  TEXT    -- 'Bronze', 'Silver', 'Gold', or NULL (not enrolled)
);

INSERT INTO customers VALUES
 (1001, 'Maria',    'Garcia',     'Madrid',        'Spain',          'maria.garcia@email.com',    '2020-01-15', 'Gold'),
 (1002, 'James',    'Wilson',     'New York',       'USA',            'james.wilson@email.com',    '2019-06-22', 'Silver'),
 (1003, 'Yuki',     'Tanaka',     'Tokyo',          'Japan',          'yuki.tanaka@email.com',     '2021-03-08', 'Bronze'),
 (1004, 'Ahmed',    'Hassan',     'Cairo',          'Egypt',          'ahmed.hassan@email.com',    '2018-11-30', 'Gold'),
 (1005, 'Sophie',   'Leclerc',    'Paris',          'France',         'sophie.leclerc@email.com',  '2022-07-14', NULL),
 (1006, 'Carlos',   'Mendoza',    'Buenos Aires',   'Argentina',      'carlos.mendoza@email.com',  '2020-09-01', 'Silver'),
 (1007, 'Priya',    'Sharma',     'Mumbai',         'India',          NULL,                        '2023-02-19', 'Bronze'),
 (1008, 'Oliver',   'Müller',     'Berlin',         'Germany',        'oliver.mueller@email.com',  '2017-04-05', 'Gold'),
 (1009, 'Fatima',   'Al-Rashid',  'Dubai',          'UAE',            'fatima.alrashid@email.com', '2021-12-11', NULL),
 (1010, 'Lucas',    'Ferreira',   'São Paulo',      'Brazil',         'lucas.ferreira@email.com',  '2019-08-27', 'Silver'),
 (1011, 'Emma',     'Johnson',    'Chicago',        'USA',            'emma.johnson@email.com',    '2022-03-30', 'Bronze'),
 (1012, 'Nguyen',   'Thi Lan',    'Hanoi',          'Vietnam',        'nguyen.thilan@email.com',   '2020-05-17', NULL);

-- ── orders ───────────────────────────────────────────────────────────────────
-- Used in Chapter
