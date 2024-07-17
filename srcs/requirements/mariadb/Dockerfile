# mariadb
FROM debian:bullseye-slim

RUN apt update && apt upgrade -y && apt install mariadb-server -y 

COPY ./conf/script.sh .
RUN chmod 777 ./script.sh

EXPOSE 3306

CMD ["./script.sh"]