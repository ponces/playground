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

mkdir -p $HOME/.config
mkdir -p $HOME/.local/bin
mkdir -p $HOME/.local/share

apt-get update
apt-get upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"
apt-get install -y root-repo tur-repo x11-repo
apt-get install -y bash binutils code-server curl file git iproute2 jq keychain nano ncurses-utils \
                   nodejs-lts openjdk-17 openssh openssl-tool python sudo termux-services tar unzip \
                   wget which yarn zip zsh

curl -sfSL https://go.ponces.xyz/bitwarden | bash
curl -sfSL https://go.ponces.xyz/chezmoi | bash
curl -sfSL https://go.ponces.xyz/ffsend | bash
curl -sfSL https://go.ponces.xyz/mise | bash
curl -sfSL https://go.ponces.xyz/zsh | bash

mkdir -p "$PREFIX"/var/service/code/log
touch "$PREFIX"/var/service/code/down
echo '#!/data/data/com.termux/files/usr/bin/sh' >> "$PREFIX"/var/service/code/run
echo 'exec code-server --bind-addr 0.0.0.0:8080 --auth none --cert --disable-telemetry 2>&1' >> "$PREFIX"/var/service/code/run
chmod +x "$PREFIX"/var/service/code/run
ln -sf "$PREFIX"/share/termux-services/svlogger $PREFIX/var/service/code/log/run

mkdir -p $HOME/.ssh
[ -f $HOME/storage/downloads/id_github ] && cp -f $HOME/storage/downloads/id_github $HOME/.ssh/id_github
[ -f $HOME/storage/downloads/id_ubuild01 ] && cp -f $HOME/storage/downloads/id_ubuild01 $HOME/.ssh/id_ubuild01
[ -f $HOME/storage/downloads/id_termux.pub ] && cat $HOME/storage/downloads/id_termux.pub >> $HOME/.ssh/authorized_keys
