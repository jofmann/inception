FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Create test index.html
RUN echo "<h1>Inception Nginx läuft!</h1>" > /var/www/html/index.html

COPY conf/nginx.conf /etc/nginx/sites-available/default
COPY tools/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

EXPOSE 443

ENTRYPOINT ["init.sh"]