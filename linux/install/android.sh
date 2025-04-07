#!/bin/bash

set -e

[ "$(id -u)" -ne 0 ] && SUDO="sudo" || SUDO=""

tee -a $HOME/.bash_profile >/dev/null << 'EOF'
export ANDROID_HOME="$HOME/.android/sdk"
export ANDROID_BUILD_TOOLS="$ANDROID_HOME/build-tools/35.0.0"
export ANDROID_NDK_HOME="$ANDROID_HOME/ndk/27.1.12297006"
export ANDROID_PLATFORM_TOOLS="$ANDROID_HOME/platform-tools"
export ANDROID_TOOLCHAIN="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64"
export PATH="$ANDROID_BUILD_TOOLS:$ANDROID_PLATFORM_TOOLS:$ANDROID_TOOLCHAIN/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$HOME/.local/bin:$PATH"
export LD_LIBRARY_PATH="$HOME/.local/lib64:$HOME/.local/lib:$LD_LIBRARY_PATH"
EOF

ANDROID_HOME="$HOME/.android/sdk"
mkdir -p $ANDROID_HOME

curl -sfSL https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -o commandlinetools-linux.zip
unzip -q commandlinetools-linux.zip -d cmdline-tools
rm -f commandlinetools-linux.zip
mv cmdline-tools/cmdline-tools cmdline-tools/latest
mv cmdline-tools $ANDROID_HOME

yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --install "build-tools;35.0.0" "cmake;3.31.1" "ndk;27.1.12297006" "platform-tools" "platforms;android-35"

curl -sfSL https://api.github.com/repos/iBotPeaches/Apktool/releases/latest | grep browser_download_url | cut -d '"' -f 4 | $SUDO wget -O /usr/local/bin/apktool.jar -qi -
$SUDO chmod +r /usr/local/bin/apktool.jar

$SUDO curl -sfSL https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool -o /usr/local/bin/apktool
$SUDO chmod +x /usr/local/bin/apktool
