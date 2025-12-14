*This project has been created as part of the 42 curriculum by tndreka.*

# Inception

## Description

Inception is a system administration project that sets up a small infrastructure using Docker and Docker Compose. The project consists of three services (NGINX, WordPress, and MariaDB) running in separate containers, connected via a Docker network.

### Goal

- Learn Docker containerization
- Understand Docker Compose orchestration
- Set up a complete web infrastructure with TLS encryption
- Practice secure credential management

## Instructions

### Prerequisites

- Docker and Docker Compose installed
- A virtual machine (Debian/Ubuntu recommended)
- At least 4GB RAM and 20GB disk space

### Installation & Execution

1. **Clone the repository:**
bash
   git clone https://github.com/tndreka/inception.git
   cd inception


2. **Create the `.env` file:**
bash
   cp srcs/.env.example srcs/.env
   # Edit srcs/.env with your own values


3. **Create secrets directory and password files:**
bash
   mkdir -p secrets
   echo "your_root_password" > secrets/db_root_password.txt
   echo "your_db_password" > secrets/db_password.txt
   echo "your_admin_password" > secrets/wp_admin_password.txt
   echo "your_user_password" > secrets/wp_user_password.txt


**Note:** The `secrets/` directory is in `.gitignore` and will NOT be committed to git.

4. **Build and start services:**
bash
make all


5. **Access the website:**
   - Open browser: `https://tndreka.42.fr`
   - Accept self-signed SSL certificate
   - Login to WordPress admin: `https://tndreka.42.fr/wp-admin`

### Useful Commands
bash
make build    # Build Docker images
make up       # Start containers
make down     # Stop containers
make restart  # Restart all services
make logs     # View container logs
make status   # Check container status
make clean    # Remove containers and images
make fclean   # Full cleanup including volumes
make re       # Rebuild from scratch


## Resources

### Official Documentation
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [NGINX Documentation](https://nginx.org/en/docs/)
- [WordPress CLI Documentation](https://wp-cli.org/)
- [MariaDB Documentation](https://mariadb.org/documentation/)

### Tutorials
- [Docker Networking Guide](https://docs.docker.com/network/)
- [Docker Volumes Guide](https://docs.docker.com/storage/volumes/)
- [SSL/TLS Certificates with OpenSSL](https://www.digitalocean.com/community/tutorials/openssl-essentials-working-with-ssl-certificates-private-keys-and-csrs)

### AI Usage

AI tools (Claude) were used for:
- **Understanding complex documentation**: Breaking down Docker, Docker Compose, and networking concepts into digestible explanations
- **Error diagnosis**: Analyzing error messages and suggesting potential causes (permission issues, network configuration, volume mounting problems)
- **Best practices guidance**: Learning about Dockerfile optimization, security practices, and proper container entrypoint usage
- **Troubleshooting assistance**: Getting guidance on debugging container startup failures and connection issues
- **Documentation structure**: Understanding how to organize and present technical documentation

**Important notes:**
- No code was directly copy-pasted from AI without understanding
- All Dockerfiles, scripts, and configurations were written and understood by me
- AI was used as a learning tool to understand concepts, not as a code generator
- Every solution was tested, debugged, and adapted to the specific project requirements
- Peer review and collaboration with classmates were essential throughout the project

## Project Description

### Architecture

The project uses Docker Compose to orchestrate three services:

1. **NGINX** (web server)
   - Handles HTTPS requests on port 443
   - TLSv1.2/1.3 only
   - Reverse proxy to WordPress

2. **WordPress** (CMS)
   - PHP-FPM for processing
   - Connects to MariaDB
   - Two users: admin + author

3. **MariaDB** (database)
   - Stores WordPress data
   - Isolated in internal network

### Design Choices

#### Virtual Machines vs Docker

**Virtual Machines:**
- Full OS isolation
- Higher resource usage
- Slower startup times
- Complete hardware virtualization

**Docker (Our Choice):**
- Process-level isolation
- Lightweight and fast
- Share host kernel
- Perfect for microservices architecture
- **Why we chose Docker**: Better resource efficiency, faster deployment, easier to manage multiple services

#### Secrets vs Environment Variables

**Environment Variables (.env file):**
- Simple key-value pairs
- Stored in `.env` file (gitignored)
- Loaded by Docker Compose
- Good for non-critical configuration

**Docker Secrets (Alternative):**
- Encrypted at rest
- Only available to specified services
- More secure for production
- **Our choice**: Using `.env` for simplicity in development; Docker secrets recommended for production

#### Docker Network vs Host Network

**Docker Network (Our Choice):**
- Isolated network for containers
- Service discovery by container name
- Security through isolation
- Custom bridge network

**Host Network:**
- Containers use host's network directly
- No isolation
- Potential port conflicts
- **Why we avoided it**: Less secure, forbidden in project requirements

#### Docker Volumes vs Bind Mounts

**Docker Volumes:**
- Managed by Docker
- Stored in Docker's storage area
- Better performance
- Easier backups

**Bind Mounts (Our Choice):**
- Direct mapping to host filesystem
- Easy to access and inspect
- Required by project: `/home/login/data`
- **Trade-off**: Slightly less portable, but meets project requirements and easier debugging

## License

This project is part of the 42 School curriculum.