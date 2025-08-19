#!/bin/bash

set -e

if ! command -v lsb_release &> /dev/null; then
    echo "This script is intended for Debian-based OSes. Exiting..."
    exit 1
fi

[ "$(id -u)" -ne 0 ] && SUDO="sudo" || SUDO=""
[ -z "$TMPDIR" ] && [ -d /tmp ] && TMPDIR="/tmp"
[ "$(uname -m)" = "aarch64" ] && ARCH="arm64" || ARCH="amd64"

export PATH="$HOME/.local/bin:$PATH"

mkdir -p $HOME/.config
mkdir -p $HOME/.local/bin
mkdir -p $HOME/.local/share

$SUDO apt-get update
$SUDO apt-get upgrade -y
$SUDO apt-get install -y apache2-utils bash build-essential ca-certificates curl dnsutils dos2unix \
                         ffmpeg git jq pipx python3 python3-dev python-is-python3 python3-pip \
                         python3-venv tar tree unzip wget xdg-utils xz-utils zip

pipx install liblp payload_dumper yt-dlp

curl -sfSL https://go.ponces.dev/aosp | bash
curl -sfSL https://go.ponces.dev/chezmoi | bash
curl -sfSL https://go.ponces.dev/docker | bash
curl -sfSL https://go.ponces.dev/ffsend | bash
curl -sfSL https://go.ponces.dev/github | bash
curl -sfSL https://go.ponces.dev/mise | bash
curl -sfSL https://go.ponces.dev/piu | bash
curl -sfSL https://go.ponces.dev/rbw | bash
curl -sfSL https://go.ponces.dev/zsh | bash

mise use --global dotnet@8.0
mise use --global gradle@8.6
mise use --global helm
mise use --global helmfile
mise use --global java@17
mise use --global kubectl
mise use --global node@20
mise use --global rust

eval "$($HOME/.local/bin/mise activate bash)"

curl -sfSL https://go.ponces.dev/android | bash

res="$(cat /etc/X11/default-display-manager 2>/dev/null || echo '')"
if [[ "$res" == "/usr/sbin/gdm3" ]]; then
    $SUDO apt-get install -y file-roller

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

    curl -sfSL https://dl.google.com/linux/direct/google-chrome-stable_current_$ARCH.deb -o $TMPDIR/chrome.deb
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
                    select(.name | endswith(\"$ARCH.deb\")) | \
                    .browser_download_url")
    curl -sfSL "$link" -o $TMPDIR/ferdium.deb
    $SUDO dpkg -i $TMPDIR/ferdium.deb
fi

if [ ! -z "$WSL_DISTRO_NAME" ]; then
    if ! grep -q "systemd" /etc/wsl.conf; then
        printf "\n[boot]\nsystemd = true\n" | $SUDO tee -a /etc/wsl.conf
    fi
    if ! grep -q "hostname" /etc/wsl.conf; then
        printf "\n[network]\nhostname = ubuntu\n" | $SUDO tee -a /etc/wsl.conf
    fi
    if ! grep -q "default" /etc/wsl.conf; then
        printf "\n[user]\ndefault = ponces\n" | $SUDO tee -a /etc/wsl.conf
    fi
fi
