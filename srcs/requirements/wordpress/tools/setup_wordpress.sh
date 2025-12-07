#!/bin/bash

cd /var/www/html

# Wait for MariaDB to be ready
echo "Waiting for MariaDB to be ready..."
until mysql -h${WORDPRESS_DB_HOST%:*} -u${WORDPRESS_DB_USER} -p${WORDPRESS_DB_PASSWORD} -e "SELECT 1" &>/dev/null; do
    echo "MariaDB is not ready yet..."
    sleep 3
done
echo "MariaDB is ready!"

# Download WordPress if not exists
if [ ! -f wp-config.php ]; then
    echo "Downloading WordPress..."
    wp core download --allow-root
    
    echo "Creating wp-config.php..."
    wp config create \
        --dbname=${WORDPRESS_DB_NAME} \
        --dbuser=${WORDPRESS_DB_USER} \
        --dbpass=${WORDPRESS_DB_PASSWORD} \
        --dbhost=${WORDPRESS_DB_HOST} \
        --allow-root
    
    echo "Installing WordPress..."
    wp core install \
        --url=${WORDPRESS_URL} \
        --title="${WORDPRESS_TITLE}" \
        --admin_user=${WORDPRESS_ADMIN_USER} \
        --admin_password=${WORDPRESS_ADMIN_PASSWORD} \
        --admin_email=${WORDPRESS_ADMIN_EMAIL} \
        --skip-email \
        --allow-root
    
    echo "Creating additional user..."
    wp user create \
        ${WORDPRESS_USER} \
        ${WORDPRESS_USER_EMAIL} \
        --role=author \
        --user_pass=${WORDPRESS_USER_PASSWORD} \
        --allow-root

    echo "WordPress installation complete!"
else
    echo "WordPress already installed, skipping setup..."
fi

echo "Starting PHP-FPM..."
exec php-fpm7.4 -F