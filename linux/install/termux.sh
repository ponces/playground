#!/bin/bash

set -e

if [ -z "$TERMUX_VERSION" ]; then
    echo "This script is intended for Termux on Android. Exiting..."
    exit 1
fi

yes | termux-setup-storage
sleep 10

if [ ! -d $HOME/storage ]; then
    echo "Storage folder not found! Exiting..."
    exit 1
fi

export PATH="$HOME/.local/bin:$PATH"

mkdir -p $HOME/.config
mkdir -p $HOME/.local/bin
mkdir -p $HOME/.local/share

pkg update
pkg upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"
pkg install root-repo tur-repo x11-repo
pkg install bash binutils clang code-server curl file git iproute2 jq libffi make nano ncurses-utils \
            nodejs-lts openjdk-17 openssh openssl openssl-tool python sudo termux-services tar unzip \
            wget which yarn zip zsh

curl -sfSL https://go.ponces.dev/chezmoi | bash
curl -sfSL https://go.ponces.dev/ffsend | bash
curl -sfSL https://go.ponces.dev/github | bash
curl -sfSL https://go.ponces.dev/mise | bash
curl -sfSL https://go.ponces.dev/rbw | bash
curl -sfSL https://go.ponces.dev/zsh | bash

mise use --global dotnet@8.0
mise use --global gradle@8.6
mise use --global java@17
mise use --global node@20
mise use --global rust

curl -sfSL https://go.ponces.dev/android | bash

mkdir -p "$PREFIX"/var/service/code/log
touch "$PREFIX"/var/service/code/down
echo '#!/data/data/com.termux/files/usr/bin/sh' >> "$PREFIX"/var/service/code/run
echo 'exec code-server --bind-addr 0.0.0.0:8080 --auth none --cert --disable-telemetry 2>&1' >> "$PREFIX"/var/service/code/run
chmod +x "$PREFIX"/var/service/code/run
ln -sf "$PREFIX"/share/termux-services/svlogger $PREFIX/var/service/code/log/run
