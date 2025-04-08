#!/bin/bash

set -e

[ "$(id -u)" -ne 0 ] && SUDO="sudo" || SUDO=""

[ -z $TMPDIR ] && [ -d /tmp ] && TMPDIR="/tmp"

export DEBIAN_FRONTEND=noninteractive
$SUDO dpkg --add-architecture i386

curl -sfSL "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb" -o $TMPDIR/microsoft.deb
$SUDO dpkg -i $TMPDIR/microsoft.deb
rm -f $TMPDIR/microsoft.deb

$SUDO apt update
$SUDO apt install -y powershell

curl -sfSL https://dev.criticalmanufacturing.io/repository/http/product/cmfca.pem -o /usr/local/share/ca-certificates/cmfca.crt
$SUDO update-ca-certificates
