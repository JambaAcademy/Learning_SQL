# Glossary

# Glossary of Essential SQL Terms

*Your reference companion for every chapter in this guide. Return here whenever a term feels unfamiliar — definitions are written for first-time readers, not database engineers.*

---

**Aggregate Function** — A function that performs a calculation across multiple rows and returns a single summary value. Common aggregate functions include `COUNT()`, `SUM()`, `AVG()`, `MIN()`, and `MAX()`. For example, `SUM(order_total)` adds every value in the `order_total` column to produce total revenue. Aggregate functions are almost always paired with `GROUP BY` to produce summaries broken down by category, such as total sales per region or average order value per customer segment.

---

**alias** — A temporary, alternative name assigned to a table or column within a query, using the `AS` keyword. Aliases improve readability and shorten repetitive references. For example, `SELECT first_name AS name FROM employees` displays the column header as *name* rather than *first_name*. Table aliases are especially useful in JOIN clauses: `FROM customers AS c` lets you write `c.customer_id` instead of repeating the full table name throughout a complex query.

---

**AND / OR** — Logical operators used inside a `WHERE` clause to combine multiple filter conditions. `AND` requires both conditions to be true simultaneously; `OR` requires at least one to be true. For example, `WHERE region = 'North' AND revenue > 10000` returns only northern rows with high revenue. Combining `AND` and `OR` in the same query requires parentheses to control evaluation order and avoid unexpected results.

---

**AVG()** — An aggregate function that calculates the arithmetic mean of a numeric column, ignoring `NULL` values automatically. For example, `SELECT AVG(salary) FROM employees` returns the average salary across all employees. `AVG()` is commonly used alongside `GROUP BY` to compare mean values across categories — such as average purchase value by customer age group — making it one of the most frequently used functions in business intelligence reporting.

---

**Boolean Expression** — Any expression that evaluates to either TRUE or FALSE, forming the logical foundation of `WHERE` clause filtering. Comparisons such as `price > 100`, `status = 'active'`, and `region IS NOT NULL` are all boolean expressions. SQL evaluates each row against the boolean expression and returns only rows where the result is TRUE. Understanding boolean logic is essential for writing precise filters that return exactly the data a business question requires.

---

**Cardinality** — The number of unique values in a column relative to the total number of rows, and also the nature of relationships between tables (one-to-one, one-to-many, many-to-many). High cardinality means many distinct values (such as email addresses); low cardinality means few (such as a status column containing only 'active' or 'inactive'). Understanding cardinality helps you choose appropriate JOIN strategies, design efficient data models, and anticipate how query results will behave when tables are combined.

---

**Clause** — A distinct, named component of a SQL statement that performs a specific role. Common clauses include `SELECT` (which columns to retrieve), `FROM` (which table to query), `WHERE` (which rows to include), `GROUP BY` (how to aggregate), `HAVING` (how to filter aggregated results), and `ORDER BY` (how to sort output). A complete SQL query is assembled by combining clauses in the correct sequence. Each clause is optional except `SELECT`, which every query must contain.

---

**Column** — A single named attribute within a database table, representing one type of data stored for every row. In a `customers` table, columns might include `customer_id`, `first_name`, `email`, and `signup_date`. Columns enforce a specific data type — such as integer, text, or date — ensuring consistency across all stored values. In a SELECT statement, you specify which columns to retrieve: `SELECT first_name, email FROM customers` returns only those two columns rather than the entire table.

---

**Common Table Expression (CTE)** — A named, temporary result set defined at the top of a query using the `WITH` keyword, which can then be referenced by name in the main query that follows. CTEs improve readability by breaking complex queries into logical, labelled steps rather than nesting subqueries inside one another. For example, you might define a CTE called `high_value_orders` that filters orders above £500, then join that CTE to a customers table in the main query. CTEs exist only for the duration of the query execution.

---

