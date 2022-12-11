# Home Assistant Community Add-on: DynDns Updater

DynDns Updater to update your public IPv4 and IPv6 Addresses in Hetzner DNS Server. It works out-of-the-box with no or minimal configuration. For more information, please see [Hetzner DNS].

## Prerequesites

Before you can start, you need a Hetzner Login, access to [Hetzner DNS] Console and a Hetzner DNS API Token.

## Installation

The installation of this add-on is pretty straightforward and not different in
comparison to installing any other Home Assistant add-on.

1. Click the Home Assistant My button below to open the add-on on your Home
   Assistant instance.

   [![Open this add-on in your Home Assistant instance.][addon-badge]][addon]

1. Click the "Install" button to install the add-on.
1. Set a `api_token` and configure your Domains which should updated
1. Start the "DynDns" add-on.
1. Check the logs of "DynDns" to see if everything went well.

## Configuration

**Note**: _Remember to restart the add-on when the configuration is changed._

Example add-on configuration:

```yaml
api_token:
records:
  - domain: my-domain.com
    name: www
    ttl: 3600
    ipv4: true
    ipv6: true
  - domain: my-domain.com
    name: "*"
    ttl: 3600
interval: 1h
log_level: info
```

**Note**: _This is just an example, don't copy and paste it! Create your own!_

### Option: `log_level`

The `log_level` option controls the level of log output by the addon and can
be changed to be more or less verbose, which might be useful when you are
dealing with an unknown issue. Possible values are:

- `trace`: Show every detail, like all called internal functions.
- `debug`: Shows detailed debug information.
- `info`: Normal (usually) interesting events.
- `warning`: Exceptional occurrences that are not errors.
- `error`: Runtime errors that do not require immediate action.
- `fatal`: Something went terribly wrong. Add-on becomes unusable.

Please note that each level automatically includes log messages from a
more severe level, e.g., `debug` also shows `info` messages. By default,
the `log_level` is set to `info`, which is the recommended setting unless
you are troubleshooting.

### Option: `api_token`

Hetzner DNS API Token to access Hetzner DNS Server

### Option: `interval`

Interval to look for new Public IP Addresses

### Option: `records`

Collection of DNS Entries to update

### Option: `domain`

Domain Name which must exist in Hetzner DNS

### Option: `name`

DNS Record Name which should updated. If Record Name not exists it will created

### Option: `ttl`

TTL for the Record Name. Default is 3600

### Option: `ipv4`

Update only `A` Records

**Note**: _If **ipv4** and **ipv6** not given, both Record Types will updated_

### Option: `ipv6`

Update only `AAAA` Records.

**Note**: _If **ipv4** and **ipv6** not given, both Record Types will updated_

### Option: `my_fritz_fqdn`

Use MyFritz to determine the Public IP Address, otherwise Cloudflare `whoami` Service will used.

**Note**: _This could only work, if you have registered your Fritz Box by AVM_

## Support

Got questions?

You have several options to get them answered:

- The [Home Assistant Discord chat server][discord-ha] for general Home
  Assistant discussions and questions.
- The Home Assistant [Community Forum][forum].
- Join the [Reddit subreddit][reddit] in [/r/homeassistant][reddit]
- The [Technitium documentation][dns]

## Authors & contributors

The original setup of this repository is by [Roland Breitschaft][rolbre].

## License

MIT License

Copyright (c) 2006-2022 Roland Breitschaft

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

[addon-badge]: https://my.home-assistant.io/badges/supervisor_addon.svg
[addon]: https://my.home-assistant.io/redirect/supervisor_addon/?addon=a0d7b954_nodered&repository_url=https%3A%2F%2Fgithub.com%2Fhassio-addons%2Frepository
[dns]: https://technitium.com/dns/
[discord-ha]: https://discord.gg/c5DvZ4e
[forum]: https://community.home-assistant.io/t/home-assistant-community-add-on-node-red/55023?u=frenck
[reddit]: https://reddit.com/r/homeassistant
[rolbre]: https://github.com/rolbre
[Hetzner DNS]: https://dns.hetzner.com/
