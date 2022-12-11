#!/command/with-contenv bashio

# DynDNS Script for Hetzner DNS API
# Origin Script from by FarrowStrange v1.2 (see https://github.com/FarrowStrange/hetzner-api-dyndns)

# get OS environment variables
auth_api_token=${HETZNER_AUTH_API_TOKEN:-''}
zone_name=${HETZNER_ZONE_NAME:-''}
record_name=${HETZNER_RECORD_NAME:-''}
record_ttl=${HETZNER_RECORD_TTL:-'60'}
record_type=${HETZNER_RECORD_TYPE:-'A'}
zone_id=
record_id=

headerContentType="Content-Type: application/json"
headerAuth="Auth-API-Token: ${auth_api_token}"

display_help() {
    local message=cat <<EOF

exec: ./dyndns.sh -Z <Zone Name> -n <Record Name>

parameters:
  -Z  - Zone name
  -n  - Record name

optional parameters:
  -t  - TTL (Default: 60)
  -T  - Record type (Default: A)

help:
  -h  - Show Help

requirements:
curl, dig and jq are required to run this script.

example:
  .exec: ./dyndns.sh -z 98jFjsd8dh1GHasdf7a8hJG7 -r AHD82h347fGAF1 -n dyn
  .exec: ./dyndns.sh -Z example.com -n dyn -T AAAA

EOF
    bashio::exit.nok "$message"
}

bashio::log.trace "Set LogLevel"
bashio::log.level "$(bashio::config 'log_level' 'warning')"

while getopts ":z:Z:r:n:t:T:h" opt; do
    case "$opt" in
    Z) zone_name="${OPTARG}" ;;
    n) record_name="${OPTARG}" ;;
    t) record_ttl="${OPTARG}" ;;
    T) record_type="${OPTARG}" ;;
    h) display_help ;;
    \?) bashio::exit.nok "Invalid option: -${OPTARG}. Leaving DynDns Updater" ;;
    :) bashio::exit.nok "Missing option argument for -${OPTARG}. Leaving DynDns Updater" ;;
    *) bashio::exit.nok "Unimplemented option: -${OPTARG}. Leaving DynDns Updater" ;;
    esac
done

bashio::log.trace "Check if api token is set"
if [[ "${auth_api_token}" = "" ]]; then
    bashio::log.fatal "No API Token specified."
    bashio::exit.nok "Leaving DynDns Updater"
fi

bashio::log.trace "Get all zones"
zone_info=$(curl -s -k --location "https://dns.hetzner.com/api/v1/zones" --header "${headerAuth}")
if bashio::jq.exists "${zone_info}" ".message"; then
    message=$(bashio::jq "${zone_info}" ".message")

    if [ "${message}" == "Invalid authentication credentials" ]; then
        bashio::log.fatal "Wrong API Token specified."
        bashio::exit.nok "Leaving DynDns Updater"
    else
        bashio::log.fatal "${message}"
        bashio::exit.nok "Leaving DynDns Updater"
    fi
fi

bashio::log.trace "Validate Zone Name"
if [ "${zone_name}" == "" ]; then
    bashio::log.fatal "Mission option for zone name: -Z <Zone Name>"
    bashio::log.fatal "Use -h to display help."
    bashio::exit.nok "Leaving DynDns Updater"
fi

bashio::log.trace "Validate Record Name"
if [ "${record_name}" == "" ]; then
    bashio::log.fatal "Mission option for record name: -n <Record Name>"
    bashio::log.fatal "Use -h to display help."
    bashio::exit.nok "Leaving DynDns Updater"
fi

bashio::log.trace "Get zone_id if zone_name is given and in zones"
zone_id=$(bashio::jq "${zone_info}" '.zones[] | select(.name=="'"${zone_name}"'") | .id')

bashio::log.trace "Zone_ID: ${zone_id}"
bashio::log.trace "Zone_Name: ${zone_name}"

