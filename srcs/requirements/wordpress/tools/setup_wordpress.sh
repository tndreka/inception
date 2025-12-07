#!/bin/bash

cd /var/www/html

# Wait for MariaDB to be ready
echo "Waiting for MariaDB to be ready..."
until mysql -h${WORDPRESS_DB_HOST%:*} -u${WORDPRESS_DB_USER} -p${WORDPRESS_DB_PASSWORD} -e "SELECT 1" &>/dev/null; do
    echo "MariaDB is not ready yet..."
    sleep 3
done
echo "MariaDB is ready!"

# Start PHP-FPM in foreground
echo "Starting PHP-FPM..."
exec php-fpm7.4 -F