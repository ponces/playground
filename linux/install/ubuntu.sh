#!/bin/bash

set -e

[ "$(id -u)" -ne 0 ] && SUDO="sudo" || SUDO=""

tee $HOME/.bash_profile >/dev/null << 'EOF'
# ~/.bash_profile
export PATH="$PATH:$HOME/.local/bin"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HOME/.local/lib64:$HOME/.local/lib"

alias buildroid='source build/envsetup.sh && lunch ponces_gsi_arm64-bp1a-userdebug && make -j$(nproc --ignore=2) systemimage'
alias cddev='cd $HOME/ponces/device/ponces/gsi'
alias cdtop='cd $HOME/ponces'
alias upload='telegram-upload'
EOF

tee $HOME/.screenrc >/dev/null << 'EOF'
startup_message off
vbell off
defscrollback 10000
termcapinfo xterm* ti@:te@
hardstatus alwayslastline
hardstatus string '%{= kG}[ %{G}%H %{g}][%= %{= kw}%?%-Lw%?%{r}(%{W}%n*%f%t%?(%u)%?%{r})%{w}%?%+Lw%?%?%= %{g}][%{B} %m-%d %{W}%c %{g}]'
shell -$SHELL
EOF

mkdir -p $HOME/.config
echo "{\"api_id\": $TELEGRAM_API_ID, \"api_hash\": \"$TELEGRAM_API_HASH\"}" > $HOME/.config/telegram-upload.json

$SUDO apt update
$SUDO apt upgrade -y
$SUDO apt install -y bash build-essential ca-certificates curl dos2unix ffmpeg git jq pipx \
                     python3 python3-dev python-is-python3 python3-pip python3-venv tar tree \
                     unzip wget xz-utils zip

pipx install liblp payload_dumper telegram-upload yt-dlp

curl -sfL https://get.docker.com | $SUDO bash
$SUDO usermod -aG docker $USER

curl -sfL https://go.ponces.xyz/android | bash
curl -sfL https://go.ponces.xyz/aosp | bash
curl -sfL https://go.ponces.xyz/ffsend | bash
curl -sfL https://go.ponces.xyz/rust | bash
curl -sfL https://go.ponces.xyz/vfox | bash
curl -sfL https://go.ponces.xyz/zsh | bash

eval "$(vfox activate bash)"
vfox install dotnet@8.0.11 gradle@8.6 java@17 kubectl@1.30.2 nodejs@20
vfox use -g dotnet@8.0.11
vfox use -g gradle@8.6
vfox use -g java@17
vfox use -g kubectl@1.30.2
vfox use -g nodejs@20

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
