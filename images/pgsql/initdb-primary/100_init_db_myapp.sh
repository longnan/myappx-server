#!/bin/bash
set -e # exit if a command exits with a not-zero exit code

echo "Creating database role (if not existed): $MYAPPX_DB_USER"
psql -U postgres -tc "SELECT 1 FROM pg_catalog.pg_roles WHERE rolname = '$MYAPPX_DB_USER'" \
| grep -q 1 \
|| psql -U postgres -c "CREATE ROLE $MYAPPX_DB_USER LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT NOREPLICATION PASSWORD '$MYAPPX_DB_PASS';"
