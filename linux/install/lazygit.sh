#!/bin/bash

set -e

[ -z "$TMPDIR" ] && [ -d /tmp ] && TMPDIR="/tmp"
[ "$(uname -m)" = "aarch64" ] && ARCH="arm64" || ARCH="x86_64"

url=$(curl -sfSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest | \
            jq -r ".assets[] | \
                select(.name | endswith(\"_linux_${ARCH}.tar.gz\")) | \
                .browser_download_url" | \
            head -1)
curl -sfSL "$url" -o $TMPDIR/lazygit.tar.gz
tar -xzf $TMPDIR/lazygit.tar.gz lazygit
rm -f $TMPDIR/lazygit.tar.gz

mv lazygit $HOME/.local/bin/lazygit
chmod +x $HOME/.local/bin/lazygit
