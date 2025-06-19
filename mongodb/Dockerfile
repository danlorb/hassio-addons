ARG BUILD_FROM
ARG BUILD_VERSION
FROM ${BUILD_FROM:-ghcr.io/home-assistant/amd64-base-ubuntu:20.04}

# Set some Environment Variables
ENV DEBIAN_FRONTEND=noninteractive

# Copy root filesystem
COPY rootfs /

# Corrects permissions for s6
RUN if [ -d /etc/cont-init.d ]; then chmod -R 755 /etc/cont-init.d; fi && \
    if [ -d /etc/s6-overlay/s6-rc.d ]; then chmod -R 755 /etc/s6-overlay/s6-rc.d; fi && \
    if [ -f /entrypoint.sh ]; then chmod 755 /entrypoint.sh; fi

# Set Workdir
WORKDIR /

RUN set -x \
    && apt-get update \
    && apt-get install -qy --no-install-recommends \
        curl \
        gnupg \
        jq \
        libcurl4 \
        liblzma5 \
        numactl \
        openssl \
        procps \
    && curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
        gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor \
    && echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/7.0 multiverse" | \
        tee /etc/apt/sources.list.d/mongodb-org-7.0.list \
    && apt-get update \
    && apt-get install -qy --no-install-recommends mongodb-org \    
    && apt-get purge -y --auto-remove \
    && apt-get clean \
    && rm -rf \
        /etc/logrotate.d \
        /var/lib/apt/lists/* \
        /root/.cache

# ensure that glibc isn't using rseq so that google-tcmalloc can
# https://www.mongodb.com/docs/manual/administration/tcmalloc-performance/#disable-glibc-rseq
ENV GLIBC_TUNABLES=glibc.pthread.rseq=0

# ensure that if running as custom user that "mongosh" has a valid "HOME"
# https://github.com/docker-library/mongo/issues/524
ENV HOME=/data/db

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
    org.opencontainers.image.source="https://github.com/danlorb/hassio-addons/tree/main/mongodb" \
    org.opencontainers.image.documentation="https://github.com/danlorb/hassio-addons/blob/main/mongodb/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
