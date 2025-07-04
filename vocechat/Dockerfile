ARG BUILD_FROM
ARG BUILD_VERSION
FROM ${BUILD_FROM}

# Set some Environment Variables
ENV DEBIAN_FRONTEND=noninteractive

# Copy root filesystem
COPY rootfs /

# Corrects permissions for s6
RUN if [ -d /etc/cont-init.d ]; then chmod -R 755 /etc/cont-init.d; fi && \
    if [ -d /etc/s6-overlay/s6-rc.d ]; then chmod -R 755 /etc/s6-overlay/s6-rc.d; fi && \
    if [ -f /entrypoint.sh ]; then chmod 755 /entrypoint.sh; fi

# Set Workdir
WORKDIR /tmp

RUN set -x \
    && apt-get update \
    && apt-get install -qy --no-install-recommends \
        curl \
        gnupg \
        libssl-dev \
        openssl \
        unzip \ 
        wget \  
    && chmod +x /build/build.sh \
    && /build/build.sh \
    && rm -rf /build  \
    && apt-get purge -y --auto-remove \
    && apt-get clean \
    && rm -rf \
        /etc/logrotate.d \
        /var/lib/apt/lists/* \
        /root/.cache

ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="danlorb (https://github.com/danlorb)" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Add-ons" \
    org.opencontainers.image.authors="danlorb (https://github.com/danlorb)" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://github.com/danlorb" \
    org.opencontainers.image.source="https://github.com/danlorb/hassio-addons/tree/main/virola" \
    org.opencontainers.image.documentation="https://github.com/danlorb/hassio-addons/blob/main/virola/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
