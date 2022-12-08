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
        /var/www \
        /var/lib/apt/lists/* \
        /root/.cache

WORKDIR /

RUN chmod 777 /etc/dns/start.sh
ENTRYPOINT [ "/etc/dns/start.sh" ]

ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="rolbre (https://github.com/rolbre)" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Add-ons" \
    org.opencontainers.image.authors="rolbre (https://github.com/rolbre)" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://github.com/rolbre" \
    org.opencontainers.image.source="https://git.x-breitschaft.de/smarthome/hassio-addons/src/branch/main/technitium" \
    org.opencontainers.image.documentation="https://git.x-breitschaft.de/smarthome/hassio-addons/src/branch/main/technitium/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
