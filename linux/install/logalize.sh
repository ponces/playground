#!/bin/bash

set -e

[ "$(uname -m)" = "aarch64" ] && ARCH="arm64" || ARCH="amd64"

url=$(curl -sfSL https://api.github.com/repos/deponian/logalize/releases/latest | \
            jq -r ".assets[] | \
                select(.name | endswith(\"_linux_${ARCH}\")) | \
                .browser_download_url" | \
            head -1)
curl -sfSL "$url" -o $HOME/.local/bin/logalize
chmod +x $HOME/.local/bin/logalize
