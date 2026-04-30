#!/bin/bash
set -e

# Create the three databases
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE saleshorse;
    CREATE DATABASE paybuddy;
    CREATE DATABASE healthcare;
EOSQL

# Load each database schema and data
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname saleshorse \
    -f /docker-entrypoint-initdb.d/sql/saleshorse.sql

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname paybuddy \
    -f /docker-entrypoint-initdb.d/sql/paybuddy.sql

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname healthcare \
    -f /docker-entrypoint-initdb.d/sql/healthcare.sql
