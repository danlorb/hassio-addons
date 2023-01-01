#!/command/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Matrix
# This file init Matrix
# ==============================================================================

loglevel=$(bashio::config 'log_level' 'warning')
bashio::log.level "$loglevel"

config="/config/addons_config/matrix"
servername=$(bashio::config 'server_name' 'example.org')
reportstats="no"
if bashio::config.true 'report_stats'; then
    reportstats="yes"
fi

if [ ! -f "$config"/homeserver.yaml ]; then
    bashio::log.info "Create Matrix Service Configuration..."
    mkdir -p "${config}"

    /opt/venvs/matrix-synapse/bin/synapse_homeserver \
        --generate-config \
        -H "$servername" \
        -c "$config"/homeserver.yaml \
        --data-directory /share/matrix \
        --report-stats="$reportstats" \
        --open-private-ports

    if [ "$loglevel" == "trace" ]; then
        loglevel="debug"
    fi

    if [ "$loglevel" == "notice" ]; then
        loglevel="info"
    fi

    if [ "$loglevel" == "fatal" ]; then
        loglevel="critical"
    fi

    loglevelUpper=$(bashio::string.upper "$loglevel")
    cat > "$config"/"$servername".log.config <<EOF
version: 1

formatters:
    precise:
        format: '%(asctime)s - %(name)s - %(lineno)d - %(levelname)s - %(request)s - %(message)s'

handlers:
    console:
        class: logging.StreamHandler
        formatter: precise

loggers:
    synapse.storage.SQL:
        # beware: increasing this to DEBUG will make synapse log sensitive
        # information such as access tokens.
        level: WARNING

root:
    level: $loglevelUpper
    handlers: [console]

disable_existing_loggers: true

EOF
fi
