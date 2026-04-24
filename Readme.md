# dbops-project
Исходный репозиторий для выполнения проекта дисциплины "DBOps"

1. Создание базы данных `store`
```
CREATE DATABASE store;
```

2. Создание пользователя `storetester` и выдача соответствующих прав
```
CREATE USER storetester WITH PASSWORD 'supersecretpassword';
```

```
GRANT ALL PRIVILEGES ON DATABASE store TO storetester;
```