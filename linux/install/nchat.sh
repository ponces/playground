#!/bin/bash

set -e

[ -z "$TMPDIR" ] && [ -d /tmp ] && TMPDIR="/tmp"
[ "$(uname -m)" = "aarch64" ] && ARCH="arm64" || ARCH="x86_64"

url=$(curl -sfSL https://api.github.com/repos/ponces/nchat/releases/latest | \
            jq -r ".assets[] | \
                select(.name | endswith(\"_linux_${ARCH}.tar.gz\")) | \
                .browser_download_url" | \
            head -1)
curl -sfSL "$url" -o $TMPDIR/nchat.tar.gz
tar -xzf $TMPDIR/nchat.tar.gz -C $HOME/.local --strip-components=1
rm -f $TMPDIR/nchat.tar.gz
rm -f $HOME/.local/README.md
rm -f $HOME/.local/LICENSE
