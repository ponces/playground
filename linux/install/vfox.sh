#!/bin/bash

set -e

[ "$(id -u)" -ne 0 ] && SUDO="sudo" || SUDO=""

echo "deb [trusted=yes] https://apt.fury.io/versionfox/ /" | $SUDO tee /etc/apt/sources.list.d/versionfox.list

$SUDO apt-get update
$SUDO apt-get install -y vfox

eval "$(vfox activate bash)"
vfox add dotnet gradle java kubectl nodejs
