#!/bin/bash

set -e

[ "$(id -u)" -ne 0 ] && SUDO="sudo" || SUDO=""

export PATH="$HOME/.local/bin:$PATH"

$SUDO pacman -Syyu --noconfirm
$SUDO pacman -S --noconfirm adapta-gtk-theme android-tools android-udev chrome-gnome-shell \
                           gdm gimp gparted htop npm steam tlp vlc youtube-dl

yaourt -Syua --noconfirm
yaourt -S --noconfirm ferdium-bin google-chrome gyp-git insync insync-nautilus \
                     numix-icon-theme-git numix-circle-icon-theme-git \
                     paper-icon-theme unclutter-xfixes-git visual-studio-code-bin

$SUDO pacman -Rns $(pacman -Qtdq) --noconfirm

curl -sfSL https://go.ponces.dev/aosp | bash
curl -sfSL https://go.ponces.dev/base | bash
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
mise use --global java@17
mise use --global node@20
mise use --global rust

eval "$($HOME/.local/bin/mise activate bash)"

curl -sfSL https://go.ponces.dev/android | bash

gsettings set org.gnome.desktop.interface icon-theme Numix-Circle
gsettings set org.gnome.desktop.interface gtk-theme Arc-Dark
gsettings set org.gnome.shell.extensions.user-theme name Arc-Dark
