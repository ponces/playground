#!/bin/bash

set -e

rm -rf $HOME/.zshrc*
rm -rf $HOME/.oh-my-zsh
sudo apt install -y zsh

yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone -q --depth=1 https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
echo "source $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >> $HOME/.zshrc

git clone -q --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
echo "source $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> $HOME/.zshrc

touch $HOME/.bash_profile
echo "source $HOME/.bash_profile" >> $HOME/.zshrc

if [ -f /etc/pam.d/chsh ]; then
    sudo sed 's/required/sufficient/g' -i /etc/pam.d/chsh
    sudo chsh -s $(which zsh) $(whoami)
fi

zsh
