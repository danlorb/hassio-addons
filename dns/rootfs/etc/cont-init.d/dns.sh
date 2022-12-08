#!/command/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Node-RED
# Configures Node-RED before running
# ==============================================================================

# Ensure configuration exists
if ! bashio::fs.directory_exists '/config/addons'; then
    mkdir -p /config/addons \
        || bashio::exit.nok "Failed to create Dns/Dhcp configuration directory"

    ln -s /opt/dns/config /config/addons/dns
fi
