# Execution Plan Reading Walkthrough

## What This Document Is and How to Use It

Reading an execution plan is the single most direct route from "my query is slow" to "I know exactly why and what to fix." This walkthrough annotates a realistic `EXPLAIN ANALYZE` output — the kind you will encounter after completing Chapter 15 — so that every node, cost indicator, and row estimate has a clear label and an actionable implication.

Work through this document alongside the Chapter 15 section *Reading and Interpreting an Execution Plan Without Being a DBA*. The goal is not to memorise syntax but to build a mental model you can apply to any query.

---

## The Sample Query

```sql
SELECT c.customer_name, SUM(o.order_total) AS lifetime_value
FROM   customers c
JOIN   orders o ON c.customer_id = o.customer_id
WHERE  o.order_date >= '2023-01-01'
GROUP  BY c.customer_name
ORDER  BY lifetime_value DESC;
```

This query joins two tables, filters by date, aggregates, and sorts — a representative real-world pattern that exercises every major performance concern from Chapter 15.

---

## Annotated Execution Plan Output

```
Sort  (cost=4812.33..4815.21 rows=1154 width=40)
      (actual time=98.441..98.512 rows=1154 loops=1)
  Sort Key: (sum(o.order_total)) DESC
  Sort Method: quicksort  Memory: 112kB
  ->  HashAggregate  (cost=4740.10..4752.98 rows=1154 width=40)
        (actual time=97.201..97.388 rows=1154 loops=1)
        Group Key: c.customer_name
        ->  Hash Join  (cost=1820.00..4680.55 rows=11910 width=32)
              (actual time=22.317..89.441 rows=11910 loops=1)
              Hash Cond: (o.customer_id = c.customer_id)
              ->  Seq Scan on orders  (cost=0.00..2510.00 rows=11910 width=20)
                    (actual time=0.021..44.882 rows=11910 loops=1)
                    Filter: (order_date >= '2023-01-01'::date)
                    Rows Removed by Filter: 38090
              ->  Hash  (cost=1120.00..1120.00 rows=56000 width=20)
                    (actual time=21.904..21.904 rows=56000 loops=1)
                    ->  Seq Scan on customers  (cost=0.00..1120.00 rows=56000 width=20)
                          (actual time=0.012..10.337 rows=56000 loops=1)
```

---

## Node-by-Node Breakdown

| Node | What It Does | Key Indicator to Watch | Implication |
|---|---|---|---|
| **Sort** | Orders results by `lifetime_value DESC` | `Sort Method: quicksort Memory` | If memory exceeds `work_mem`, it spills to disk — a major slowdown |
| **HashAggregate** | Groups rows by `customer_name` | `actual time` vs `cost` estimate | Large gaps between estimated and actual rows signal stale statistics |
| **Hash Join** | Matches `orders` rows to `customers` rows via a hash table | `Hash Cond` column | Hash joins are efficient; a Nested Loop here on large tables would be a warning sign |
| **Seq Scan on orders** | Reads every row in `orders` before filtering | `Rows Removed by Filter: 38090` | **Critical finding:** 38 090 rows discarded after reading — an index on `order_date` would eliminate this scan |
| **Seq Scan on customers** | Reads every row in `customers` | All 56 000 rows returned | Acceptable here because all customers are needed for the join; an index would not help |

---

## Reading the Cost Numbers

Every node shows `cost=start..total`. These are **relative units**, not seconds.

- **Start cost** — work the engine must do before it can return the first row.
- **Total cost** — estimated work to return all rows.
- Compare `cost` (estimate) to `actual time` (milliseconds). A large mismatch means the query planner is working from outdated statistics. Run `ANALYZE orders;` to refresh them.

---

## The Critical Finding: Sequential Scan with High Filter Removal

The `Seq Scan on orders` with `Rows Removed by Filter: 38090` is the performance bottleneck. The database read all 50 000 rows in `orders` and discarded 76% of them. Chapter 15 explains this directly: an index acts as a pre-sorted reference, letting the engine jump to the qualifying rows without touching the rest.

**Fix:** Create a B-tree index on the filtered column.

```sql
CREATE INDEX idx_orders_order_date ON orders (order_date);
```

After adding this index, the planner will replace the `Seq Scan` with an `Index Scan` or `Bitmap Index Scan`, reading only the ~11 910 qualifying rows from the start.

---

## What to Check in Any Execution Plan

- **Seq Scan + high filter removal** → candidate for an index on the filter column
- **Nested Loop on large tables** → may indicate a missing join-column index
- **Estimated rows far from actual rows** → run `ANALYZE` to update statistics
- **Sort spilling to disk** → increase `work_mem` or pre-sort with an index
- **Loops > 1** → the node runs repeatedly; small inefficiencies multiply fast

---

## Next Step

After adding the index, re-run `EXPLAIN ANALYZE` on the same query and compare the two plans side by side. The before-and-after comparison is the evidence-based confirmation that Chapter 15 emphasises: optimisation without measurement is guesswork.
