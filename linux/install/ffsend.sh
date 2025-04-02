#!/bin/bash

set -e

[ "$(id -u)" -ne 0 ] && SUDO="sudo" || SUDO=""

echo 'sendff() { ffsend upload --host "https://send.vis.ee" "$1" --downloads 5 --password "ponces" --verbose; }' >> $HOME/.bash_profile

curl -sfL https://api.github.com/repos/timvisee/ffsend/releases/latest | grep browser_download_url | cut -d '"' -f 4 | grep "linux-x64-static" | $SUDO wget -O /usr/local/bin/ffsend -qi -
$SUDO chmod +x /usr/local/bin/ffsend
