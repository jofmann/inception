DB_VOLUME_PATH=/home/$(USER)/data/db
WP_VOLUME_PATH=/home/$(USER)/data/wordpress
COMPOSE_FILE=srcs/docker-compose.yml

all: up

build:
	mkdir -p $(DB_VOLUME_PATH)
	mkdir -p $(WP_VOLUME_PATH)
	docker compose -f $(COMPOSE_FILE) build

secrets:
	@if [ ! -d secrets ]; then \
		mkdir -p secrets; \
		openssl rand -base64 16 > secrets/mysql_user_pw.txt; \
		openssl rand -base64 16 > secrets/mysql_root_pw.txt; \
		openssl rand -base64 16 > secrets/wp_admin_pw.txt; \
		openssl rand -base64 16 > secrets/wp_user_pw.txt; \
		openssl rand -base64 16 > secrets/ftp_password.txt; \
		openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
			-keyout secrets/inception.key \
			-out secrets/inception.crt \
			-subj "/CN=$(USER).42.fr"; \
	fi

up: secrets
	mkdir -p $(DB_VOLUME_PATH)
	mkdir -p $(WP_VOLUME_PATH)
	docker compose -f $(COMPOSE_FILE) up -d

down:
	docker compose -f $(COMPOSE_FILE) down

stop:
	docker compose -f $(COMPOSE_FILE) stop


clean: down
	sudo rm -rf $(DB_VOLUME_PATH)/*
	sudo rm -rf $(WP_VOLUME_PATH)/*

fclean: clean
	docker compose -f $(COMPOSE_FILE) down --rmi all --volumes
	docker system prune -af

re: fclean all

.PHONY: all build up down stop clean fclean re secrets
