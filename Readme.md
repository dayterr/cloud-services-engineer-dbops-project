# dbops-project
Исходный репозиторий для выполнения проекта дисциплины "DBOps"

1. Создание базы данных `store`
```
CREATE DATABASE store;
```

2. Создание пользователя `storetester`
```
CREATE USER storetester WITH PASSWORD 'supersecretpassword';
```
и выдача соответствующих прав
```
GRANT ALL PRIVILEGES ON DATABASE store TO storetester;
```

3. Определение количества сосисок, проданного за каждый день предыдущей недели
```
SELECT o.date_created, SUM(op.quantity) as amount
FROM orders AS o
JOIN order_product AS op ON o.id = op.order_id
WHERE o.status = 'shipped' AND o.date_created > NOW() - INTERVAL '1 WEEK'
GROUP BY o.date_created
ORDER BY o.date_created desc;
```

4. Сравнение выполнения запроса с timing 

| До добавления индексов  | После добавления индексов  |
|---|---|
| 25.590 ms  | 12.313 ms  |

с командой `EXPLAIN ANALYZE` до добавления индексов

```
Sort  (cost=4581.89..4582.12 rows=91 width=12) (actual time=30.161..30.165 rows
=7 loops=1)
   Sort Key: o.date_created DESC
   Sort Method: quicksort  Memory: 25kB
   ->  HashAggregate  (cost=4578.02..4578.93 rows=91 width=12) (actual time=30.144..30.149 rows=7 loops=1)
         Group Key: o.date_created
         Batches: 1  Memory Usage: 24kB
         ->  Hash Join  (cost=2666.65..4566.16 rows=2372 width=8) (actual time=15.119..29.777 rows=2476 loops=1)
               Hash Cond: (op.order_id = o.id)
               ->  Seq Scan on order_product op  (cost=0.00..1637.00 rows=100000 width=12) (actual time=0.007..6.058 rows=100000 loops=1)
               ->  Hash  (cost=2637.00..2637.00 rows=2372 width=12) (actual time=15.090..15.091 rows=2476 loops=1)
                     Buckets: 4096  Batches: 1  Memory Usage: 149kB
                     ->  Seq Scan on orders o  (cost=0.00..2637.00 rows=2372 width=12) (actual time=0.025..14.664 rows=2476 loops=1)
                           Filter: (((status)::text = 'shipped'::text) AND (date_created > (now() - '7 days'::interval)))
                           Rows Removed by Filter: 97524
 Planning Time: 0.582 ms
 Execution Time: 30.212 ms
```

с командой `EXPLAIN ANALYZE` после добавления индексов
```
         Group Key: o.date_created
         Batches: 1  Memory Usage: 24kB
         ->  Hash Join  (cost=750.70..2650.21 rows=2372 width=8) (actual time=1.688..16.388 rows=2476 loops=1)
               Hash Cond: (op.order_id = o.id)
               ->  Seq Scan on order_product op  (cost=0.00..1637.00 rows=100000 width=12) (actual time=0.003..6.267 rows=100000 loops=1)
               ->  Hash  (cost=721.05..721.05 rows=2372 width=12) (actual time=1.667..1.668 rows=2476 loops=1)
                     Buckets: 4096  Batches: 1  Memory Usage: 149kB
                     ->  Bitmap Heap Scan on orders o  (cost=36.61..721.05 rows=2372 width=12) (actual time=0.209..1.325 rows=2476 loops=1)
                           Recheck Cond: (((status)::text = 'shipped'::text) AND (date_created > (now() - '7 days'::interval)))
                           Heap Blocks: exact=626
                           ->  Bitmap Index Scan on orders_status_date_idx  (cost=0.00..36.02 rows=2372 width=0) (actual time=0.125..0.125 rows=2476 loops=1)
                                 Index Cond: (((status)::text = 'shipped'::text) AND (date_created > (now() - '7 days'::interval)))
 Planning Time: 0.248 ms
 Execution Time: 16.797 ms
```

Можно увидеть, что при добавлении индексов время выполнения запроса сокращается почти в 2 раза.