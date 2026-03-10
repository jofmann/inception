#!/bin/bash

envsubst '${DOMAIN_NAME}' < /etc/nginx/templates/nginx.conf > /etc/nginx/sites-available/default

# Start Nginx in the foreground
exec nginx -g "daemon off;"