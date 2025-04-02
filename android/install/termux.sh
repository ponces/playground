#!/bin/bash

set -e

yes | termux-setup-storage
sleep 10

if [ ! -d $HOME/storage ]; then
    echo "Storage folder not found! Exiting..."
    exit 1
fi

tee $HOME/.bash_profile >/dev/null << 'EOF'
# ~/.bash_profile
alias tmuxb='tar -zcf /sdcard/Download/termux-backup-$(date '"'"'+%Y%m%d%H%M'"'"').tar.gz -C /data/data/com.termux/files ./home ./usr'
alias tmuxr='tar -zxf /sdcard/Download/termux-backup-*.tar.gz -C /data/data/com.termux/files --recursive-unlink --preserve-permissions'
sv-enable code
sv-enable sshd
keychain id_ubuild01 id_github 2>/dev/null
. ~/.keychain/localhost-sh
EOF

curl -sfL https://gitlab.com/st42/termux-sudo/-/raw/master/sudo -o $PREFIX/bin/sudo
chmod 700 $PREFIX/bin/sudo

apt update
apt upgrade -y
apt install -y root-repo tur-repo x11-repo
apt install -y binutils code-server file git iproute2 jq keychain ncurses-utils nodejs-lts \
               openssh openssl-tool python termux-services tsu unzip wget yarn zip

mkdir -p $PREFIX/var/service/code/log
touch $PREFIX/var/service/code/down
echo '#!/data/data/com.termux/files/usr/bin/sh' >> $PREFIX/var/service/code/run
echo 'exec code-server --bind-addr 0.0.0.0:8080 --auth none --cert --disable-telemetry 2>&1' >> $PREFIX/var/service/code/run
chmod +x $PREFIX/var/service/code/run
ln -sf $PREFIX/share/termux-services/svlogger $PREFIX/var/service/code/log/run

if [ ! -d $HOME/.oh-my-zsh ]; then
    curl -sfL https://go.ponces.xyz/zsh | bash
fi

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

mkdir -p $HOME/.ssh
[ -f $HOME/storage/downloads/id_github ] && cp $HOME/storage/downloads/id_github $HOME/.ssh
[ -f $HOME/storage/downloads/id_ubuild01 ] && cp $HOME/storage/downloads/id_ubuild01 $HOME/.ssh
[ -f $HOME/storage/downloads/id_termux.pub ] && cat $HOME/storage/downloads/id_termux.pub >> $HOME/.ssh/authorized_keys
