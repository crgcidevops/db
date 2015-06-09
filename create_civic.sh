#!/bin/sh

POSTGRES="gosu postgres postgres"

$POSTGRES --single -E <<EOSQL
CREATE DATABASE template_civic;
UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template_civic';
EOSQL

$POSTGRES --single template_civic -E <<-EOSQL
CREATE EXTENSION hstore;
EOSQL

POSTGIS_CONFIG=/usr/share/postgresql/$PG_MAJOR/contrib/postgis-$POSTGIS_MAJOR
$POSTGRES --single template_civic -j < $POSTGIS_CONFIG/postgis.sql
$POSTGRES --single template_civic -j < $POSTGIS_CONFIG/topology.sql
$POSTGRES --single template_civic -j < $POSTGIS_CONFIG/spatial_ref_sys.sql

$POSTGRES --single -E <<EOSQL
CREATE DATABASE civic TEMPLATE template_civic;
EOSQL
