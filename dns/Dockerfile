ARG BUILD_FROM
ARG BUILD_VERSION
FROM ${BUILD_FROM}

# Set some Environment Variables
ENV DEBIAN_FRONTEND noninteractive
ENV S6_CMD_WAIT_FOR_SERVICES 1
ENV S6_CMD_WAIT_FOR_SERVICES_MAXTIME 0
ENV S6_SERVICES_GRACETIME 0

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Copy root filesystem
COPY rootfs /

# Corrects permissions for s6
RUN if [ -d /etc/cont-init.d ]; then chmod -R 755 /etc/cont-init.d; fi && \
    if [ -d /etc/services.d ]; then chmod -R 755 /etc/services.d; fi && \
    if [ -f /entrypoint.sh ]; then chmod 755 /entrypoint.sh; fi

# Set Workdir
WORKDIR /tmp

RUN apt-get update \
    && apt-get install -qy --no-install-recommends \
        wget \
        curl \
    && wget -nv https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -qy --no-install-recommends \
        aspnetcore-runtime-9.0 \
    && wget -nv https://download.technitium.com/dns/DnsServerPortable.tar.gz \
    && mkdir -p /opt/dns \
    && tar -zxf DnsServerPortable.tar.gz -C /opt/dns/ \
    && apt-get purge -y --auto-remove \
        wget \
    && apt-get clean \
    && rm -rf \
        /etc/logrotate.d \
        /var/lib/apt/lists/* \
        /root/.cache \
        /opt/dns/start.* \
        /opt/dns/*.pdb \
        /opt/dns/systemd.service \
    && chown -R root:root /opt/dns

# Health check
HEALTHCHECK --start-period=5m \
    CMD curl --fail http://127.0.0.1:5380 || exit 1

WORKDIR /opt/dns/

EXPOSE 5380/tcp
EXPOSE 53/udp
EXPOSE 53/tcp
EXPOSE 67/udp
EXPOSE 853/tcp
EXPOSE 443/tcp
EXPOSE 80/tcp
EXPOSE 8053/tcp

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
    org.opencontainers.image.source="https://github.com/rolbre/hassio-addons/tree/main/dns" \
    org.opencontainers.image.documentation="https://github.com/rolbre/hassio-addons/blob/main/dns/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
