# Stage 1: Certifier
FROM debian:bullseye-slim as certifier
LABEL authors="zlaarous"

WORKDIR /etc/ssl/nginx

# Install OpenSSL and create a self-signed certificate
RUN set -x && \
    apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests openssl=1.1.1w-0+deb11u1 && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout inception.key \
        -out inception.crt \
        -subj "/CN=inception"

# Stage 2: Main image
FROM debian:bullseye-slim

# Install necessary packages with specific versions
RUN set -x && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates=20210119 \
    openssl=1.1.1w-0+deb11u1 \
    nginx=1.18.0-6.1+deb11u3 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create SSL directory and copy certificates from the certifier stage
RUN mkdir -p /etc/ssl/nginx
COPY --from=certifier /etc/ssl/nginx/inception.crt /etc/ssl/nginx
COPY --from=certifier /etc/ssl/nginx/inception.key /etc/ssl/nginx

RUN rm /etc/nginx/nginx.conf
# Copy Nginx configuration file (ensure you have this file in your build context)
COPY ./config/nginx.conf /etc/nginx/
RUN chmod -R 777 /var/www/html
# Redirect logs to stdout and stderr
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
