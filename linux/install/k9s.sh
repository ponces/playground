#!/bin/bash

set -e

[ -z "$TMPDIR" ] && [ -d /tmp ] && TMPDIR="/tmp"
[ "$(uname -m)" = "aarch64" ] && ARCH="arm64" || ARCH="amd64"

curl -sfSL "https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_${ARCH}.tar.gz" -o $TMPDIR/k9s.tar.gz
tar -xzf $TMPDIR/k9s.tar.gz k9s
rm -f $TMPDIR/k9s.tar.gz

mv k9s $HOME/.local/bin/k9s
chmod +x $HOME/.local/bin/k9s
