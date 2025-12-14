# User Documentation

## Overview

This document explains how to use the Inception infrastructure as an end user or administrator.

## Services Provided

The stack provides:
- **WordPress Website**: Full-featured CMS accessible via HTTPS
- **Admin Panel**: WordPress dashboard for content management
- **Database**: MariaDB backend (internal, not directly accessible)

## Starting and Stopping

### Start the Project
bash
cd inception
make all


This will:
1. Create data directories
2. Build Docker images
3. Start all services

**Wait 30-60 seconds** for all services to initialize.

### Stop the Project
bash
make down


This stops all containers but preserves your data.

### Check Status
bash
make status


Shows which containers are running.

## Accessing the Website

### Main Website

1. **Open browser**: `https://tndreka.42.fr`
2. **Accept SSL warning**: The certificate is self-signed
3. **View website**: You should see the WordPress homepage

### Administration Panel

1. **Go to**: `https://tndreka.42.fr/wp-admin`
2. **Login with admin credentials:**
   - Username: `webmaster` (from `srcs/.env`: `WORDPRESS_ADMIN_USER`)
   - Password: (from `secrets/wp_admin_password.txt`)
3. **Manage content**: Create posts, pages, customize theme

## Managing Credentials

### Location

Credentials are stored in two places:
- **Environment variables**: `srcs/.env` (usernames, database names, non-sensitive config)
- **Secrets**: `secrets/` directory (passwords only - **NOT committed to git**)

### Available Credentials

**Environment file:**
bash
cat srcs/.env


You'll find:
- **WordPress Admin User**: `WORDPRESS_ADMIN_USER`
- **WordPress User**: `WORDPRESS_USER`
- **Database User**: `MYSQL_USER`
- **Database Name**: `MYSQL_DATABASE`

**Secrets (passwords):**
bash
ls secrets/


Passwords are stored in:
- `secrets/db_root_password.txt` - MariaDB root password
- `secrets/db_password.txt` - MariaDB user password
- `secrets/wp_admin_password.txt` - WordPress admin password
- `secrets/wp_user_password.txt` - WordPress user password

### Changing Passwords

1. **Edit the secret files** in `secrets/` directory
2. **Rebuild services**:
bash
   make fclean
   make all


## Checking Services

### View Logs
bash
# All services
make logs

# Specific service
docker logs nginx
docker logs wordpress
docker logs mariadb


### Check Container Health
bash
docker ps


Look for:
- **Status**: Should say "Up" and "(healthy)" for mariadb
- **Ports**: nginx should show `0.0.0.0:443->443/tcp`

### Test Website Response
bash
curl -k https://tndreka.42.fr


Should return HTML content.

### Test Database Connection
bash
docker exec -it mariadb mysql -u wpuser -p
# Enter password from MYSQL_PASSWORD in .env


## Troubleshooting

### Website Not Loading

1. **Check containers are running**:
bash
   docker ps


2. **Check NGINX logs**:
bash
   docker logs nginx


3. **Restart services**:
bash
   make restart


### Database Connection Errors

1. **Check MariaDB is healthy**:
bash
   docker ps | grep mariadb

   Should show "(healthy)"

2. **Check WordPress logs**:
bash
   docker logs wordpress


3. **Verify credentials** in `.env` match

### Permission Errors
bash
sudo chown -R $USER:$USER /home/tndreka/data


## Data Backup

### Backup Database
bash
docker exec mariadb mysqldump -u root -p wordpress > backup.sql
# Enter MYSQL_ROOT_PASSWORD when prompted


### Backup WordPress Files
bash
cp -r /home/tndreka/data/wordpress ~/wordpress_backup


## Complete Reset

**WARNING: This deletes all data!**
bash
make fclean
make all


This:
1. Stops all containers
2. Removes all images
3. Deletes all volumes and data
4. Rebuilds everything from scratch