#!/bin/sh

if [ -f ./wp-config.php ]
    then
        echo "Wordpress already downloaded"
    else
    sleep 40
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
    mkdir -p /var/www/html
    chmod -R 777 /var/www/html
    cd /var/www/html

    wp core download --allow-root

    >&2 echo $MARIADB_NAME
    >&2 echo $MARIADB_USER
    >&2 echo $MARIADB_PWD
    >&2 echo $MARIADB_HOST

    wp config create --dbname=$MARIADB_NAME --dbuser=$MARIADB_USER --dbpass=$MARIADB_PWD --dbhost=$MARIADB_HOST --allow-root

    wp core install --url=$DOMAIN_NAME --title="Inception" --admin_user=$WORDPRESS_ADMIN_USR --admin_password=$WORDPRESS_ADMIN_PWD --admin_email=$WORDPRESS_ADMIN_EMAIL --allow-root
    wp user create $WORDPRESS_USER $WORDPRESS_USER_EMAIL --role=subscriber --user_pass=$WORDPRESS_USER_PASSWORD --allow-root
fi

 mkdir -p /var/run/php
 sed -i 's/listen = /run/php/php7.4-fpm.sock/listen = 0.0.0.0:9000/' /etc/php/7.4/fpm/pool.d/www.conf
#  /etc/init.d/php7.4-fpm restart
/usr/sbin/php-fpm7 -F -R
# exec "$@"
# tail -f /dev/null