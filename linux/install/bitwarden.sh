#!/bin/bash

set -e

[ -z $TMPDIR ] && [ -d /tmp ] && TMPDIR="/tmp"

if [ ! -z $TERMUX_VERSION ] && command -v npm >/dev/null; then
    export GYP_DEFINES="android_ndk_path=''"
    npm install -g @bitwarden/cli
    exit 0
fi

link=$(curl -sfSL "https://api.github.com/repos/bitwarden/clients/releases" | \
            jq -r ".[] | \
                select(.name | startswith(\"CLI\")) | \
                .assets[] | \
                select(.name | (startswith(\"bw-linux-\") and endswith(\".zip\"))) | \
                .browser_download_url" | \
            head -1)
curl -sfSL "$link" -o $TMPDIR/bitwarden.zip

unzip -q $TMPDIR/bitwarden.zip -d $HOME/.local/bin
rm -f $TMPDIR/bitwarden.zip
chmod +x $HOME/.local/bin/bw

link=$(curl -sfSL "https://api.github.com/repos/bitwarden/sdk-sm/releases" | \
            jq -r ".[] | \
                select(.name | startswith(\"bws CLI\")) | \
                .assets[] | \
                select(.name | (startswith(\"bws-$(uname -p)-unknown-linux-gnu-\") and endswith(\".zip\"))) | \
                .browser_download_url" | \
            head -1)
curl -sfSL "$link" -o $TMPDIR/bitwarden.zip

unzip -q $TMPDIR/bitwarden.zip -d $HOME/.local/bin
rm -f $TMPDIR/bitwarden.zip
chmod +x $HOME/.local/bin/bws
