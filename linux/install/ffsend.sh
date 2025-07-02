#!/bin/bash

set -e

curl -sfSL https://api.github.com/repos/timvisee/ffsend/releases/latest | grep browser_download_url | cut -d '"' -f 4 | grep "linux-x64-static" | wget -O $HOME/.local/bin/ffsend -qi -
chmod +x $HOME/.local/bin/ffsend
