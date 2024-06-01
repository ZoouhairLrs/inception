# mariadb
FROM debian:bullseye-slim
LABEL authors="zlaarous"

# RUN set -x
# RUN apt-get update && apt-get install -y --no-install-recommends --no-install-suggests mariadb-server=1:10.5.21-0+deb11u1
# RUN apt-get remove --purge --auto-remove -y
# RUN apt-get clean && rm -rf /var/lib/apt/lists/*
RUN apt install mariadb-server

COPY source/scripting.sh /usr/local/bin/setup.sh

ENTRYPOINT ["bash", "/usr/local/bin/setup.sh"]

CMD ["tail -f /dev/null"]