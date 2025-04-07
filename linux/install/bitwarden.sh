#!/bin/bash

set -e

[ "$(id -u)" -ne 0 ] && SUDO="sudo" || SUDO=""

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

unzip -q $TMPDIR/bitwarden.zip -d $TMPDIR/bitwarden
$SUDO cp $TMPDIR/bitwarden/bw /usr/local/bin
$SUDO chmod +x /usr/local/bin/bw

rm -rf $TMPDIR/bitwarden
rm -rf $TMPDIR/bitwarden.zip

link=$(curl -sfSL "https://api.github.com/repos/bitwarden/sdk-sm/releases" | \
            jq -r ".[] | \
                select(.name | startswith(\"bws CLI\")) | \
                .assets[] | \
                select(.name | (startswith(\"bws-x86_64-unknown-linux-gnu-\") and endswith(\".zip\"))) | \
                .browser_download_url" | \
            head -1)
curl -sfSL "$link" -o $TMPDIR/bitwarden.zip

unzip -q $TMPDIR/bitwarden.zip -d $TMPDIR/bitwarden
$SUDO cp $TMPDIR/bitwarden/bws /usr/local/bin
$SUDO chmod +x /usr/local/bin/bws

rm -rf $TMPDIR/bitwarden
rm -rf $TMPDIR/bitwarden.zip
