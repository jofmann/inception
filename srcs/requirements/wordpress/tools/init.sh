#!/bin/bash

# Warten bis MariaDB bereit ist
# until mysqladmin ping -h ${WORDPRESS_DB_HOST} --silent; do
#     sleep 1
# done

# Prüfen ob WordPress bereits installiert ist
if [ ! -f /var/www/html/wp-config.php ]; then

    # WordPress herunterladen
    wp core download \
        --path=/var/www/html \
        --allow-root

    # wp-config.php erstellen
    wp config create \
        --path=/var/www/html \
        --dbname=${WORDPRESS_DB_NAME} \
        --dbuser=${WORDPRESS_DB_USER} \
        --dbpass=${WORDPRESS_DB_PASSWORD} \
        --dbhost=${WORDPRESS_DB_HOST} \
        --allow-root

    # WordPress installieren
    wp core install \
        --path=/var/www/html \
        --url=${WORDPRESS_URL} \
        --title=${WORDPRESS_TITLE} \
        --admin_user=${WORDPRESS_ADMIN_USER} \
        --admin_password=${WORDPRESS_ADMIN_PASSWORD} \
        --admin_email=${WORDPRESS_ADMIN_EMAIL} \
        --allow-root

    # Zweiten User erstellen (Inception Anforderung)
    wp user create \
        --path=/var/www/html \
        ${WORDPRESS_USER} ${WORDPRESS_USER_EMAIL} \
        --user_pass=${WORDPRESS_USER_PASSWORD} \
        --role=author \
        --allow-root

    # Berechtigungen setzen
    chown -R www-data:www-data /var/www/html

fi

exec php-fpm8.2 -F