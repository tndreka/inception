FROM debian:bullseye

# Update and install basic dependencies
RUN apt-get update && \
    apt-get install -y \
    wget \
    curl \
    mariadb-client && \
    rm -rf /var/lib/apt/lists/*

# Create WordPress directory
RUN mkdir -p /var/www/html

WORKDIR /var/www/html

EXPOSE 9000