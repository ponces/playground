#!/bin/bash

set -e

[ "$(id -u)" -ne 0 ] && SUDO="sudo" || SUDO=""

$SUDO pacman -Syyu --noconfirm
$SUDO pacman -S --noconfirm adapta-gtk-theme android-tools android-udev chrome-gnome-shell \
                          gdm gimp gparted htop npm steam tlp vlc youtube-dl

yaourt -Syua --noconfirm
yaourt -S --noconfirm ferdium-bin google-chrome gyp-git insync insync-nautilus \
                     numix-icon-theme-git numix-circle-icon-theme-git \
                     paper-icon-theme unclutter-xfixes-git visual-studio-code-bin

$SUDO pacman -Rns $(pacman -Qtdq) --noconfirm

git config --global alias.pushfwl "push --force-with-lease"
git config --global color.ui "auto"
git config --global core.editor "nano"
git config --global fetch.prune true
git config --global fetch.pruneTags true
git config --global pull.rebase true
git config --global push.autoSetupRemote true
git config --global rebase.autosquash true
git config --global user.name "Alberto Ponces"
git config --global user.email "ponces26@gmail.com"

gsettings set org.gnome.desktop.interface icon-theme Numix-Circle
gsettings set org.gnome.desktop.interface gtk-theme Arc-Dark
gsettings set org.gnome.shell.extensions.user-theme name Arc-Dark
