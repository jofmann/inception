#!/bin/bash

# Check if WordPress is already installed (by checking for wp-config.php)
if [ ! -f /var/www/html/wp-config.php ]; then

    wp core download \
        --path=/var/www/html \
        --allow-root

   wp config create \
        --path=/var/www/html \
        --dbname=${MYSQL_DATABASE} \
        --dbuser=${MYSQL_USER} \
        --dbpass=${MYSQL_PASSWORD} \
        --dbhost=${WORDPRESS_DB_HOST} \
        --allow-root

    wp core install \
        --path=/var/www/html \
        --url=${WORDPRESS_URL} \
        --title=${WORDPRESS_TITLE} \
        --admin_user=${WORDPRESS_ADMIN_USER} \
        --admin_password=${WORDPRESS_ADMIN_PASSWORD} \
        --admin_email=${WORDPRESS_ADMIN_EMAIL} \
        --allow-root

    # second user
    wp user create \
        --path=/var/www/html \
        ${WORDPRESS_USER} ${WORDPRESS_USER_EMAIL} \
        --user_pass=${WORDPRESS_USER_PASSWORD} \
        --role=author \
        --allow-root

    # set permissions
    chown -R www-data:www-data /var/www/html

fi

exec php-fpm8.2 -F