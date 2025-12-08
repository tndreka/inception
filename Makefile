COMPOSE_FILE = ./srcs/docker-compose.yml

DATA_PATH = /home/tndreka/data

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
	@docker compose -f $(COMPOSE_FILE) build
	@echo "$(GREEN) Build complete. . . $(NC)"

#start container
up:
	@echo "$(GREEN) starting containers. . . $(NC)"
	@docker compose -f $(COMPOSE_FILE) up -d
	@echo "$(GREEN) containers are running. . . $(NC)"

#Stop container
down:
	@echo "$(GREEN) Stopping containers. . . $(NC)"
	@docker compose -f $(COMPOSE_FILE) down
	@echo "$(GREEN) containers stopped. . . $(NC)"

restart: down up

status:
	@docker compose -f $(COMPOSE_FILE) ps

logs:
	@docker compose -f $(COMPOSE_FILE) logs -f

clean: down
	@echo "$(RED)Cleaning containers & images$(NC)"
	@docker system prune -af > /dev/null 2>&1
	@echo "$(RED)Cleanup complete$(NC)"


fclean: clean
	@echo "$(RED)Removing volumes and data$(NC)"
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	@if [ -d "$(DATA_PATH)/wordpress" ]; then \
		docker run --rm -v $(DATA_PATH):/data alpine sh -c "rm -rf /data/wordpress/*" 2>/dev/null || true; \
		rm -rf $(DATA_PATH)/wordpress 2>/dev/null || true; \
	fi
	@if [ -d "$(DATA_PATH)/mariadb" ]; then \
		docker run --rm -v $(DATA_PATH):/data alpine sh -c "rm -rf /data/mariadb/*" 2>/dev/null || true; \
		rm -rf $(DATA_PATH)/mariadb 2>/dev/null || true; \
	fi
	@echo "$(RED)Full cleanup complete$(NC)"


re: fclean all

.PHONY: all setup build up down restart logs clean fclean re status