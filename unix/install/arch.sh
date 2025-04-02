#!/bin/bash

set -e

sudo pacman -Syyu --noconfirm
sudo pacman -S --noconfirm adapta-gtk-theme android-tools android-udev chrome-gnome-shell \
                           gdm gimp gparted htop npm steam tlp vlc youtube-dl

yaourt -Syua --noconfirm
yaourt -S --noconfirm ferdium-bin google-chrome gyp-git insync insync-nautilus \
                      numix-icon-theme-git numix-circle-icon-theme-git \
                      paper-icon-theme unclutter-xfixes-git visual-studio-code-bin

sudo pacman -Rns $(pacman -Qtdq) --noconfirm

git config --global user.name 'Alberto Ponces'
git config --global user.email ponces26@gmail.com
git config --global push.default simple
git config --global credential.helper 'cache --timeout=7200'

gsettings set org.gnome.desktop.interface icon-theme Numix-Circle
gsettings set org.gnome.desktop.interface gtk-theme Arc-Dark
gsettings set org.gnome.shell.extensions.user-theme name Arc-Dark