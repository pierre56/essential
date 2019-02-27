# Postgres Cheatsheet

This is a collection of the most common commands I run while administering Postgres databases. The variables shown between the open and closed tags, "<" and ">", should be replaced with a name you choose. Postgres has multiple shortcut functions, starting with a forward slash, "\". Any SQL command that is not a shortcut, must end with a semicolon, ";". You can use the keyboard UP and DOWN keys to scroll the history of previous commands you've run.


## Setup

##### installation, Ubuntu
http://www.postgresql.org/download/linux/ubuntu/
https://help.ubuntu.com/community/PostgreSQL
``` shell
sudo echo "deb http://apt.postgresql.org/pub/repos/apt/ wily-pgdg main" > \
  /etc/apt/sources.list.d/pgdg.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y postgresql-9.5 postgresql-client-9.5 postgresql-contrib-9.5

sudo su - postgres
psql
```

##### connect
http://www.postgresql.org/docs/current/static/app-psql.html
```sql
psql

psql -U <username> -d <database> -h <hostname>

psql --username=<username> --dbname=<database> --host=<hostname>
```

##### disconnect
```sql
\q
\!
```

##### clear the screen
```sql
(CTRL + L)
```

##### info
```sql
\conninfo
```

##### configure

http://www.postgresql.org/docs/current/static/runtime-config.html

```shell
sudo nano $(locate -l 1 main/postgresql.conf)
sudo service postgresql restart
```

##### debug logs
```shell
# print the last 24 lines of the debug log
sudo tail -24 $(find /var/log/postgresql -name 'postgresql-*-main.log')
```
<br/><br/><br/>





## Recon

##### show version
```
SHOW SERVER_VERSION;
```

##### show system status
```sql
\conninfo
```

##### show environmental variables
```sql
SHOW ALL;
```

##### list users
```sql
SELECT rolname FROM pg_roles;
```

##### show current user
```sql
SELECT current_user;
```

##### show current user's permissions
```
\du
```

##### list databases
```sql
\l
```

##### show current database
```sql
SELECT current_database();
```

##### show all tables in database
```sql
\dt
```

##### list functions
```sql
\df <schema>
```
<br/><br/><br/>





## Databases

##### list databasees
```sql
\l
```

##### connect to database
```sql
\c <database_name>
```

##### show current database
```sql
SELECT current_database();
```

##### create database
http://www.postgresql.org/docs/current/static/sql-createdatabase.html
```sql
CREATE DATABASE <database_name> WITH OWNER <username>;
```
##### delete database
http://www.postgresql.org/docs/current/static/sql-dropdatabase.html
```sql
DROP DATABASE IF EXISTS <database_name>;
```

##### rename database
http://www.postgresql.org/docs/current/static/sql-alterdatabase.html
```sql
ALTER DATABASE <old_name> RENAME TO <new_name>;
```
<br/><br/><br/>




## Users

##### list roles
```sql
SELECT rolname FROM pg_roles;
```

##### create user
http://www.postgresql.org/docs/current/static/sql-createuser.html
```sql
CREATE USER <user_name> WITH PASSWORD '<password>';
```

##### drop user
http://www.postgresql.org/docs/current/static/sql-dropuser.html
```sql
DROP USER IF EXISTS <user_name>;
```

##### alter user password
http://www.postgresql.org/docs/current/static/sql-alterrole.html
```sql
ALTER ROLE <user_name> WITH PASSWORD '<password>';
```
<br/><br/><br/>





## Permissions

##### become the postgres user, if you have permission errors
```shell
sudo su - postgres
psql
```

##### grant all permissions on database
http://www.postgresql.org/docs/current/static/sql-grant.html
```sql
GRANT ALL PRIVILEGES ON DATABASE <db_name> TO <user_name>;
```

##### grant connection permissions on database
```sql
GRANT CONNECT ON DATABASE <db_name> TO <user_name>;
```

##### grant permissions on schema
```sql
GRANT USAGE ON SCHEMA public TO <user_name>;
```

##### grant permissions to functions
```sql
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO <user_name>;
```

##### grant permissions to select, update, insert, delete, on a all tables
```sql
GRANT SELECT, UPDATE, INSERT ON ALL TABLES IN SCHEMA public TO <user_name>;
```

##### grant permissions, on a table
```sql
GRANT SELECT, UPDATE, INSERT ON <table_name> TO <user_name>;
```

##### grant permissions, to select, on a table
```sql
GRANT SELECT ON ALL TABLES IN SCHEMA public TO <user_name>;
```
<br/><br/><br/>





## Schema

#####  list schemas
```sql
\dn

SELECT schema_name FROM information_schema.schemata;

SELECT nspname FROM pg_catalog.pg_namespace;
```

#####  create schema
http://www.postgresql.org/docs/current/static/sql-createschema.html
```sql
CREATE SCHEMA IF NOT EXISTS <schema_name>;
```

#####  drop schema
http://www.postgresql.org/doc
