#!/bin/bash

set -e

[ -z "$TMPDIR" ] && [ -d /tmp ] && TMPDIR="/tmp"
[ "$(uname -m)" = "aarch64" ] && ARCH="arm64" || ARCH="amd64"

if [ ! -z "$TERMUX_VERSION" ]; then
    curl -sfSL https://github.com/ponces/bitwarden-ssh-agent/raw/refs/heads/master/bw_add_sshkeys.py -o $HOME/.local/bin/bw_add_sshkeys
    chmod +x $HOME/.local/bin/bw_add_sshkeys
fi

if [ ! -z "$TERMUX_VERSION" ]; then
    pkg install rbw
else
    link=$(curl -sfSL "https://api.github.com/repos/cli/cli/releases/latest" | \
                jq -r ".assets[] | \
                    select(.name | endswith(\"_linux_$ARCH.tar.gz\")) | \
                    .browser_download_url" | \
                head -1)
    curl -sfSL "$link" -o $TMPDIR/rbw.tar.gz
    tar -xzf $TMPDIR/rbw.tar.gz -C $HOME/.local --strip-components=1
    rm -f $TMPDIR/rbw.tar.gz
    rm -rf $HOME/.local/completion
fi
