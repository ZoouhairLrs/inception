FROM debian:bullseye-slim

RUN apt update && apt upgrade -y && \
    apt install curl -y && \
    apt install mariadb-client -y && \
    apt install  php-mysql -y && \
    apt install php-fpm -y

COPY ./conf/setup.sh .

RUN chmod 777 /setup.sh

EXPOSE 9000

CMD ["./script.sh"]