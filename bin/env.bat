REM ======================================================
REM Environment Setup (Standalone Version)
REM ======================================================
@REM MyAppx ENV
set MYAPPX_TAG=13.0.0.latest
set MYAPPX_DEBUG=true
set MYAPPX_DB_HOST=pgserver
set MYAPPX_DB_PORT=5432
set MYAPPX_DB_NAME=idempiere_db
set MYAPPX_DB_USER=adempiere
set MYAPPX_DB_PASS=adempiere
set MYAPPX_MIGRATE_EXISTING_DATABASE=true

set DOMAIN_NAME=local.corp
set LOCAL_TZ=Asia/Shanghai

REM ======================================================
REM Image Tag & Container settings
REM ======================================================
@REM Traefik & Portainer
set IMAGE_TRAEFIK_TAG=v3.6.6
set IMAGE_PORTAINER_TAG=2.33.6
REM ======================================================
@REM Greenmail
set IMAGE_GREENMAIL_TAG=2.1.8
set IMAGE_ROUNDCUBEMAIL_TAG=1.6.12-apache
REM ======================================================
@REM PostgreSQL
set IMAGE_POSTGRESQL_TAG=18.1
set POSTGRES_USER=postgres
set POSTGRES_PASSWORD=postgres
set REPLICATION_PASSWORD=replication
set REPLICATION_SLOT_NAME=slot_standby
set POSTGRES_MASTER_SERVICE_HOST=pgserver
set POSTGRES_MASTER_SERVICE_PORT=5432
@REM Pgadmin4
set IMAGE_PGADMIN4_TAG=9.11
set PGADMIN_DEFAULT_EMAIL=pgadmin4@local.corp
set PGADMIN_DEFAULT_PASSWORD=pgadmin4
set PGADMIN_CONFIG_MAIL_SERVER='greenmail'
set PGADMIN_CONFIG_MAIL_PORT=465
set PGADMIN_CONFIG_MAIL_USE_SSL=True
set PGADMIN_CONFIG_SECURITY_EMAIL_SENDER='no-reply@local.corp'
REM ======================================================