**Constraint** — A rule applied to a column or table that restricts which values are permitted, enforcing data integrity at the database level. Common constraints include `NOT NULL` (the column must always contain a value), `UNIQUE` (no two rows may share the same value), `PRIMARY KEY` (unique, non-null identifier for each row), and `FOREIGN KEY` (values must match an existing value in a referenced table). Constraints prevent invalid data from entering the database, reducing the need for defensive filtering in every query.

---

**COUNT()** — An aggregate function that counts the number of rows meeting a specified condition. `COUNT(*)` counts all rows including those with NULL values; `COUNT(column_name)` counts only rows where that column is not NULL. For example, `SELECT COUNT(*) FROM orders WHERE status = 'completed'` returns the total number of completed orders. `COUNT()` is typically the first aggregate function beginners learn because it answers one of the most common business questions: "How many?"

---

**Data Type** — The classification assigned to a column that determines what kind of values it can store and how the database engine processes them. Common data types include `INT` or `INTEGER` (whole numbers), `VARCHAR` or `TEXT` (variable-length strings), `DECIMAL` or `FLOAT` (numbers with decimal places), `DATE` (calendar dates), and `BOOLEAN` (true/false values). Choosing appropriate data types when designing tables prevents invalid entries, saves storage space, and ensures that calculations and comparisons behave as expected.

---

**Database** — An organised collection of structured data stored electronically and managed by a database management system (DBMS). In the relational model, a database contains multiple related tables that together represent a coherent domain — for example, a retail database might contain `customers`, `orders`, `products`, and `inventory` tables. SQL is the language used to create, query, update, and manage relational databases. The database enforces structure, relationships, and rules that raw files like spreadsheets cannot.

---

**Database Management System (DBMS)** — The software platform that stores, organises, and provides access to a database. Popular relational DBMSs include PostgreSQL, MySQL, Microsoft SQL Server, SQLite, and Oracle. Each system uses SQL as its primary query language but may support slightly different syntax extensions. As a beginner, you will write SQL queries and submit them to a DBMS, which interprets your instructions, retrieves the requested data, and returns a result set. Choosing a DBMS is typically a business or infrastructure decision, not a query-writing one.

---

**Distinct** — A keyword used with `SELECT` to eliminate duplicate rows from a result set, returning only unique values. `SELECT DISTINCT country FROM customers` returns each country name once, regardless of how many customers share it. `DISTINCT` is useful for exploring the range of values in a column before writing more complex filters. When used with multiple columns, `DISTINCT` treats the combination of all selected columns as the uniqueness unit, not each column individually.

---

**Entity** — A real-world object, concept, or event that a database table represents. In a retail database, entities include customers, products, orders, and employees. Each entity becomes a table, each attribute of that entity becomes a column, and each individual instance of the entity becomes a row. Thinking in terms of entities before writing SQL helps you understand the data model — knowing what each table represents makes it far easier to identify which tables to join and which columns to filter.

---

**ERD (Entity-Relationship Diagram)** — A visual diagram that maps the tables in a database, the columns within each table, and the relationships (joins) between tables. ERDs show primary keys, foreign keys, and cardinality at a glance, making them an essential navigation tool before writing any query against an unfamiliar database. Reading an ERD before querying a new database is the equivalent of studying a map before navigating a city — it prevents wasted effort and incorrect assumptions about how data is connected.

---

**FOREIGN KEY** — A column in one table whose values reference the primary key of another table, creating a link between the two. For example, an `orders` table might contain a `customer_id` column that references the `customer_id` primary key in the `customers` table. This relationship is what makes JOIN operations possible and meaningful. Foreign keys enforce referential integrity, ensuring that an order cannot reference a customer who does not exist. Understanding foreign keys is the foundation of writing correct JOIN clauses.

---

