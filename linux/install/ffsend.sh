#!/bin/bash

set -e

url=$(curl -sfSL "https://api.github.com/repos/timvisee/ffsend/releases/latest" | \
            jq -r ".assets[] | \
                select(.name | endswith(\"linux-x64-static\")) | \
                .browser_download_url" | \
            head -1)
curl -sfSL "$url" -o $HOME/.local/bin/ffsend
chmod +x $HOME/.local/bin/ffsend
