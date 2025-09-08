#!/bin/bash

set -e

[ -z "$TMPDIR" ] && [ -d /tmp ] && TMPDIR="/tmp"
[ "$(uname -m)" = "aarch64" ] && ARCH="aarch64" || ARCH="x86_64"

curl -sfSL "https://www.github.com/mrjackwills/oxker/releases/latest/download/oxker_linux_$ARCH.tar.gz" -o $TMPDIR/oxker.tar.gz
tar -xzf $TMPDIR/oxker.tar.gz oxker
rm -f $TMPDIR/oxker.tar.gz

mv oxker $HOME/.local/bin/oxker
chmod +x $HOME/.local/bin/oxker
