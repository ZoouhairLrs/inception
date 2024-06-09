# mariadb
FROM debian:bullseye-slim

RUN apt update && apt upgrade -y && apt install mariadb-server -y 

COPY ./conf/scripting.sh .
RUN chmod 777 ./scripting.sh

EXPOSE 3306

CMD ["./script.sh"]