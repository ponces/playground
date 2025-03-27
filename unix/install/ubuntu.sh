#!/bin/bash

set -e

export DEBIAN_FRONTEND=noninteractive
export PATH="$PATH:$HOME/.local/bin"

tee $HOME/.bash_profile >/dev/null << 'EOF'
# ~/.bash_profile
sendff() { ffsend upload --host "https://send.vis.ee" "$1" --downloads 5 --password "ponces" --verbose; }

export ANDROID_HOME="$HOME/.android/sdk"
export ANDROID_BUILD_TOOLS="$ANDROID_HOME/build-tools/35.0.0"
export ANDROID_PLATFORM_TOOLS="$ANDROID_HOME/platform-tools"
export ANDROID_TOOLCHAIN="$ANDROID_HOME/ndk/27.1.12297006/toolchains/llvm/prebuilt/linux-x86_64"
export PATH="$ANDROID_BUILD_TOOLS:$ANDROID_PLATFORM_TOOLS:$ANDROID_TOOLCHAIN/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH:$HOME/.local/bin"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HOME/.local/lib64:$HOME/.local/lib"

alias buildroid='source build/envsetup.sh && lunch ponces_gsi_arm64-bp1a-userdebug && make -j$(nproc --ignore=2) systemimage'
alias cddev='cd $HOME/ponces/device/ponces/gsi'
alias cdtop='cd $HOME/ponces'
alias upload='telegram-upload'

[ -d "$HOME/.version-fox" ] && eval "$(vfox activate bash)"
[ -d "$HOME/.cargo" ] && . "$HOME/.cargo/env"
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

curl -sfL https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash

echo "deb [trusted=yes] https://apt.fury.io/versionfox/ /" | sudo tee /etc/apt/sources.list.d/versionfox.list

sudo dpkg --add-architecture i386
sudo apt update
sudo apt upgrade -y
sudo apt install -y aapt bc bison build-essential ca-certificates curl dos2unix ffmpeg flex g++-multilib \
                    gcc-multilib git git-lfs gperf imagemagick jq libelf-dev libncurses-dev libssl-dev \
                    libstdc++6 libstdc++6:i386 libxml2-utils locales lunzip lzip lzop m4 make pipx \
                    python-is-python3 python3-pip squashfs-tools tree unzip wget vfox xattr \
                    xmlstarlet zip zlib1g zlib1g:i386 zsh

curl -fsSL https://get.docker.com | sudo bash
sudo usermod -aG docker $USER

eval "$(vfox activate bash)"
vfox add dotnet gradle java nodejs
vfox install dotnet@8.0.11 gradle@8.6 java@17 nodejs@20
vfox use -g dotnet@8.0.11
vfox use -g java@17
vfox use -g gradle@8.6
vfox use -g nodejs@20
eval "$(vfox activate bash)"

pipx install liblp payload_dumper telegram-upload yt-dlp

yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
echo "source $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >> $HOME/.zshrc
echo "source $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> $HOME/.zshrc
echo "source $HOME/.bash_profile" >> $HOME/.zshrc
sudo chsh -s $(which zsh) $USER

sudo curl -sfL https://storage.googleapis.com/git-repo-downloads/repo -o /usr/local/bin/repo
sudo chmod 0755 /usr/local/bin/repo

git lfs install

git config --global alias.pushfwl "push --force-with-lease"
git config --global core.editor "nano"
git config --global color.ui "auto"
git config --global fetch.prune true
git config --global fetch.pruneTags true
git config --global oh-my-zsh.hide-dirty 1
git config --global pull.rebase true
git config --global push.autoSetupRemote true
git config --global rebase.autosquash true
git config --global user.name "Alberto Ponces"
git config --global user.email "ponces26@gmail.com"

ANDROID_HOME="$HOME/.android/sdk"
mkdir -p $ANDROID_HOME
curl -sfL https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -o commandlinetools-linux.zip
unzip -q commandlinetools-linux.zip -d cmdline-tools
mv cmdline-tools/cmdline-tools cmdline-tools/latest
mv cmdline-tools $ANDROID_HOME
yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --install "build-tools;35.0.0" "cmake;3.31.1" "ndk;27.1.12297006" "platform-tools" "platforms;android-35"
rm -f commandlinetools-linux.zip

curl -sfL https://api.github.com/repos/iBotPeaches/Apktool/releases/latest | grep browser_download_url | cut -d '"' -f 4 | sudo wget -O /usr/local/bin/apktool.jar -qi -
sudo chmod +r /usr/local/bin/apktool.jar
sudo curl -sfL https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool -o /usr/local/bin/apktool
sudo chmod +x /usr/local/bin/apktool

curl -sfL https://api.github.com/repos/timvisee/ffsend/releases/latest | grep browser_download_url | cut -d '"' -f 4 | grep "linux-x64-static" | sudo wget -O /usr/local/bin/ffsend -qi -
sudo chmod +x /usr/local/bin/ffsend

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
. "$HOME/.cargo/env"
rustup default stable
rustup target add aarch64-linux-android
cargo install cargo-ndk