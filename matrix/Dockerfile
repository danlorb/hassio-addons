ARG BUILD_FROM
ARG BUILD_VERSION
FROM ${BUILD_FROM}

# Set some Environment Variables
ENV \
    DEBIAN_FRONTEND=noninteractive \
    S6_CMD_WAIT_FOR_SERVICES=1 \
    S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0 \
    S6_SERVICES_GRACETIME=0

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Copy root filesystem
COPY rootfs /

# Corrects permissions for s6
RUN if [ -d /etc/cont-init.d ]; then chmod -R 755 /etc/cont-init.d; fi && \
    if [ -d /etc/services.d ]; then chmod -R 755 /etc/services.d; fi

RUN apt-get update \
    && apt-get install -qy --no-install-recommends \
        lsb-release \
        wget \
        apt-transport-https \
        curl \
    && wget -O /usr/share/keyrings/matrix-org-archive-keyring.gpg --progress=dot:giga https://packages.matrix.org/debian/matrix-org-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/matrix-org-archive-keyring.gpg] https://packages.matrix.org/debian/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/matrix-org.list \
    && apt-get update && apt-get install -qy --no-install-recommends matrix-synapse-py3 \
    && apt-get purge -y --auto-remove \
        wget \
    && apt-get clean \
    && rm -rf \
        /etc/logrotate.d \
        /var/lib/apt/lists/* \
        /root/.cache

WORKDIR /

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
    maintainer="rolbre (https://github.com/rolbre)" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Add-ons" \
    org.opencontainers.image.authors="rolbre (https://github.com/rolbre)" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://github.com/rolbre" \
    org.opencontainers.image.source="https://github.com/rolbre/hassio-addons/tree/main/matrix" \
    org.opencontainers.image.documentation="https://github.com/rolbre/hassio-addons/blob/main/matrix/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
