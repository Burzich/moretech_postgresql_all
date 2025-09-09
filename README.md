# Postgresql Debichы

0. Запустите `docker-compose.yml`:

## Автоматизация: sh-скрипт

Запустите скрипт:

```bash
./init_pg_stat_statements.sh
```

---

## Инструкция по установке pg_stat_statements и созданию readonly пользователя

```bash
docker compose up -d
```

1. Зайдите в контейнер с базой данных:

```bash
docker exec -it postgres_db bash
```

2. Установите расширение postgresql-contrib:

```bash
apt update && apt install -y postgresql-contrib nano
```

3. Откройте файл конфигурации PostgreSQL:

```bash
nano /var/lib/postgresql/data/postgresql.conf
```

4. Добавьте строку:

```
shared_preload_libraries = 'pg_stat_statements'
```

5. Перезапустите контейнер:

```bash
docker compose restart
```

6. Подключитесь к базе данных:

```bash
docker exec -it postgres_db psql -U postgres
```

7. В psql выполните:

```sql
CREATE EXTENSION pg_stat_statements;
CREATE ROLE readonly_user WITH LOGIN PASSWORD 'secure_password';
GRANT CONNECT ON DATABASE postgres TO readonly_user;
GRANT USAGE ON SCHEMA public TO readonly_user;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO readonly_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO readonly_user;
GRANT pg_read_all_stats TO readonly_user;
```