**FROM** — The clause in a SQL statement that specifies which table (or tables) to retrieve data from. Every query that reads data must include a `FROM` clause immediately after the `SELECT` clause. For example, `SELECT * FROM products` instructs the database to retrieve all columns from the `products` table. When joining multiple tables, the `FROM` clause names the starting table, and `JOIN` clauses extend it with additional tables. The `FROM` clause is the anchor of every data retrieval query.

---

**GROUP BY** — A clause that divides query results into groups based on the unique values in one or more columns, allowing aggregate functions to produce a summary value for each group rather than a single value for the entire table. For example, `SELECT region, SUM(revenue) FROM sales GROUP BY region` returns total revenue for each distinct region. Every column in the `SELECT` list that is not an aggregate function must appear in the `GROUP BY` clause, otherwise the query will return an error.

---

**HAVING** — A clause that filters the results of a `GROUP BY` operation, applied after aggregation has occurred. It is the aggregate equivalent of `WHERE`: while `WHERE` filters individual rows before grouping, `HAVING` filters groups after aggregation. For example, `HAVING SUM(revenue) > 50000` retains only those groups whose total revenue exceeds £50,000. A common beginner mistake is using `WHERE` to filter on an aggregate value — `HAVING` is the correct clause for that purpose.

---

**Index** — A database structure that improves the speed of data retrieval by creating a sorted reference to the values in one or more columns, similar to a book's index pointing to page numbers. Without an index, the database must scan every row in a table to find matches — a full table scan. With an index on a frequently queried column, the database can locate matching rows almost instantly. Indexes are created by database administrators but understanding them helps you write queries that perform efficiently at scale.

---

**INNER JOIN** — A JOIN clause that returns only the rows where a matching value exists in both tables being joined. Rows that have no match in the other table are excluded from the result. For example, joining `orders` and `customers` on `customer_id` with an INNER JOIN returns only orders that have a corresponding customer record. INNER JOIN is the most commonly used join type and the correct default when you want to combine related data that is guaranteed to exist in both tables.

---

**IS NULL / IS NOT NULL** — Operators used in a `WHERE` clause to filter rows based on whether a column contains a NULL value. Because NULL represents the absence of a value rather than zero or an empty string, standard comparison operators like `= NULL` do not work — `IS NULL` is required. For example, `WHERE email IS NULL` returns customers with no email address on record. `IS NOT NULL` returns the opposite. Handling NULLs correctly is essential for accurate analysis, as ignoring them can silently distort aggregate results.

---

**JOIN** — A SQL clause that combines rows from two or more tables based on a related column, typically a foreign key and primary key pair. JOINs are the mechanism that makes relational databases powerful: instead of storing all information in one flat table, data is distributed across normalised tables and reassembled at query time using JOINs. The four most common types are INNER JOIN, LEFT JOIN, RIGHT JOIN, and FULL OUTER JOIN, each differing in how they handle rows with no match in the other table.

---

**LEFT JOIN** — A JOIN clause that returns all rows from the left (first-named) table and the matching rows from the right table. Where no match exists in the right table, NULL values fill the right-side columns. For example, a LEFT JOIN between `customers` and `orders` returns every customer, including those who have never placed an order — those customers will show NULL in the order columns. LEFT JOIN is the correct choice when you need to preserve all records from the primary table regardless of whether related records exist.

---

**LIKE** — An operator used in a `WHERE` clause to filter text columns based on partial pattern matching, using wildcard characters. The `%` wildcard matches any sequence of characters; the `_` wildcard matches exactly one character. For example, `WHERE email LIKE '%@gmail.com'` returns all rows where the email address ends with `@gmail.com`. `LIKE` is case-insensitive in some databases and case-sensitive in others. It is the standard tool for searching text columns when you know only part of the value.

---

**MAX() / MIN()** — Aggregate functions that return the highest and lowest values in a column, respectively. They work with numeric, date, and text columns. For example, `SELECT MAX(order_date) FROM orders` returns the most recent order date, while `MIN(price)` returns the cheapest product price. Like all aggregate functions, `MAX()` and `MIN()` ignore NULL values. When used with `GROUP BY`, they reveal the highest and lowest values within each group — such as the most expensive product in each product category.

