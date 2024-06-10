
all:
	docker compose -f srcs/docker-compose.yaml up

up: 
	docker compose -f srcs/docker-compose.yaml up -d

down: 
	docker compose -f srcs/docker-compose.yaml down

clean: down
	docker volume rm $$(docker volume ls -q)
	docker rmi $$(docker images -a -q)

fclean:
	sudo rm -rf /home/imimouni/data/wp/*
	sudo rm -rf /home/imimouni/data/db/*

prune:
	docker system prune --all --volumes --force

re: down all

nginx:
	docker exec -it nginx bash

mariadb:
	docker exec -it mariadb bash

wordpress:
	docker exec -it wordpress bash
