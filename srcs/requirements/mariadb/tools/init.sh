#!/bin/bash

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

MYSQL_USER_PASSWORD=$(cat /run/secrets/mysql_user_pw)
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/mysql_root_pw)

cat << EOF > /tmp/init.sql
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_USER_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

exec mysqld --user=mysql --init-file=/tmp/init.sql