#!/bin/bash

set -e

[ "$(id -u)" -ne 0 ] && SUDO="sudo" || SUDO=""

export DEBIAN_FRONTEND=noninteractive
$SUDO dpkg --add-architecture i386

curl -sfL "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb" -o microsoft.deb
$SUDO dpkg -i microsoft.deb
rm -f microsoft.deb

$SUDO apt update
$SUDO apt install -y powershell

curl -sfL https://dev.criticalmanufacturing.io/repository/http/product/cmfca.pem -o /usr/local/share/ca-certificates/cmfca.crt
$SUDO update-ca-certificates
