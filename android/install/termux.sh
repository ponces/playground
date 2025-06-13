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

apt update
apt upgrade -y
apt install -y root-repo tur-repo x11-repo
apt install -y bash binutils code-server curl file git iproute2 jq keychain nano ncurses-utils \
               nodejs-lts openssh openssl-tool python termux-services tar tsu unzip wget yarn zip

curl -sfSL https://gitlab.com/st42/termux-sudo/-/raw/master/sudo -o $PREFIX/bin/sudo
chmod 700 $PREFIX/bin/sudo

curl -sfSL https://go.ponces.xyz/bitwarden | bash
export BW_SESSION="bw unlock --raw"
if [ -z "$BW_SESSION" ]; then
    export BW_SESSION=$(bw login --raw)
fi

curl -sfSL https://go.ponces.xyz/chezmoi | bash
curl -sfSL https://go.ponces.xyz/ffsend | bash
curl -sfSL https://go.ponces.xyz/mise | bash
curl -sfSL https://go.ponces.xyz/zsh | bash

mkdir -p $PREFIX/var/service/code/log
touch $PREFIX/var/service/code/down
echo '#!/data/data/com.termux/files/usr/bin/sh' >> $PREFIX/var/service/code/run
echo 'exec code-server --bind-addr 0.0.0.0:8080 --auth none --cert --disable-telemetry 2>&1' >> $PREFIX/var/service/code/run
chmod +x $PREFIX/var/service/code/run
ln -sf $PREFIX/share/termux-services/svlogger $PREFIX/var/service/code/log/run

mkdir -p $HOME/.ssh
[ -f $HOME/storage/downloads/id_github ] && cp -f $HOME/storage/downloads/id_github $HOME/.ssh/id_github
[ -f $HOME/storage/downloads/id_ubuild01 ] && cp -f $HOME/storage/downloads/id_ubuild01 $HOME/.ssh/id_ubuild01
[ -f $HOME/storage/downloads/id_termux.pub ] && cat $HOME/storage/downloads/id_termux.pub >> $HOME/.ssh/authorized_keys
