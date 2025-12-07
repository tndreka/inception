FROM debian:bullseye

# Install PHP-FPM and WordPress dependencies
RUN apt-get update && \
    apt-get install -y \
    php7.4-fpm \
    php7.4-mysqli \
    php7.4-curl \
    php7.4-gd \
    php7.4-intl \
    php7.4-mbstring \
    php7.4-soap \
    php7.4-xml \
    php7.4-xmlrpc \
    php7.4-zip \
    wget \
    curl \
    mariadb-client && \
    rm -rf /var/lib/apt/lists/*

# Create WordPress directory
RUN mkdir -p /var/www/html

WORKDIR /var/www/html

EXPOSE 9000