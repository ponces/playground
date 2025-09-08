#!/bin/bash

set -e

[ -z "$TMPDIR" ] && [ -d /tmp ] && TMPDIR="/tmp"
[ "$(uname -m)" = "aarch64" ] && ARCH="arm64" || ARCH="x86_64"

url=$(curl -sfSL https://api.github.com/repos/jesseduffield/lazydocker/releases/latest | \
            jq -r ".assets[] | \
                select(.name | endswith(\"_Linux_${ARCH}.tar.gz\")) | \
                .browser_download_url" | \
            head -1)
curl -sfSL "$url" -o $TMPDIR/lazydocker.tar.gz
tar -xzf $TMPDIR/lazydocker.tar.gz lazydocker
rm -f $TMPDIR/lazydocker.tar.gz

mv lazydocker $HOME/.local/bin/lazydocker
chmod +x $HOME/.local/bin/lazydocker
