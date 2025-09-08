#!/bin/bash

set -e

[ "$(id -u)" -ne 0 ] && SUDO="sudo" || SUDO=""
[ -z "$TMPDIR" ] && [ -d /tmp ] && TMPDIR="/tmp"
[ "$(uname -m)" = "aarch64" ] && ARCH="arm64" || ARCH="amd64"

if [ ! -z "$TERMUX_VERSION" ]; then
    curl -sfSL https://raw.githubusercontent.com/ponces/bitwarden-ssh-agent/refs/heads/master/bw_add_sshkeys.py -o $HOME/.local/bin/bw_add_sshkeys
    chmod +x $HOME/.local/bin/bw_add_sshkeys
fi

if [ ! -z "$TERMUX_VERSION" ] && command -v npm >/dev/null; then
    export GYP_DEFINES="android_ndk_path=''"
    npm install -g semver
    npm install -g @bitwarden/cli
    exit 0
fi

res="$(cat /etc/X11/default-display-manager 2>/dev/null || echo '')"
if [[ "$res" == "/usr/sbin/gdm3" ]]; then
    url=$(curl -sfSL https://api.github.com/repos/bitwarden/clients/releases | \
                jq -r ".[] | \
                    select(.name | startswith(\"Desktop\")) | \
                    .assets[] | \
                    select(.name | endswith(\"$ARCH.deb\")) | \
                    .browser_download_url" | \
                head -1)
    curl -sfSL "$url" -o $TMPDIR/bw.deb
    $SUDO dpkg -i $TMPDIR/bw.deb
    rm -f $TMPDIR/bw.deb
fi

url=$(curl -sfSL https://api.github.com/repos/bitwarden/clients/releases | \
            jq -r ".[] | \
                select(.name | startswith(\"CLI\")) | \
                .assets[] | \
                select(.name | (startswith(\"bw-linux-\") and endswith(\".zip\"))) | \
                .browser_download_url" | \
            head -1)
curl -sfSL "$url" -o $TMPDIR/bw.zip

unzip -joq $TMPDIR/bw.zip bw -d $HOME/.local/bin
rm -f $TMPDIR/bw.zip
chmod +x $HOME/.local/bin/bw

url=$(curl -sfSL https://api.github.com/repos/bitwarden/sdk-sm/releases | \
            jq -r ".[] | \
                select(.name | startswith(\"bws CLI\")) | \
                .assets[] | \
                select(.name | (startswith(\"bws-$(uname -p)-unknown-linux-gnu-\") and endswith(\".zip\"))) | \
                .browser_download_url" | \
            head -1)
curl -sfSL "$url" -o $TMPDIR/bws.zip

unzip -joq $TMPDIR/bws.zip bws -d $HOME/.local/bin
rm -f $TMPDIR/bws.zip
chmod +x $HOME/.local/bin/bws
