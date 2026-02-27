#!/bin/bash

# Generate a self-signed SSL certificate for Nginx
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/inception.key \
    -out /etc/ssl/certs/inception.crt \
    -subj "/CN=localhost"

# Start Nginx in the foreground
exec nginx -g "daemon off;"