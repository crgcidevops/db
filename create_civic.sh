#!/bin/sh
set -e
POSTGRES="psql"

export PGUSER="$POSTGRES_USER"

$POSTGRES -E <<EOSQL
CREATE DATABASE template_civic;
UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template_civic';
EOSQL

$POSTGRES -d template_civic -E <<-EOSQL
CREATE EXTENSION hstore;
CREATE EXTENSION postgis;
CREATE EXTENSION postgis_topology;
EOSQL

$POSTGRES -E <<EOSQL
CREATE DATABASE civic TEMPLATE template_civic;
EOSQL
