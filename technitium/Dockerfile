ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base-debian:bullseye
FROM technitium/dns-server:latest

RUN apt-get update \
    && apt-get install -qy --no-install-recommends \
    && apt-get purge -y --auto-remove \
        build-essential \
        git \
        libssl-dev \
    && apt-get clean \
    && rm -rf \
        /etc/logrotate.d \
        /etc/nginx/* \
        /usr/share/nginx \
        /var/lib/nginx/html \
        /var/www \
        /var/lib/apt/lists/* \
        /root/.cache \
        /root/go

# Copy rootfs
COPY rootfs /

WORKDIR /
