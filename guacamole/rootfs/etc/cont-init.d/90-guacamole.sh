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

    sed -i "s|# mysql-hostname: localhost|mysql-hostname: localhost|g" "${configdir}"/guacamole.properties
    sed -i "s|# mysql-database: guacamole|mysql-database: guacamole|g" "${configdir}"/guacamole.properties
    sed -i "s|# mysql-username: guacamole|mysql-username: guacamole|g" "${configdir}"/guacamole.properties
    sed -i "s|# mysql-password: null|mysql-password: ${app_password}|g" "${configdir}"/guacamole.properties
else
    sed -i "s|mysql-hostname: localhost|# mysql-hostname: localhost|g" "${configdir}"/guacamole.properties
    sed -i "s|mysql-database: guacamole|# mysql-database: guacamole|g" "${configdir}"/guacamole.properties
    sed -i "s|mysql-username: guacamole|# mysql-username: guacamole|g" "${configdir}"/guacamole.properties
    sed -i "s|mysql-password: ${app_password}|# mysql-password: null|g" "${configdir}"/guacamole.properties
fi

bashio::log.info 'Copy Log config to tomcat'
cp -f "${configdir}"/logging.properties /opt/tomcat/conf
