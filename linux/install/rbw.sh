#!/bin/bash

set -e

[ -z "$TMPDIR" ] && [ -d /tmp ] && TMPDIR="/tmp"
[ "$(uname -m)" = "aarch64" ] && ARCH="arm64" || ARCH="amd64"
[ ! -z "$TERMUX_VERSION" ] && OS="linux-android" || OS="linux"

url=$(curl -sfSL https://api.github.com/repos/ponces/rbw/releases/latest | \
            jq -r ".assets[] | \
                select(.name | endswith(\"_${OS}_${ARCH}.tar.gz\")) | \
                .browser_download_url" | \
            head -1)
curl -sfSL "$url" -o $TMPDIR/rbw.tar.gz
tar -xzf $TMPDIR/rbw.tar.gz -C $HOME/.local/bin
rm -f $TMPDIR/rbw.tar.gz
rm -rf $HOME/.local/bin/completion
