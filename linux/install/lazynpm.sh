#!/bin/bash

set -e

[ -z "$TMPDIR" ] && [ -d /tmp ] && TMPDIR="/tmp"
[ "$(uname -m)" = "aarch64" ] && ARCH="arm64" || ARCH="x86_64"

url=$(curl -sfSL https://api.github.com/repos/jesseduffield/lazynpm/releases/latest | \
            jq -r ".assets[] | \
                select(.name | endswith(\"_Linux_${ARCH}.tar.gz\")) | \
                .browser_download_url" | \
            head -1)
curl -sfSL "$url" -o $TMPDIR/lazynpm.tar.gz
tar -xzf $TMPDIR/lazynpm.tar.gz lazynpm
rm -f $TMPDIR/lazynpm.tar.gz

mv lazynpm $HOME/.local/bin/lazynpm
chmod +x $HOME/.local/bin/lazynpm
