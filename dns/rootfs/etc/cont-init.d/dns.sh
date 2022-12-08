#!/command/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Dns/Dhcp Server
# Configures Dns/Dhcp Server before running
# ==============================================================================

# Ensure configuration exists
if ! bashio::fs.directory_exists '/config/addons'; then
    mkdir -p /config/addons \
        || bashio::exit.nok "Failed to create Dns/Dhcp configuration directory"

    mv /opt/dns/config /config/addons/dns
    ln -s /config/addons/dns /opt/dns/config
fi
