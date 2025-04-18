#!/bin/bash

set -e

[ "$(id -u)" -ne 0 ] && SUDO="sudo" || SUDO=""

[ -z $TMPDIR ] && [ -d /tmp ] && TMPDIR="/tmp"

if [ ! -z $TERMUX_VERSION ] && command -v npm >/dev/null; then
    export GYP_DEFINES="android_ndk_path=''"
    npm install -g @bitwarden/cli
    exit 0
fi

res="$(cat /etc/X11/default-display-manager)"
if [[ "$res" == "/usr/sbin/gdm3" ]]; then
    link=$(curl -sfSL "https://api.github.com/repos/bitwarden/clients/releases" | \
                jq -r ".[] | \
                    select(.name | startswith(\"Desktop\")) | \
                    .assets[] | \
                    select(.name | endswith(\"amd64.deb\")) | \
                    .browser_download_url" | \
                head -1)
    curl -sfSL "$link" -o $TMPDIR/bw.deb
    $SUDO dpkg -i $TMPDIR/bw.deb
    rm -f $TMPDIR/bw.deb
fi

link=$(curl -sfSL "https://api.github.com/repos/bitwarden/clients/releases" | \
            jq -r ".[] | \
                select(.name | startswith(\"CLI\")) | \
                .assets[] | \
                select(.name | (startswith(\"bw-linux-\") and endswith(\".zip\"))) | \
                .browser_download_url" | \
            head -1)
curl -sfSL "$link" -o $TMPDIR/bw.zip

unzip -joq $TMPDIR/bw.zip bw -d $HOME/.local/bin
rm -f $TMPDIR/bw.zip
chmod +x $HOME/.local/bin/bw

link=$(curl -sfSL "https://api.github.com/repos/bitwarden/sdk-sm/releases" | \
            jq -r ".[] | \
                select(.name | startswith(\"bws CLI\")) | \
                .assets[] | \
                select(.name | (startswith(\"bws-$(uname -p)-unknown-linux-gnu-\") and endswith(\".zip\"))) | \
                .browser_download_url" | \
            head -1)
curl -sfSL "$link" -o $TMPDIR/bws.zip

unzip -joq $TMPDIR/bws.zip bws -d $HOME/.local/bin
rm -f $TMPDIR/bws.zip
chmod +x $HOME/.local/bin/bws
