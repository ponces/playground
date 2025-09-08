#!/bin/bash

set -e

[ -z "$TMPDIR" ] && [ -d /tmp ] && TMPDIR="/tmp"
[ "$(uname -m)" = "aarch64" ] && ARCH="arm64" || ARCH="amd64"

url=$(curl -sfSL https://api.github.com/repos/yorukot/superfile/releases/latest | \
            jq -r ".assets[] | \
                select(.name | (startswith(\"superfile-linux-\") and endswith(\"-${ARCH}.tar.gz\"))) | \
                .browser_download_url" | \
            head -1)
curl -sfSL "$url" -o $TMPDIR/superfile.tar.gz
tar -xzf $TMPDIR/superfile.tar.gz -C $HOME/.local/bin --strip-components=3
rm -f $TMPDIR/superfile.tar.gz
