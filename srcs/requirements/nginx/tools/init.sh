#!/bin/bash

# Generate a self-signed SSL certificate for Nginx
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/inception.key \
    -out /etc/ssl/certs/inception.crt \
    -subj "/CN=${DOMAIN_NAME}"

envsubst '${DOMAIN_NAME}' < /etc/nginx/templates/nginx.conf > /etc/nginx/sites-available/default

# Start Nginx in the foreground
exec nginx -g "daemon off;"