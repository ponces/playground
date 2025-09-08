#!/bin/bash

set -e

[ "$(uname -m)" = "aarch64" ] && ARCH="arm64" || ARCH="amd64"

# This requires firefox PPA version to be installed:
#   sudo add-apt-repository ppa:mozillateam/ppa
#   echo '\nPackage: *\nPin: release o=LP-PPA-mozillateam\nPin-Priority: 1001\n\nPackage: firefox\nPin: version 1:1snap*\nPin-Priority: -1\n' | sudo tee /etc/apt/preferences.d/mozilla-firefox
#   sudo apt-get install firefox

# url=$(curl -H "Authorization: Bearer $GITHUB_TOKEN" -sfSL https://api.github.com/repos/browsh-org/browsh/releases/latest | \
#             jq -r ".assets[] | \
#                 select(.name | endswith(\"_linux_${ARCH}.tar.gz\")) | \
#                 .browser_download_url" | \
#             head -1)
url="https://github.com/browsh-org/browsh/releases/download/v1.8.2/browsh_1.8.2_linux_${ARCH}"
curl -sfSL "$url" -o $HOME/.local/bin/browsh
chmod +x $HOME/.local/bin/browsh
