#!/bin/bash

set -e

echo "Starting MariaDB initialization..."

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

echo "Starting MariaDB daemon..."
mysqld_safe --datadir=/var/lib/mysql &
pid=$!

echo "Waiting for MariaDB to start..."
for i in {30..0}; do
    if [ -S "/var/run/mysqld/mysqld.sock" ] && mysqladmin ping --socket=/var/run/mysqld/mysqld.sock &>/dev/null; then
        break
    fi
    echo "MariaDB is starting... $i (checking socket)"
    sleep 2
done

if [ "$i" = 0 ]; then
    echo "MariaDB failed to start"
    echo "Checking if socket exists:"
    ls -la /var/run/mysqld/
    echo "Checking MariaDB process:"
    ps aux | grep mysql
    exit 1
fi

echo "MariaDB started successfully"

# Check if database already exists
if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
    echo "Creating database and users..."
    
    mysql -u root --socket=/var/run/mysqld/mysqld.sock <<-EOSQL
        CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
        CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
        GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
        FLUSH PRIVILEGES;
EOSQL
    
    echo "Database and users created successfully"
else
    echo "Database already exists, skipping creation"
fi

# Shutdown temporary instance
mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" --socket=/var/run/mysqld/mysqld.sock shutdown

echo "MariaDB initialization complete"

# Start MariaDB in foreground
exec mysqld --user=mysql --console