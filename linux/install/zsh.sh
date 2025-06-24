#!/bin/bash

set -e

[ "$(id -u)" -ne 0 ] && SUDO="sudo" || SUDO=""

rm -rf $HOME/.zshrc*
rm -rf $HOME/.oh-my-zsh

if ! command -v zsh >/dev/null; then
    $SUDO apt-get update
    $SUDO apt-get install -y zsh
fi

yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone -q --depth=1 https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone -q --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

if [ -f /etc/pam.d/chsh ]; then
    $SUDO sed 's/required/sufficient/g' -i /etc/pam.d/chsh
fi

if [ ! -z "$TERMUX_VERSION" ]; then
    $SUDO chsh -s zsh $(whoami)
else
    $SUDO chsh -s $(which zsh) $(whoami)
fi