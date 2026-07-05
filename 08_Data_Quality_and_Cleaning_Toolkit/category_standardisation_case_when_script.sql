-- =============================================================================
-- Category Standardisation CASE WHEN Script
-- The Science of Learning SQL: An Evidence-Based, Step-by-Step Guide to
-- Mastering Databases, Queries, Joins, and Real-World Data Analysis
-- =============================================================================
-- PURPOSE:
--   Real-world data is messy. Categories arrive in inconsistent formats:
--   mixed case, abbreviations, legacy codes, free-text typos, and NULLs.
--   This script demonstrates how to use CASE WHEN expressions to detect,
--   reclassify, and standardise category values without altering the
--   original table -- a critical data quality skill for any SQL analyst.
--
-- RELATED CHAPTERS:
--   Chapter 3  -- SELECT, column aliases, DISTINCT
--   Chapter 4  -- WHERE, NULL handling, IS NULL
--   Chapter 5  -- ORDER BY, LIMIT
--   Chapter 6  -- GROUP BY, COUNT, aggregate functions
--   Chapter 7  -- JOINs (used in the multi-table standardisation example)
--   Chapter 8  -- Subqueries (used to filter against derived category lists)
-- =============================================================================


-- =============================================================================
-- SECTION 1: SAMPLE DATA SETUP
-- =============================================================================

-- Create a representative orders table that mirrors the kind of raw,
-- inconsistent data you encounter in real analyst work.
-- Each row is one complete record (Chapter 2: rows represent individual units).
-- Primary keys give every row a reliable, permanent address (Chapter 2).

CREATE TABLE raw_orders (
    order_id       INTEGER PRIMARY KEY,
    customer_name  VARCHAR(100),
    product_name   VARCHAR(100),
    category_raw   VARCHAR(50),   -- dirty, unstandardised category input
    region_raw     VARCHAR(50),   -- inconsistent region labels
    order_amount   DECIMAL(10,2),
    order_date     DATE
);

-- Insert sample rows that deliberately contain the kinds of inconsistencies
-- you will find in exported spreadsheets, legacy systems, and manual entry.
-- Notice: mixed case, abbreviations, NULL values, and legacy codes all coexist.

INSERT INTO raw_orders VALUES
(1,  'Alice Marsh',    'Wireless Mouse',      'electronics',   'North',     49.99,  '2024-01-15'),
(2,  'Ben Carter',     'Office Chair',        'FURNITURE',     'south',     299.00, '2024-01-18'),
(3,  'Clara Singh',    'USB Hub',             'Electronics',   'NORTH',     29.95,  '2024-01-20'),
(4,  'David Osei',     'Standing Desk',       'furn',          'East',      549.00, '2024-02-01'),
(5,  'Eva Novak',      'Laptop Stand',        'Elect',         'West',      79.00,  '2024-02-03'),
(6,  'Frank Liu',      'Bookshelf',           'furniture',     'EAST',      189.50, '2024-02-10'),
(7,  'Grace Kim',      'Monitor',             'ELECTRONICS',   'north',     399.00, '2024-02-14'),
(8,  'Hugo Reyes',     'Desk Lamp',           'Lighting',      'South',     39.99,  '2024-02-20'),
(9,  'Isla Brown',     'Ergonomic Keyboard',  'elec',          'West',      119.00, '2024-03-01'),
(10, 'James Patel',    'Filing Cabinet',      'Furn.',         'SOUTH',     229.00, '2024-03-05'),
(11, 'Karen White',    'LED Strip',           'lighting',      NULL,        24.99,  '2024-03-08'),
(12, 'Liam Torres',    'Webcam',              NULL,            'East',      89.00,  '2024-03-12'),
(13, 'Mia Johnson',    'Sofa',                'FURN',          'north',     899.00, '2024-03-15'),
(14, 'Noah Ahmed',     'Smart Bulb',          'Lighting',      'West',      19.99,  '2024-03-18'),
(15, 'Olivia Scott',   'Graphics Tablet',     'electronics',   'South',     249.00, '2024-03-22'),
(16, 'Paul Evans',     'Conference Table',    'furniture',     'NORTH',     749.00, '2024-03-25'),
(17, 'Quinn Adams',    'Ring Light',          'LIGHTING',      'East',      59.99,  '2024-03-28'),
(18, 'Rosa Chen',      'External SSD',        'Elect.',        'west',      149.00, '2024-04-01'),
(19, 'Sam Walker',     'Drawer Unit',         'furn',          'South',     179.00, '2024-04-04'),
(20, 'Tara Nguyen',    'Noise Cancelling Headphones', 'elec', 'EAST',      199.00, '2024-04-07');