---

**Normalisation** — The process of organising a relational database to reduce data redundancy and improve data integrity by dividing information across multiple related tables rather than storing everything in one large flat table. A normalised database stores each piece of information in exactly one place: customer details in a `customers` table, product details in a `products` table, and order details in an `orders` table. Normalisation is why JOIN clauses are necessary — and why learning JOINs is essential for working with any real-world database.

---

**NULL** — A special marker in SQL representing the absence of a value — not zero, not an empty string, but genuinely unknown or missing data. A customer row with NULL in the `phone_number` column means no phone number was recorded. NULL propagates through calculations: any arithmetic involving NULL returns NULL. This behaviour makes NULL handling one of the most common sources of subtle analytical errors. Functions like `COALESCE()` and `ISNULL()` are used to replace NULLs with default values when cleaner output is needed.

---

**ORDER BY** — A clause that sorts the rows in a query result set by one or more specified columns, in either ascending (`ASC`) or descending (`DESC`) order. `ASC` is the default if no direction is specified. For example, `ORDER BY revenue DESC` returns the highest-revenue rows first. You can sort by multiple columns: `ORDER BY region ASC, revenue DESC` sorts alphabetically by region and then by revenue within each region. `ORDER BY` is applied after all filtering and aggregation, making it the final shaping step of a query.

---

**PRIMARY KEY** — A column or combination of columns that uniquely identifies each row in a table, ensuring no two rows are identical and no row lacks an identifier. Primary keys enforce uniqueness and cannot contain NULL values. A `customers` table typically uses `customer_id` as its primary key. Primary keys are the anchor points that foreign keys in other tables reference, forming the backbone of relational database design. Every well-designed table has a primary key; without one, rows cannot be reliably distinguished or referenced.

---

**Query** — A SQL instruction submitted to a database that retrieves, modifies, or manages data. In everyday usage for analysts and beginners, "query" almost always refers to a `SELECT` statement — a read-only instruction that retrieves data without altering it. A query specifies what data to return, from which tables, under what conditions, and in what order. Writing clear, efficient queries is the core skill this book develops. Every query returns a result set: a temporary, tabular view of the requested data.

---

**Relational Database** — A database that organises data into structured tables (rows and columns) and defines explicit relationships between those tables using primary and foreign keys. The relational model, introduced by Edgar Codd in 1970, remains the dominant approach to storing business data. Its power lies in normalisation: each fact is stored once, and relationships are expressed through keys rather than duplication. SQL is the standard language for querying relational databases, making it the foundational skill for anyone working with structured business data.

---

**Result Set** — The tabular output returned by a SQL query, displayed as rows and columns. A result set is temporary — it exists only for the duration of the session or is stored explicitly if needed. The structure of the result set is determined by the `SELECT` clause (which columns appear), the `FROM` and `JOIN` clauses (which tables contribute rows), and the `WHERE`, `GROUP BY`, and `ORDER BY` clauses (which rows appear and in what order). Understanding result sets helps you predict and verify query output before using it in analysis.

---

**Row** — A single record in a database table, representing one complete instance of the entity the table describes. In a `customers` table, each row represents one customer, with values across all columns describing that customer's attributes: name, email, signup date, and so on. SQL queries filter, sort, and aggregate rows to produce meaningful outputs. The number of rows in a result set is controlled by `WHERE` conditions and JOIN behaviour. Rows are also called *records* or *tuples* in formal database literature.

---

**Schema** — The formal definition of a database's structure: the tables it contains, the columns within each table, the data types of those columns, and the relationships and constraints between tables. A schema is the blueprint of the database. Understanding a database's schema before writing queries is essential — it tells you where data lives, how tables connect, and what values are valid. Most database tools provide a schema browser or diagram to help analysts navigate unfamiliar databases without guessing at table and column names.

