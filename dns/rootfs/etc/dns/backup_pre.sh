#!/command/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Node-RED
# Configures Node-RED before running
# ==============================================================================

# Ensure configuration exists
if bashio::fs.directory_exists '/backup'; then
    mkdir -p /backup/addons/dns \
        || bashio::exit.nok "Failed to create Dns/Dhcp backup directory"

    cp -r /config/addons/dns/* backup/addons/dns/
fi