-- =============================================================================
-- SECTION 2: INSPECT THE DIRTY DATA BEFORE CLEANING
-- =============================================================================

-- Before writing any cleaning logic, retrieve all distinct raw category values.
-- DISTINCT (Chapter 3) surfaces every unique variant so you know exactly
-- what you are dealing with. This is the diagnostic step every analyst must run.

SELECT DISTINCT category_raw
FROM   raw_orders
ORDER BY category_raw;


-- Count how many rows fall into each raw category variant.
-- GROUP BY + COUNT (Chapter 6) reveals which dirty values appear most often,
-- helping you prioritise your standardisation rules.

SELECT
    category_raw,
    COUNT(*) AS row_count
FROM   raw_orders
GROUP BY category_raw
ORDER BY row_count DESC;


-- Identify rows where category_raw is NULL (Chapter 4: IS NULL handling).
-- Standard = operator cannot detect absent data -- IS NULL is required.

SELECT
    order_id,
    customer_name,
    product_name,
    category_raw
FROM   raw_orders
WHERE  category_raw IS NULL;


-- =============================================================================
-- SECTION 3: CORE CASE WHEN STANDARDISATION
-- =============================================================================

-- CASE WHEN evaluates each row's category_raw value against a set of
-- conditions and returns a clean, standardised label.
-- The alias (Chapter 3) renames the computed column so the output is
-- immediately readable without changing any underlying table data.
--
-- Pattern: map every known dirty variant to its canonical clean label.
-- ELSE captures anything that does not match any known pattern,
-- flagging it for further investigation rather than silently dropping it.

SELECT
    order_id,
    customer_name,
    product_name,
    category_raw,

    -- Standardise category: collapse all known variants into three canonical labels.
    CASE
        WHEN LOWER(category_raw) IN ('electronics', 'elect', 'elec', 'elect.')
            THEN 'Electronics'
        WHEN LOWER(category_raw) IN ('furniture', 'furn', 'furn.')
            THEN 'Furniture'
        WHEN LOWER(category_raw) IN ('lighting')
            THEN 'Lighting'
        WHEN category_raw IS NULL
            THEN 'Uncategorised'
        ELSE 'Review Required'
    END AS category_clean,

    order_amount,
    order_date
FROM   raw_orders
ORDER BY category_clean, order_id;


-- =============================================================================
-- SECTION 4: REGION STANDARDISATION ALONGSIDE CATEGORY STANDARDISATION
-- =============================================================================

-- Real cleaning jobs rarely involve just one column.
-- Here we standardise both category_raw and region_raw in the same SELECT,
-- demonstrating that multiple CASE WHEN expressions can run in parallel.
-- LOWER() normalises case before comparison, eliminating case-sensitivity traps
-- that Chapter 4 warns are a frequent source of silent filtering errors.

SELECT
    order_id,
    customer_name,
    product_name,

    -- Standardise category using LOWER() to neutralise case differences.
    CASE
        WHEN LOWER(category_raw) IN ('electronics', 'elect', 'elec', 'elect.')
            THEN 'Electronics'
        WHEN LOWER(category_raw) IN ('furniture', 'furn', 'furn.')
            THEN 'Furniture'
        WHEN LOWER(category_raw) = 'lighting'
            THEN 'Lighting'
        WHEN category_raw IS NULL
            THEN 'Uncategorised'
        ELSE 'Review Required'
    END AS category_clean,

    -- Standardise region: map all case variants to a consistent Title Case label.
    CASE
        WHEN LOWER(region_raw) = 'north'  THEN 'North'
        WHEN LOWER(region_raw) = 'south'  THEN 'South'
        WHEN LOWER(region_raw) = 'east'   THEN 'East'
        WHEN LOWER(region_raw) = 'west'   THEN 'West'
        WHEN region_raw IS NULL           THEN 'Region Unknown'
        ELSE 'Review Required'
    END AS region_clean,

    order_amount,
    order_date
FROM   raw_orders
ORDER BY category_clean, region_clean, order_id;


-- =============================================================================
-- SECTION 5: AGGREGATE ANALYSIS ON STANDARDISED CATEGORIES
-- =============================================================================

-- Once categories are standardised inside a subquery (Chapter 8),
-- the outer query can safely GROUP BY the clean labels.
-- Aggregating on dirty raw values would produce misleading, fragmented results
-- because 'electronics', 'Elect', and 'ELECTRONICS' would count as three groups.
--
-- The subquery executes first, delivering clean labels to the outer query
-- exactly as if you had typed them directly -- this is the core Chapter 8 pattern.

SELECT
    category_clean,
    COUNT(*)                        AS total_orders,
    SUM(order_amount)               AS
