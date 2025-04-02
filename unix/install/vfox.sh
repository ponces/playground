#!/bin/bash

set -e

[ "$(id -u)" -ne 0 ] && SUDO="sudo" || SUDO=""

echo "deb [trusted=yes] https://apt.fury.io/versionfox/ /" | $SUDO tee /etc/apt/sources.list.d/versionfox.list
$SUDO apt update
$SUDO apt install -y vfox
 
vfox add dotnet gradle java kubectl nodejs

echo 'eval "$(vfox activate bash)"' >> $HOME/.bash_profile