---

**SELECT** — The foundational SQL clause used to specify which columns to retrieve from a database table. Every data retrieval query begins with `SELECT`. `SELECT *` returns all columns; `SELECT first_name, email` returns only those two. The `SELECT` clause defines the shape of the result set — what information appears in the output. While `SELECT` is syntactically the first clause written, it is logically executed near last, after `FROM`, `WHERE`, `GROUP BY`, and `HAVING` have determined which rows are included.

---

**Subquery** — A complete SQL query nested inside another query, used to pass the result of one query as input to another. Subqueries can appear in the `SELECT`, `FROM`, or `WHERE` clause. For example, `WHERE customer_id IN (SELECT customer_id FROM orders WHERE total > 500)` filters customers who have placed high-value orders, without requiring a JOIN. Subqueries are powerful but can reduce readability in complex scenarios — Common Table Expressions (CTEs) are often preferred as a cleaner alternative for multi-step logic.

---

**SUM()** — An aggregate function that adds all numeric values in a specified column, ignoring NULLs. For example, `SELECT SUM(order_total) FROM orders` returns total revenue across all orders. Combined with `GROUP BY`, `SUM()` becomes a core business intelligence tool: `SELECT product_category, SUM(revenue) FROM sales GROUP BY product_category` produces a revenue breakdown by category. `SUM()` only works on numeric columns — applying it to a text column produces an error. It is one of the five essential aggregate functions every analyst uses daily.

---

**Table** — The primary storage structure in a relational database, organising data into rows (individual records) and columns (named attributes). A database typically contains multiple tables, each representing a distinct entity — customers, products, transactions. Tables are related to one another through primary and foreign keys. When you write a SQL query, you always query against one or more tables. Understanding what each table in a database represents is the first step in translating a business question into a correct and efficient SQL query.

---

**UNION / UNION ALL** — Set operators that combine the result sets of two or more SELECT statements into a single output. Both queries must return the same number of columns with compatible data types. `UNION` removes duplicate rows from the combined output; `UNION ALL` retains all rows including duplicates, and runs faster as a result. For example, combining a list of active customers from two regional databases into one unified list. `UNION` is useful when data is split across tables with identical structures that need to be analysed together.

---

**WHERE** — The clause that filters rows in a query, returning only those rows where the specified condition evaluates to TRUE. `WHERE` is applied before any aggregation occurs, making it the primary tool for narrowing down data before summarising it. For example, `WHERE signup_date >= '2023-01-01'` returns only customers who signed up from January 2023 onwards. Multiple conditions can be combined using `AND` and `OR`. `WHERE` cannot reference aggregate function results — use `HAVING` for post-aggregation filtering.

---

**Window Function** — A function that performs a calculation across a defined set of rows (called a "window") related to the current row, without collapsing those rows into a single summary value the way aggregate functions do. Window functions use the `OVER()` clause to define the window. For example, `RANK() OVER (PARTITION BY region ORDER BY revenue DESC)` assigns a rank to each salesperson within their region without removing any rows from the result. Window functions are essential for running totals, rankings, and period-over-period comparisons in analytical SQL.

---

**WITH (CTE Syntax)** — The keyword that introduces a Common Table Expression, allowing you to define one or more named temporary result sets before the main query. The syntax `WITH cte_name AS (SELECT ...)` creates a named block of logic that the following query can reference by name, as if it were a table. Multiple CTEs can be chained in sequence, each building on the previous. The `WITH` keyword signals to both the database engine and the reader that the query is structured in logical, named layers — a hallmark of professional, maintainable SQL.

---

*Use this glossary as a living reference. The first time you encounter any term in the chapters ahead, return here for a plain-language anchor before continuing. Familiarity with these definitions will accelerate your ability to read, write, and debug SQL with confidence.*
