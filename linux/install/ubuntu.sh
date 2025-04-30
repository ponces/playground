#!/bin/bash

set -e

[ "$(id -u)" -ne 0 ] && SUDO="sudo" || SUDO=""

[ -z $TMPDIR ] && [ -d /tmp ] && TMPDIR="/tmp"

export PATH="$HOME/.local/bin:$PATH"

mkdir -p $HOME/.config
mkdir -p $HOME/.local/bin
mkdir -p $HOME/.local/share

$SUDO apt update
$SUDO apt upgrade -y
$SUDO apt install -y apache2-utils bash build-essential ca-certificates curl dnsutils dos2unix \
                     ffmpeg git jq pipx python3 python3-dev python-is-python3 python3-pip \
                     python3-venv tar tree unzip wget xdg-utils xz-utils zip

pipx install liblp payload_dumper telegram-upload yt-dlp

curl -sfSL https://go.ponces.xyz/bitwarden | bash
export BW_SESSION="$(bw unlock --raw)"
if [ -z "$BW_SESSION" ]; then
    export BW_SESSION=$(bw login --raw)
fi

curl -sfSL https://go.ponces.xyz/aosp | bash
curl -sfSL https://go.ponces.xyz/chezmoi | bash
curl -sfSL https://go.ponces.xyz/docker | bash
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

curl -sfSL https://go.ponces.xyz/android | bash

res="$(cat /etc/X11/default-display-manager)"
if [[ "$res" == "/usr/sbin/gdm3" ]]; then
    if command -v gsettings >/dev/null; then
        gsettings set org.gnome.desktop.interface accent-color 'teal'
        gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
        gsettings set org.gnome.desktop.peripherals.touchpad disable-while-typing false
        gsettings set org.gnome.desktop.peripherals.touchpad edge-scrolling-enabled false
        gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true
        gsettings set org.gnome.desktop.peripherals.touchpad speed 0.2
        gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
        gsettings set org.gnome.desktop.peripherals.touchpad two-finger-scrolling-enabled true
        gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
        gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-automatic true
        gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature uint32 3700
        gsettings set org.gnome.settings-daemon.plugins.power lid-close-battery-action 'suspend'
        gsettings set org.gnome.shell.extensions.dash-to-dock autohide true
        gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 40
        gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
        gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
        gsettings set org.gnome.shell.extensions.ding show-home false
    fi

    echo 'SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", MODE="0666", GROUP="plugdev"' | $SUDO tee /etc/udev/rules.d/51-android.rules
    $SUDO udevadm control --reload
    $SUDO udevadm trigger

    curl -sfSL https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o $TMPDIR/chrome.deb
    $SUDO dpkg -i $TMPDIR/chrome.deb
    rm -f $TMPDIR/chrome.deb

    curl -sfSL "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -o $TMPDIR/code.deb
    $SUDO dpkg -i $TMPDIR/code.deb
    rm -f $TMPDIR/code.deb

    curl -sfSL https://links.fortinet.com/forticlient/deb/vpnagent -o $TMPDIR/vpn.deb
    $SUDO dpkg -i $TMPDIR/vpn.deb
    rm -f $TMPDIR/vpn.deb

    link=$(curl -sfSL "https://api.github.com/repos/ferdium/ferdium-app/releases/latest" | \
                jq -r ".assets[] | \
                    select(.name | endswith(\"amd64.deb\")) | \
                    .browser_download_url")
    curl -sfSL "$link" -o $TMPDIR/ferdium.deb
    $SUDO dpkg -i $TMPDIR/ferdium.deb
fi

if [ -n "$WSL_DISTRO_NAME" ]; then
    printf "[boot]\nsystemd = true\n\n[network]\nhostname = ubuntu\n" | $SUDO tee /etc/wsl.conf
fi
