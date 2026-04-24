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