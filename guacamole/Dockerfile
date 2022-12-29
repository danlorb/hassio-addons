ARG BUILD_FROM
ARG BUILD_VERSION
FROM ${BUILD_FROM}

# Set some Environment Variables
ENV \
    DEBIAN_FRONTEND=noninteractive \
    S6_CMD_WAIT_FOR_SERVICES=1 \
    S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0 \
    S6_SERVICES_GRACETIME=0 \
    GUAC_VER=1.4.0 \
    GUACAMOLE_HOME=/app/guacamole \
    JAVA_OPTS="-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom" \
    CATALINA_VER=8.5.84 \
    CATALINA_HOME=/opt/tomcat \
    CATALINA_PID=/opt/tomcat/temp/tomcat.pid \
    CATALINA_OPTS="-Xms512M -Xmx1024M -server -XX:+UseParallelGC"

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Copy root filesystem
COPY rootfs /

# Corrects permissions for s6
RUN if [ -d /etc/cont-init.d ]; then chmod -R 755 /etc/cont-init.d; fi && \
    if [ -d /etc/services.d ]; then chmod -R 755 /etc/services.d; fi

RUN apt-get update \
    && apt-get install -qy --no-install-recommends \
        build-essential \
        openjdk-11-jdk \
        libcairo2-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libtool-bin \
        uuid-dev \
        libossp-uuid-dev \
        ffmpeg \
        libavcodec-dev \
        libavformat-dev \
        libavutil-dev \
        freerdp2-dev \
        libpango1.0-dev \
        libssh2-1-dev \
        libvncserver-dev \
        libwebsockets-dev \
        libpulse-dev \
        libssl-dev \
        libvorbis-dev \
        libwebp-dev \
        libswscale-dev \
        fonts-agave \
        fonts-arundina \
        fonts-averia* \
        fonts-cascadia-code \
        fonts-fantasque-sans \
        fonts-firacode \
        fonts-freefont* \
        fonts-hack* \
        fonts-hermit \
        fonts-inconsolata \
        fonts-league-mono \
        fonts-lmodern \
        fonts-open-sans \
        fonts-spleen \
        fonts-terminus* \
        fonty-rg \
        curl \
        ghostscript \
        mariadb-client

# Set Workdir
WORKDIR /tmp

# Download all needed Files
RUN echo -e "\n\
#!/bin/bash\n\
curl -SL https://dlcdn.apache.org/tomcat/tomcat-8/v${CATALINA_VER}/bin/apache-tomcat-${CATALINA_VER}.tar.gz -o apache-tomcat-${CATALINA_VER}.tar.gz\n\
curl -SL https://apache.org/dyn/closer.lua/guacamole/${GUAC_VER}/source/guacamole-server-${GUAC_VER}.tar.gz?action=download -o guacamole-server-${GUAC_VER}.tar.gz\n\
curl -SL https://apache.org/dyn/closer.lua/guacamole/${GUAC_VER}/binary/guacamole-${GUAC_VER}.war?action=download -o guacamole-${GUAC_VER}.war\n\
curl -SL https://apache.org/dyn/closer.lua/guacamole/${GUAC_VER}/binary/guacamole-auth-jdbc-${GUAC_VER}.tar.gz?action=download -o guacamole-auth-jdbc-${GUAC_VER}.tar.gz\n\
curl -SL https://apache.org/dyn/closer.lua/guacamole/${GUAC_VER}/binary/guacamole-auth-totp-${GUAC_VER}.tar.gz?action=download -o guacamole-auth-totp-${GUAC_VER}.tar.gz\n\
curl -SL https://apache.org/dyn/closer.lua/guacamole/${GUAC_VER}/binary/guacamole-${GUAC_VER}.war?action=download -o guacamole-${GUAC_VER}.war\n\
curl -SL https://dlm.mariadb.com/2678616/Connectors/java/connector-java-3.1.0/mariadb-java-client-3.1.0.jar -o mariadb-java-client-3.1.0.jar \n\
curl -SL https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-j_8.0.31-1debian11_all.deb -o mysql-connector-j_8.0.31-1debian11_all.deb\n\
" > /tmp/download.sh \
    && chmod +x /tmp/download.sh \
    && /tmp/download.sh

# Install Tomcat
RUN mkdir -p ${CATALINA_HOME} \
    && tar -xzf /tmp/apache-tomcat-${CATALINA_VER}.tar.gz -C ${CATALINA_HOME} --strip-components=1 \
    && chmod +x ${CATALINA_HOME}/bin/*.sh \
    && rm -rf ${CATALINA_HOME}/webapps/*

# Install guacamole-server
RUN tar -xzf /tmp/guacamole-server-${GUAC_VER}.tar.gz \
    && cd guacamole-server-${GUAC_VER} \
    && ./configure \
    && make -j$(getconf _NPROCESSORS_ONLN) \
    && make install \
    && cd .. \
    && ldconfig

# Install guacamole-client and postgres auth adapter
RUN mkdir -p ${GUACAMOLE_HOME}/extensions \
    && mkdir -p ${GUACAMOLE_HOME}/extensions-available \
    && mkdir -p ${GUACAMOLE_HOME}/lib \
    && cp -f /tmp/guacamole-${GUAC_VER}.war ${CATALINA_HOME}/webapps/ROOT.war \
    && dpkg -i /tmp/mysql-connector-j_8.0.31-1debian11_all.deb \
    && cp /usr/share/java/mysql-connector-j-8.0.31.jar ${GUACAMOLE_HOME}/lib \
    && cp /tmp/mariadb-java-client-3.1.0.jar ${GUACAMOLE_HOME}/lib \
    && tar -xzf /tmp/guacamole-auth-totp-${GUAC_VER}.tar.gz \
    && cp -R guacamole-auth-totp-${GUAC_VER}/guacamole-auth-totp-${GUAC_VER}.jar ${GUACAMOLE_HOME}/extensions-available/ \
    && tar -xzf /tmp/guacamole-auth-jdbc-${GUAC_VER}.tar.gz \
    && cp -R guacamole-auth-jdbc-${GUAC_VER}/mysql/guacamole-auth-jdbc-mysql-${GUAC_VER}.jar ${GUACAMOLE_HOME}/extensions-available/ \
    && cp -R guacamole-auth-jdbc-${GUAC_VER}/mysql/schema ${GUACAMOLE_HOME}/

RUN apt-get purge -y --auto-remove \
        build-essential \
    && apt-get clean \
    && rm -rf \
        /etc/logrotate.d \
        /var/lib/apt/lists/* \
        /root/.cache
        # /tmp/apache* \
        # /tmp/guacamole* \
        # /tmp/mysql* \
        # /tmp/mariadb*

ENV GUACAMOLE_HOME=/config/addons_config/guacamole
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
    org.opencontainers.image.source="https://github.com/rolbre/hassio-addons/tree/main/dyndns" \
    org.opencontainers.image.documentation="https://github.com/rolbre/hassio-addons/blob/main/dyndns/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
