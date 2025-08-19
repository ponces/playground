#!/bin/bash

set -e

[ -z "$TMPDIR" ] && [ -d /tmp ] && TMPDIR="/tmp"
[ "$(id -u)" -ne 0 ] && SUDO="sudo" || SUDO=""

piu install -y curl fzf gawk jq

curl -sfSL https://raw.githubusercontent.com/ponces/termv/main/termv -o $HOME/.local/bin/termv
chmod +x $HOME/.local/bin/termv

if [ ! -z "$TERMUX_VERSION" ]; then
    link=$(curl -sfSL "https://api.github.com/repos/mpv-android/mpv-android/releases/latest" | \
            jq -r ".assets[] | \
                select(.name | endswith(\"default-universal-release.apk\")) | \
                .browser_download_url" | \
            head -1)
    curl -sfSL "$link" -o $TMPDIR/mpv.apk
    $SUDO pm install $TMPDIR/mpv.apk
else
    piu install -y mpv xdo
fi