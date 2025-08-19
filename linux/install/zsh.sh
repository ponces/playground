#!/bin/bash

set -e

[ "$(id -u)" -ne 0 ] && SUDO="sudo" || SUDO=""

rm -rf $HOME/.zshrc*
rm -rf $HOME/.oh-my-zsh

piu install -y zsh

yes | sh -c "$(curl -sfSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sed -i 's/# export PATH/export PATH/' $HOME/.zshrc

git clone -q --depth=1 https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone -q --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

if [ ! -z "$TERMUX_VERSION" ]; then
    chsh -s zsh $(whoami)
else
    $SUDO sed -i 's/required/sufficient/g' /etc/pam.d/chsh || true
    $SUDO chsh -s $(which zsh) $(whoami)
fi