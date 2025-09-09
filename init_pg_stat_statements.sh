#!/bin/bash
set -e

docker exec -it postgres_db bash -c "apt update && apt install -y postgresql-contrib nano"
docker exec -it postgres_db bash -c "echo \"shared_preload_libraries = 'pg_stat_statements'\" >> /var/lib/postgresql/data/postgresql.conf"
docker compose restart
sleep 5
docker exec -it postgres_db psql -U postgres -c "CREATE EXTENSION IF NOT EXISTS pg_stat_statements;"
docker exec -it postgres_db psql -U postgres -c "CREATE ROLE readonly_user WITH LOGIN PASSWORD 'secure_password';"
docker exec -it postgres_db psql -U postgres -c "GRANT CONNECT ON DATABASE postgres TO readonly_user;"
docker exec -it postgres_db psql -U postgres -c "GRANT USAGE ON SCHEMA public TO readonly_user;"
docker exec -it postgres_db psql -U postgres -c "GRANT SELECT ON ALL TABLES IN SCHEMA public TO readonly_user;"
docker exec -it postgres_db psql -U postgres -c "ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO readonly_user;"
docker exec -it postgres_db psql -U postgres -c "GRANT pg_read_all_stats TO readonly_user;"
sleep 10
docker restart pgadvisor_backend
