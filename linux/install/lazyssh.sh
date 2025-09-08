#!/bin/bash

set -e

[ -z "$TMPDIR" ] && [ -d /tmp ] && TMPDIR="/tmp"
[ "$(uname -m)" = "aarch64" ] && ARCH="arm64" || ARCH="x86_64"

url=$(curl -sfSL https://api.github.com/repos/Adembc/lazyssh/releases/latest | \
            jq -r ".assets[] | \
                select(.name | endswith(\"_Linux_${ARCH}.tar.gz\")) | \
                .browser_download_url" | \
            head -1)
curl -sfSL "$url" -o $TMPDIR/lazyssh.tar.gz
tar -xzf $TMPDIR/lazyssh.tar.gz lazyssh
rm -f $TMPDIR/lazyssh.tar.gz

mv lazyssh $HOME/.local/bin/lazyssh
chmod +x $HOME/.local/bin/lazyssh
