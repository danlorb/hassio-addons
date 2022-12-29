#!/command/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Gucamole
# This file init the tomcat Server
# ==============================================================================

bashio::log.level "$(bashio::config 'log_level' 'warning')"

configdir="/config/addons_config/guacamole"

bashio::log.info 'Create known_hosts Skeleton'
mkdir -p /root/.config/freerdp/known_hosts

if [ ! -f "${configdir}"/guacamole.properties ]; then
    mkdir -p "${configdir}"
    cp -rn /app/guacamole/* "${configdir}"
fi

bashio::log.info 'Copy Log config to tomcat'
cp -f "${configdir}"/logging.properties /opt/tomcat/conf
