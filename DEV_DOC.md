# Developer Documentation

## Setting Up From Scratch

### Prerequisites

1. **Virtual Machine** with Debian/Ubuntu
2. **Docker & Docker Compose** installed
3. **Git** for version control
4. **Make** for build automation

### Install Docker (if needed)
bash
sudo apt update
sudo apt install -y docker.io docker-compose
sudo usermod -aG docker $USER
# Log out and back in


### Clone and Configure
bash
# Clone repository
git clone https://github.com/tndreka/inception.git
cd inception

# Create .env file
cat > srcs/.env << 'ENVEOF'
DOMAIN_NAME=tndreka.42.fr
VOLUME_PATH=/home/tndreka/data

MYSQL_ROOT_PASSWORD=your_root_password
MYSQL_DATABASE=wordpress
MYSQL_USER=wpuser
MYSQL_PASSWORD=your_db_password

WORDPRESS_DB_HOST=mariadb:3306
WORDPRESS_DB_NAME=wordpress
WORDPRESS_DB_USER=wpuser
WORDPRESS_DB_PASSWORD=your_db_password

WORDPRESS_ADMIN_USER=webmaster
WORDPRESS_ADMIN_PASSWORD=your_admin_password
WORDPRESS_ADMIN_EMAIL=admin@tndreka.42.fr

WORDPRESS_USER=tndreka
WORDPRESS_USER_PASSWORD=user_password
WORDPRESS_USER_EMAIL=user@tndreka.42.fr

WORDPRESS_TITLE="Inception Project"
WORDPRESS_URL=https://tndreka.42.fr
ENVEOF

# Configure domain
sudo bash -c 'echo "127.0.0.1 tndreka.42.fr" >> /etc/hosts'


## Building and Launching

### Using Makefile
bash
# Build images
make build

# Start services
make up

# Or do both
make all


### Manual Commands
bash
# Build
docker compose -f srcs/docker-compose.yml build

# Start
docker compose -f srcs/docker-compose.yml up -d

# Stop
docker compose -f srcs/docker-compose.yml down


## Managing Containers

### View Running Containers
bash
docker ps
docker compose -f srcs/docker-compose.yml ps


### Execute Commands in Containers
bash
# Access MariaDB
docker exec -it mariadb mysql -u root -p

# Access WordPress container
docker exec -it wordpress bash

# Run WP-CLI commands
docker exec wordpress wp --info --allow-root


### View Logs
bash
# All containers
docker compose -f srcs/docker-compose.yml logs -f

# Specific service
docker logs nginx
docker logs wordpress
docker logs mariadb


### Restart Containers
bash
# Restart all
make restart

# Restart specific service
docker compose -f srcs/docker-compose.yml restart wordpress


## Managing Volumes

### List Volumes
bash
docker volume ls


### Inspect Volume
bash
docker volume inspect srcs_mariadb_data
docker volume inspect srcs_wordpress_data


### Data Location

Volumes are bind-mounted to:
- **MariaDB**: `/home/tndreka/data/mariadb`
- **WordPress**: `/home/tndreka/data/wordpress`

### Access Data Directly
bash
# List database files
ls -la /home/tndreka/data/mariadb/

# List WordPress files
ls -la /home/tndreka/data/wordpress/


### Backup Volumes
bash
# Backup database
docker exec mariadb mysqldump -u root -p wordpress > backup.sql

# Backup WordPress
tar -czf wordpress_backup.tar.gz /home/tndreka/data/wordpress/


## Data Persistence

### Where Data is Stored

1. **MariaDB Data**:
   - Host: `/home/tndreka/data/mariadb`
   - Container: `/var/lib/mysql`

2. **WordPress Files**:
   - Host: `/home/tndreka/data/wordpress`
   - Container: `/var/www/html`

### How Data Persists

- **Docker volumes** use bind mounts to host filesystem
- Data survives container restarts
- Data survives `make down`
- Data is deleted only with `make fclean`

### Testing Persistence
bash
# Stop containers
make down

# Verify data still exists
ls /home/tndreka/data/mariadb/
ls /home/tndreka/data/wordpress/

# Restart
make up

# Website should load with same content


## Network Architecture

### Network Configuration

- **Type**: Bridge network
- **Name**: `inception_network`
- **Driver**: bridge

### Service Communication

NGINX (443) → WordPress (9000) → MariaDB (3306)
   ↓
Internet


- **NGINX**: Only exposed port (443)
- **WordPress**: Internal communication via network
- **MariaDB**: Fully isolated, no external access

### DNS Resolution

Containers resolve each other by service name:
- `nginx` → `wordpress:9000`
- `wordpress` → `mariadb:3306`

### Inspect Network
bash
docker network inspect srcs_inception_network


## Project Structure

inception/
├── Makefile                    # Build automation
├── README.md                   # Project overview
├── USER_DOC.md                 # User guide
├── DEV_DOC.md                  # This file
├── .gitignore                  # Git ignore rules
└── srcs/
    ├── .env                    # Environment variables (not in git!)
    ├── docker-compose.yml      # Service orchestration
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile      # MariaDB image
        │   ├── conf/
        │   │   └── 50-server.cnf
        │   └── tools/
        │       └── init_db.sh  # DB initialization
        ├── wordpress/
        │   ├── Dockerfile      # WordPress image
        │   └── tools/
        │       └── setup_wordpress.sh
        └── nginx/
            ├── Dockerfile      # NGINX image
            └── conf/
                ├── nginx.conf
                └── default.conf


## Debugging Tips

### Container Won't Start
bash
# Check logs
docker logs <container_name>

# Check build output
docker compose -f srcs/docker-compose.yml build --no-cache

# Verify Dockerfile syntax
docker compose -f srcs/docker-compose.yml config


### Permission Issues
bash
# Fix data directory permissions
sudo chown -R $USER:$USER /home/$USER/data

# Fix volume permissions inside container
docker exec <container> chown -R www-data:www-data /var/www/html


### Network Issues
bash
# Verify network exists
docker network ls

# Recreate network
docker network rm srcs_inception_network
docker compose -f srcs/docker-compose.yml up -d


## Development Workflow

1. **Make changes** to Dockerfiles or configs
2. **Rebuild** affected service:
bash
   docker compose -f srcs/docker-compose.yml build <service>

3. **Restart** service:
bash
   docker compose -f srcs/docker-compose.yml up -d <service>

4. **Test** changes
5. **Commit** to git (never commit `.env`!)

## Clean Up
bash
# Remove containers only
make down

# Remove containers + images
make clean

# Full cleanup (deletes data!)
make fclean
