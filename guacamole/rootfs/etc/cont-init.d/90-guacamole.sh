#!/command/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Gucamole
# This file init the tomcat Server
# ==============================================================================

configdir="/config/addons_config/guacamole"

bashio::log.level "$(bashio::config 'log_level' 'warning')"

bashio::log.info 'Create known_hosts Skeleton'
mkdir -p /root/.config/freerdp/known_hosts

if [ ! -f "${configdir}"/guacamole.properties ]; then
    mkdir -p "${configdir}"
    cp -rn /app/guacamole/* "${configdir}"
fi

app_password=$(bashio::config 'database_password' 'null')
if bashio::config.true 'use_database'; then
    bashio::log.info 'Configure Database'

    content=$(cat "${configdir}"/guacamole.properties)
    content="${content//# mysql-hostname: localhost/mysql-hostname: localhost}"
    content="${content//# mysql-database: guacamole/mysql-database: guacamole}"
    content="${content//# mysql-username: guacamole/mysql-username: guacamole}"
    content="${content//# mysql-password: null/mysql-password: ${app_password}}"
    echo "$content" > "${configdir}"/guacamole.properties
else
    content=$(cat "${configdir}"/guacamole.properties)
    content="${content//mysql-hostname: localhost/# mysql-hostname: localhost}"
    content="${content//mysql-database: guacamole/# mysql-database: guacamole}"
    content="${content//mysql-username: guacamole/# mysql-username: guacamole}"
    content="${content//mysql-password: ${app_password}/# mysql-password: null}"
    echo "$content" > "${configdir}"/guacamole.properties
fi

bashio::log.info 'Copy Log config to tomcat'
cp -f "${configdir}"/logging.properties /opt/tomcat/conf