bashio::log.trace "Get current public ip address"
ipPrefix="IPv4"
cloudflareResult=
if [ "${record_type}" = "AAAA" ]; then
    bashio::log.trace "Using IPv6, because AAAA was set as record type."
    ipPrefix="IPv6"
    cloudflareResult=$(dig -6 ch TXT +short +time=1 +tries=1 whoami.cloudflare @2606:4700:4700::1111 || true)
elif [ "${record_type}" = "A" ]; then
    bashio::log.trace "Using IPv4, because A was set as record type."
    cloudflareResult=$(dig -4 ch TXT +short +time=1 +tries=1 whoami.cloudflare @1.1.1.1 || true)
else
    bashio::log.error "Only record type \"A\" or \"AAAA\" are support for DynDNS."
    bashio::log.info "Leaving DynDns Updater"
fi

cur_pub_addr=
if [ "${cloudflareResult}" != "" ]; then
    timedOut=$(echo "${cloudflareResult}" | grep -i "connection timed out" || true)
    if [ "${timedOut}" == "" ]; then
        cur_pub_addr=$(echo "${cloudflareResult}" | awk -F '"' '{print $2}')
        if [ "${cur_pub_addr}" = "" ]; then
            bashio::log.warning "It seems you don't have a Public ${ipPrefix} address."
            bashio::log.info "Leaving DynDns Updater"
        else
            bashio::log.info "Current public ${ipPrefix} address: ${cur_pub_addr}"
        fi
    else
        bashio::log.warning "It seems you don't have a Public ${ipPrefix} address."
        bashio::log.info "Leaving DynDns Updater"
    fi
else
    bashio::log.warning "It seems you don't have a Public ${ipPrefix} address."
    bashio::log.info "Leaving DynDns Updater"
fi

if [ "${cur_pub_addr}" != "" ]; then

    bashio::log.trace "Get record id if not given as parameter"
    record_zone=$(curl -s -k --location --request GET "https://dns.hetzner.com/api/v1/records?zone_id=${zone_id}" --header "${headerAuth}")
    record_id=$(bashio::jq "${record_zone}" '.records[] | select(.type == "'"${record_type}"'") | select(.name == "'"${record_name}"'") | .id')
    bashio::log.trace "Record_ID: ${record_id}"

    if [[ "${record_id}" = "" ]]; then
        bashio::log.trace "Create a new record"
        bashio::log.info "DNS record \"${record_name}\" does not exists - will be created."
        curl -s -k -X "POST" "https://dns.hetzner.com/api/v1/records" --header "${headerContentType}" --header "${headerAuth}" --data "$(
            cat <<EOF
{
    "value": "${cur_pub_addr}",
    "ttl": ${record_ttl},
    "type": "${record_type}",
    "name": "${record_name}",
    "zone_id": "${zone_id}"
}
EOF
        )"
    else
        bashio::log.trace "Check if update is needed"
        cur_record=$(curl -k -s "https://dns.hetzner.com/api/v1/records/${record_id}" --header "${headerAuth}")
        cur_dyn_addr=$(bashio::jq "${cur_record}" ".record.value")

        bashio::log.info "Currently set IP address: ${cur_dyn_addr}"
        bashio::log.trace "update existing record"
        if [ "$cur_pub_addr" == "$cur_dyn_addr" ]; then
            bashio::log.info "DNS record \"${record_name}\" is up to date - nothing to to."
        else
            bashio::log.info "DNS record \"${record_name}\" is no longer valid - updating record"

            curl -k -s -X "PUT" "https://dns.hetzner.com/api/v1/records/${record_id}" --header "${headerContentType}" --header "${headerAuth}" --data "$(
                cat <<EOF
{
    "value": "${cur_pub_addr}",
    "ttl": ${record_ttl},
    "type": "${record_type}",
    "name": "${record_name}",
    "zone_id": "${zone_id}"
}
EOF
            )"
        fi
    fi
fi

if [ $? != 0 ]; then
    bashio::log.fatal "Unable to update record: \"${record_name}\""
    bashio::exit.nok "Leaving DynDns Updater"
else
    bashio::exit.ok "Leaving DynDns Updater"
fi
