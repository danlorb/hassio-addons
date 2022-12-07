ARG BUILD_FROM
FROM $BUILD_FROM

WORKDIR /tmp

RUN wget https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -qy --no-install-recommends \
        aspnetcore-runtime-7.0 \
    && apt-get purge -y --auto-remove \
        build-essential \
        git \
        libssl-dev \
        golang-go \
    && apt-get clean \
    && rm -fr \
        /etc/logrotate.d \
        /etc/nginx/* \
        /usr/share/nginx \
        /var/lib/nginx/html \
        /var/www \
        /var/lib/apt/lists/* \
	    /root/.cache \
	    /root/go

RUN wget https://download.technitium.com/dns/DnsServerPortable.tar.gz \
    && mkdir -p /etc/dns/ \
    && tar -zxf DnsServerPortable.tar.gz -C /etc/dns/

# Copy rootfs
COPY rootfs /

WORKDIR /
