#!/bin/sh

if [ -f ./wp-config.php ]
    then
        echo "Wordpress already downloaded"
    else
    sleep 40
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
    mkdir -p /var/www/html #-p : for creating parent directory.
    chmod -R 777 /var/www/html #-R : means the command will apply to all files and directories inside the specified directory.
    cd /var/www/html

    wp core download --allow-root

    # >&2 echo $MARIADB_NAME
    # >&2 echo $MARIADB_USER
    # >&2 echo $MARIADB_PWD
    # >&2 echo $MARIADB_HOST

    wp config create --dbname=$MARIADB_NAME --dbuser=$MARIADB_USER --dbpass=$MARIADB_PWD --dbhost=$MARIADB_HOST --allow-root

    wp core install --url=$DOMAIN_NAME --title="Inception" --admin_user=$WORDPRESS_ADMIN_USR --admin_password=$WORDPRESS_ADMIN_PWD --admin_email=$WORDPRESS_ADMIN_EMAIL --allow-root
    wp user create $WORDPRESS_USR $WORDPRESS_USR_EMAIL --role=subscriber --user_pass=$WORDPRESS_USR_PWD --allow-root
fi

 mkdir -p /var/run/php
#  sed -i '/listen = /run/php/php7.4-fpm.sock|listen = 9000/' /etc/php/7.4/fpm/pool.d/www.conf
 sed -i 's|^listen = .*|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf #sed : for parsing and transforming text in a pipeline or file. #-i :tells sed to edit files in place.

#  /etc/init.d/php7.4-fpm restart
# /usr/bin/php7.4 -F -R
# exec "$@"
/usr/sbin/php-fpm7.4 -F #This option stands for "foreground." When you run PHP-FPM with the -F option, it starts PHP-FPM in the foreground rather than as a daemon process.
# tail -f /dev/null