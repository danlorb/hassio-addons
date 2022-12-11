# Home assistant addons: rolbre

<a href="https://www.buymeacoffee.com/rolbre"><img src="https://img.buymeacoffee.com/button-api/?text=Buy me a coffee&emoji=&slug=rolbre&button_colour=5F7FFF&font_colour=ffffff&font_family=Cookie&outline_colour=000000&coffee_colour=FFDD00" /></a>

_Thanks to everyone having starred my repo! To star it click on the image below, then it will be on top right. Thanks!_

## About

Home Assistant allows anyone to create add-on repositories to share their add-ons for Home Assistant easily. This repository is one of those repositories, providing extra Home Assistant add-ons for your installation. You can use this AddOns as is and at your own Risk.

## Installation

[![Add repository on my Home Assistant][repository-badge]][repository-url]

If you want to do add the repository manually, please follow the procedure highlighted in the [Home Assistant website](https://home-assistant.io/hassio/installing_third_party_addons). Use the following URL to add this repository: `https://github.com/rolbre/hassio-addons`

## Add-ons provided by this repository

### Dns/Dhcp Server by Technitium

Greate Dns/Dhcp Server provided by [Technitium](https://technitium.com/dns) boxed in a HA AddOn

![amd64][amd64-badge]

### DynDns Updater for Hetzner DNS Server

DynDns Updater to update your public IP in [Hetzner DNS Servers](https://dns.hetzner.com/) boxed in a HA AddOn

![amd64][amd64-badge]

## Known Issues

- Installation of `Dns` AddOn will break automatic Updates for all AddOns on your Home Assistant Installation. While you install/update your AddOns you have to configure a public reachable DNS Server for Home Assistant (e.g. Google 8.8.8.8 or Cloudflare 1.1.1.1). After install/update, change DNS Server Setting of your Home Assistant Installation back to IP Addresses of the Dns AddOn. This could be found in the Output of the `Dns AddOn` Protocol.


[aarch64-badge]: https://img.shields.io/badge/aarch64--green.svg?logo=arm
[amd64-badge]: https://img.shields.io/badge/amd64--green.svg?logo=amd
[armv7-badge]: https://img.shields.io/badge/armv7--green.svg?logo=arm
[aarch64no-badge]: https://img.shields.io/badge/aarch64--orange.svg?logo=arm
[amd64no-badge]: https://img.shields.io/badge/amd64--orange.svg?logo=amd
[armv7no-badge]: https://img.shields.io/badge/armv7--orange.svg?logo=arm
[ingress-badge]: https://img.shields.io/badge/-ingress-blueviolet.svg?logo=Ingress

[repository-badge]: https://img.shields.io/badge/Add%20repository%20to%20my-Home%20Assistant-41BDF5?logo=home-assistant&style=for-the-badge
[repository-url]: https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Frolbre%2Fhassio-addons
