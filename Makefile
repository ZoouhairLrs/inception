DB_VOLUME_DIR := home/zlaarous/data/db_volume
WP_VOLUME_DIR := home/zlaarous/data/wp_volume
AD_VOLUME_DIR := home/zlaarous/data/ad_volume

.PHONY: all cp down stop fclean re

all:
	@sudo mkdir -p $(DB_VOLUME_DIR) $(WP_VOLUME_DIR) $(AD_VOLUME_DIR)
	@docker compose -f srcs/docker-compose.yaml up --build

cp:
	@docker cp webserver:/etc/ssl/nginx/inception.crt ~/ || true

down:
	@docker compose -f srcs/docker-compose.yaml down || true

stop:
	@docker stop $(shell docker ps -q) 2>/dev/null || true
	@docker rm $(shell docker ps -a -q) 2>/dev/null || true

fclean: down
	@docker stop $$(docker ps -qa) 2>/dev/null || true
	@docker rm $$(docker ps -qa) 2>/dev/null || true
	@docker rmi -f $$(docker images -qa) 2>/dev/null || true
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	@docker network rm $$(docker network ls -q) 2>/dev/null || true
	@docker system prune -af || true
	@sudo rm -rf $(DB_VOLUME_DIR) $(WP_VOLUME_DIR) || true

re: down all