ARG BUILD_FROM
ARG BUILD_VERSION
FROM ${BUILD_FROM}:${BUILD_VERSION}

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

LABEL \
  io.hass.version="2022.12.0" \
  io.hass.type="addon" \
  io.hass.arch="amd64"
