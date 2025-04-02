#!/bin/bash

set -e

[ "$(id -u)" -ne 0 ] && SUDO="sudo" || SUDO=""

WIN_HOME_RAW="$(cmd.exe /c "<nul set /p=%UserProfile%" 2>/dev/null)"
WIN_HOME="$(wslpath $WIN_HOME_RAW)"

echo >> $HOME/.bash_profile
echo "export WIN_HOME=\"$WIN_HOME\"" >> $HOME/.bash_profile

tee -a $HOME/.bash_profile >/dev/null << 'EOF'
export DONT_PROMPT_WSL_INSTALL=1

alias cdown='cd $WIN_HOME/Downloads'
alias cgit='cd $WIN_HOME/Git'
alias bumppre='npm install && npm run bump:pre'
alias pubdev='npm install && npm run build:bundle && npm run publish:dev'
alias pubnext='npm install && npm run build:bundle && npm run publish'
alias publast='npm install && npm run build:bundle && npm run publish:live'
alias ssh='ssh.exe'
alias ssh-add='ssh-add.exe'
EOF

rm -f $HOME/.screenrc

printf "[boot]\nsystemd = true\n\n[network]\nhostname = ubuntu\n" | $SUDO tee /etc/wsl.conf

git config --global core.sshCommand "ssh.exe"
