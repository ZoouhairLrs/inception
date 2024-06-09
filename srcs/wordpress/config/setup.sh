#!/bin/bash

timeout_duration=600

start_time=$(date +%s)

while ! mariadb -h$MARIADB_HOST -u$MARIADB_USER -p$MARIADB_PWD $MARIADB_NAME &>/dev/null; do
    sleep 2
    echo "connecting to mariadb ..."

    current_time=$(date +%s)
    time_passing=$((current_time - start_time))

    if [ $time_passing -ge $timeout_duration ]; then
        echo "Timeout: Connection to MariaDB took too long."
        break
    fi
done

if [ ! -f "/usr/local/bin/wp" ]; then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar 

    sleep 1

    chmod 777 wp-cli.phar 
    mv wp-cli.phar /usr/local/bin/wp
    wp cli update
fi

if [ ! -d "/var/www/html/" ]; then
    mkdir -p /var/www/html
fi

wp core download  --path="/var/www/html" --allow-root

cd /var/www/html/

wp config create --dbname=$MARIADB_NAME --dbuser=$MARIADB_USER --dbpass=$MARIADB_PWD --dbhost=$MARIADB_HOST --path="/var/www/html" --allow-root

wp core install --url=$DOMAIN_NAME --title=$WORDPRESS_TITLE --admin_user=$WORDPRESS_ADMIN_USR --admin_password=$WORDPRESS_ADMIN_PWD --admin_email=$WORDPRESS_ADMIN_EMAIL --path="/var/www/html" --allow-root

wp user create $WORDPRESS_USR $WORDPRESS_USR_EMAIL --role=author --user_pass=$WORDPRESS_USR_PWD --path="/var/www/html" --allow-root   


sed -i 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 9000/g' /etc/php/7.4/fpm/pool.d/www.conf

mkdir -p /run/php
/usr/sbin/php-fpm7.4 --nodaemonize