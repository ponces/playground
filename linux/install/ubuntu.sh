#!/bin/bash

set -e

[ "$(id -u)" -ne 0 ] && SUDO="sudo" || SUDO=""

mkdir -p $HOME/.config

$SUDO apt update
$SUDO apt upgrade -y
$SUDO apt install -y apache2-utils bash build-essential ca-certificates curl dos2unix ffmpeg git jq pipx \
                     python3 python3-dev python-is-python3 python3-pip python3-venv tar tree \
                     unzip wget xdg-utils xz-utils zip

pipx install liblp payload_dumper telegram-upload yt-dlp

curl -sfSL https://get.docker.com | $SUDO bash
$SUDO usermod -aG docker $USER

curl -sfSL https://go.ponces.xyz/android | bash
curl -sfSL https://go.ponces.xyz/aosp | bash
curl -sfSL https://go.ponces.xyz/bitwarden | bash
curl -sfSL https://go.ponces.xyz/chezmoi | bash
curl -sfSL https://go.ponces.xyz/ffsend | bash
curl -sfSL https://go.ponces.xyz/mise | bash
curl -sfSL https://go.ponces.xyz/zsh | bash

mise use --global dotnet@8.0
mise use --global gradle@8.6
mise use --global helm
mise use --global helmfile
mise use --global java@17
mise use --global kubectl
mise use --global node@20
mise use --global rust

if [ -n "$WSL_DISTRO_NAME" ]; then
    printf "[boot]\nsystemd = true\n\n[network]\nhostname = ubuntu\n" | $SUDO tee /etc/wsl.conf
fi
