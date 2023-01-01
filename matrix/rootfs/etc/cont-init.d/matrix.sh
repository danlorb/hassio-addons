#!/command/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Matrix
# This file init Matrix
# ==============================================================================

bashio::log.level "$(bashio::config 'log_level' 'warning')"

config="/config/addons_config/matrix"
servername=$(bashio::config 'server_name')
reportstats="no"
if bashio::config.true 'report_stats'; then
    reportstats="yes"
fi

if [ ! -f "$config"/homeserver.yaml ]; then
    mkdir -p "${config}"

    /opt/venvs/matrix-synapse/bin/synapse_homeserver \
        --generate-config \
        -H "$servername" \
        -c "$config"/homeserver.yaml \
        --data-directory /media/matrix \
        --report-stats="$reportstats" \
        --open-private-ports
fi
