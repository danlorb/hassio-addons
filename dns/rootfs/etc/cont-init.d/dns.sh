#!/command/with-contenv bashio
# shellcheck disable=SC2155

# ==============================================================================
# Home Assistant Community Add-on: Dns/Dhcp Server
# Configures Dns/Dhcp Server before running
# ==============================================================================

# Ensure configuration exists
if ! bashio::fs.directory_exists '/config/addons/dns'; then
    bashio::log.info "Prepare Configuration for Dns/Dhcp Server ..."

    mkdir -p /config/addons ||
        bashio::exit.nok "Failed to create Dns/Dhcp configuration directory"
fi
