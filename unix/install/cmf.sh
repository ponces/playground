#!/bin/bash

set -e

export DEBIAN_FRONTEND=noninteractive
sudo dpkg --add-architecture i386

curl -sfL "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb" -o microsoft.deb
sudo dpkg -i microsoft.deb
sudo apt update
sudo apt install -y powershell
rm -f microsoft.deb

eval "$(vfox activate bash)"
vfox add kubectl
vfox install kubectl@1.30.2
vfox use -g kubectl@1.30.2

curl -sfL https://dev.criticalmanufacturing.io/repository/http/product/cmfca.pem -o /usr/local/share/ca-certificates/cmfca.crt
sudo update-ca-certificates
