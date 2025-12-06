COMPOSE_FILE = ./srcs/docker-compose.yml

DATA_PATH = /home/$(USER)/data 

#colors
GREEN = \033[0;32m

RED = \033[0;31m

NC = \033[0m


all: build up

setup:
	@echo "$(GREEN) Creating data directories. . . $(NC)"
	@mkdir -p $(DATA_PATH)/wordpress
	@mkdir -p $(DATA_PATH)/mariadb
	@echo "$(GREEN) Data directories created. . . $(NC)"

#build images
build: setup
	@echo "$(GREEN) Building Docker images. . . $(NC)"
	@docker-compose -f $(COMPOSE_FILE) build
	@echo "$(GREEN) Build complete. . . $(NC)"

#start container
up: setup
	@echo "$(GREEN) starting containers. . . $(NC)"
	@docker-compose -f $(COMPOSE_FILE) up -d
	@echo "$(GREEN) containers are running. . . $(NC)"

#Stop container
down:
	@echo "$(GREEN) Stopping containers. . . $(NC)"
	@docker-compose -f $(COMPOSE_FILE) up -d
	@echo "$(GREEN) containers stopped. . . $(NC)"

restart: up down

status:
	@docker-compose -f $(COMPOSE_FILE) ps

logs:
	@docker-compose -f $(COMPOSE_FILE) logs -f 

clean: down
