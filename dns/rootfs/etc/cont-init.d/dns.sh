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

# Set some Environment Variables if available
bashio::config.has_value 'DNS_SERVER_DOMAIN' && export DNS_SERVER_DOMAIN=$(bashio::config 'DNS_SERVER_DOMAIN') && bashio::log.info 'Domain set'
bashio::config.has_value 'DNS_SERVER_ADMIN_PASSWORD' && export DNS_SERVER_ADMIN_PASSWORD=$(bashio::config 'DNS_SERVER_ADMIN_PASSWORD') && bashio::log.info 'Admin Password set'
bashio::config.has_value 'DNS_SERVER_PREFER_IPV6' && export DNS_SERVER_PREFER_IPV6=$(bashio::config 'DNS_SERVER_PREFER_IPV6') && bashio::log.info 'Prefer IPv6 set'
bashio::config.has_value 'DNS_SERVER_OPTIONAL_PROTOCOL_DNS_OVER_HTTP' && export DNS_SERVER_OPTIONAL_PROTOCOL_DNS_OVER_HTTP=$(bashio::config 'DNS_SERVER_OPTIONAL_PROTOCOL_DNS_OVER_HTTP') && bashio::log.info 'Dns over Http set'
bashio::config.has_value 'DNS_SERVER_RECURSION' && export DNS_SERVER_RECURSION=$(bashio::config 'DNS_SERVER_RECURSION') && bashio::log.info 'Recursion set'
bashio::config.has_value 'DNS_SERVER_RECURSION_DENIED_NETWORKS' && export DNS_SERVER_RECURSION_DENIED_NETWORKS=$(bashio::config 'DNS_SERVER_RECURSION_DENIED_NETWORKS') && bashio::log.info 'Recursion denied Networks set'
bashio::config.has_value 'DNS_SERVER_RECURSION_ALLOWED_NETWORKS' && export DNS_SERVER_RECURSION_ALLOWED_NETWORKS=$(bashio::config 'DNS_SERVER_RECURSION_ALLOWED_NETWORKS') && bashio::log.info 'Recursion allowed Networks set'
bashio::config.has_value 'DNS_SERVER_ENABLE_BLOCKING' && export DNS_SERVER_ENABLE_BLOCKING=$(bashio::config 'DNS_SERVER_ENABLE_BLOCKING') && bashio::log.info 'Blocking set'
bashio::config.has_value 'DNS_SERVER_ALLOW_TXT_BLOCKING_REPORT' && export DNS_SERVER_ALLOW_TXT_BLOCKING_REPORT=$(bashio::config 'DNS_SERVER_ALLOW_TXT_BLOCKING_REPORT') && bashio::log.info 'Text Blocking set'
bashio::config.has_value 'DNS_SERVER_BLOCK_LIST_URLS' && export DNS_SERVER_BLOCK_LIST_URLS=$(bashio::config 'DNS_SERVER_BLOCK_LIST_URLS') && bashio::log.info 'Blocking List set'
bashio::config.has_value 'DNS_SERVER_FORWARDERS' && export DNS_SERVER_FORWARDERS=$(bashio::config 'DNS_SERVER_FORWARDERS') && bashio::log.info 'Forwarders set'
bashio::config.has_value 'DNS_SERVER_FORWARDER_PROTOCOL' && export DNS_SERVER_FORWARDER_PROTOCOL=$(bashio::config 'DNS_SERVER_FORWARDER_PROTOCOL') && bashio::log.info 'Forwareder Protocol set'
bashio::config.has_value 'DNS_SERVER_LOG_USING_LOCAL_TIME' && export DNS_SERVER_LOG_USING_LOCAL_TIME=$(bashio::config 'DNS_SERVER_LOG_USING_LOCAL_TIME') && bashio::log.info 'Local Time set'
