# Normalisation Worked Example — 1NF to 3NF

## Overview

Normalisation is the process of restructuring a flat, denormalised table into a set of focused, well-organised tables that eliminate redundancy and prevent update anomalies. As Chapter 12 explains, these anomalies are exactly the kind of silent data corruption that produces wrong analytical results — the worst outcome for any analyst.

This walkthrough takes a single messy flat table through **First Normal Form (1NF)**, **Second Normal Form (2NF)**, and **Third Normal Form (3NF)**, showing the exact decisions made at each step.

---

## The Starting Point: A Denormalised Flat Table

Imagine a retail company stores all order information in one table called `orders_flat`.

| order_id | customer_id | customer_name | customer_city | product_ids   | product_names          | unit_prices  | quantity | order_date |
|----------|-------------|---------------|---------------|---------------|------------------------|--------------|----------|------------|
| 1001     | 42          | Sarah Chen    | Austin        | P01, P03      | Notebook, Stapler      | 3.99, 1.49   | 2, 1     | 2024-01-15 |
| 1002     | 17          | Marcus Webb   | Denver        | P02           | Pen Set                | 5.99         | 3        | 2024-01-16 |
| 1003     | 42          | Sarah Chen    | Austin        | P01           | Notebook               | 3.99         | 5        | 2024-01-18 |

**Problems visible immediately:**
- `product_ids`, `product_names`, `unit_prices`, and `quantity` hold multiple values in a single cell (comma-separated lists).
- `customer_name` and `customer_city` repeat every time customer 42 places an order.
- Changing Sarah Chen's city requires updating every row she appears in — a classic **update anomaly**.

---

## Step 1 — Apply First Normal Form (1NF)

**Rule:** Every column must hold a single, atomic value. No repeating groups.

Split each product onto its own row so every cell contains exactly one value.

| order_id | customer_id | customer_name | customer_city | product_id | product_name | unit_price | quantity | order_date |
|----------|-------------|---------------|---------------|------------|--------------|------------|----------|------------|
| 1001     | 42          | Sarah Chen    | Austin        | P01        | Notebook     | 3.99       | 2        | 2024-01-15 |
| 1001     | 42          | Sarah Chen    | Austin        | P03        | Stapler      | 1.49       | 1        | 2024-01-15 |
| 1002     | 17          | Marcus Webb   | Denver        | P02        | Pen Set      | 5.99       | 3        | 2024-01-16 |
| 1003     | 42          | Sarah Chen    | Austin        | P01        | Notebook     | 3.99       | 5        | 2024-01-18 |

The **composite primary key** is now `(order_id, product_id)` — the combination that uniquely identifies each row.

Redundancy still exists, but the table is now in 1NF.

---

## Step 2 — Apply Second Normal Form (2NF)

**Rule:** Every non-key column must depend on the **whole** primary key, not just part of it.

With the composite key `(order_id, product_id)`, ask: does each column need *both* parts to be determined?

- `customer_id`, `customer_name`, `customer_city`, `order_date` depend only on `order_id` — **partial dependency**.
- `product_name`, `unit_price` depend only on `product_id` — **partial dependency**.
- `quantity` depends on both `order_id` and `product_id` — correctly placed.

**Solution:** Split into three tables.

**`orders`**
| order_id | customer_id | order_date |
|----------|-------------|------------|
| 1001     | 42          | 2024-01-15 |
| 1002     | 17          | 2024-01-16 |
| 1003     | 42          | 2024-01-18 |

**`order_items`**
| order_id | product_id | quantity |
|----------|------------|----------|
| 1001     | P01        | 2        |
| 1001     | P03        | 1        |
| 1002     | P02        | 3        |
| 1003     | P01        | 5        |

**`products`**
| product_id | product_name | unit_price |
|------------|--------------|------------|
| P01        | Notebook     | 3.99       |
| P02        | Pen Set      | 5.99       |
| P03        | Stapler      | 1.49       |

Customer data still lives inside `orders`. That leads to Step 3.

---

## Step 3 — Apply Third Normal Form (3NF)

**Rule:** No non-key column should depend on another non-key column (no **transitive dependencies**).

In `orders`, `customer_name` and `customer_city` depend on `customer_id`, not directly on `order_id`. That is a transitive dependency through a non-key column.

**Solution:** Extract a `customers` table.

**`customers`**
| customer_id | customer_name | customer_city |
|-------------|---------------|---------------|
| 42          | Sarah Chen    | Austin        |
| 17          | Marcus Webb   | Denver        |

Update `orders` to reference `customer_id` as a **foreign key** only — the name and city now live in exactly one place.

---

## The Fully Normalised Schema

Four focused tables — `customers`, `orders`, `order_items`, `products` — connected by primary and foreign keys. This is the **schema blueprint** Chapter 12 describes: every meaningful JOIN you write traces back to these key relationships. Updating Sarah Chen's city now requires changing exactly one row in `customers`. No anomalies. No corrupted analysis.

> **Analyst tip:** When you encounter a slow or confusing query in production, check whether the schema reached 3NF. Denormalised tables often signal missing indexes too — another Chapter 12 warning sign that a two-second query can become a two-minute bottleneck.
