#!/bin/bash
# set -x

sed -i 's/# port = 3306/port = 3306/' /etc/mysql/mariadb.cnf
sed -i 's/127.0.0.1/0.0.0.0/'         /etc/mysql/mariadb.conf.d/50-server.cnf

# # Start MariaDB service
service mysql start

# # Create a new database and user
mysql -e "CREATE DATABASE IF NOT EXISTS inception;"
mysql -e "CREATE USER IF NOT EXISTS 'user'@'%' IDENTIFIED BY 'password';"
mysql -e "GRANT ALL PRIVILEGES ON inception.* TO 'user'@'%';"
mysql -e "FLUSH PRIVILEGES;"

# # Stop MariaDB service
service mysql stop

# Run CMD specified in Dockerfile
exec "$@"
