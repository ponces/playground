#!/bin/bash

set -e

[ "$(id -u)" -ne 0 ] && SUDO="sudo" || SUDO=""

curl -sfSL https://tailscale.com/install.sh | sh
curl -sfSL https://neuralink.com/tsui/install.sh | bash

if [ -d /etc/sysctl.d ]; then
    echo 'net.ipv4.ip_forward = 1' | $SUDO tee -a /etc/sysctl.d/99-tailscale.conf
    echo 'net.ipv6.conf.all.forwarding = 1' | $SUDO tee -a /etc/sysctl.d/99-tailscale.conf
    $SUDO sysctl -p /etc/sysctl.d/99-tailscale.conf
fi
