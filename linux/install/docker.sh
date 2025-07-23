#!/bin/bash

set -e

[ "$(id -u)" -ne 0 ] && SUDO="sudo" || SUDO=""

curl -sfSL https://get.docker.com | $SUDO bash

if ! getent group docker >/dev/null; then
    $SUDO groupadd -g 999 docker
fi
$SUDO usermod -aG docker $USER

curl -sfSL https://go.ponces.dev/lazydocker | bash
