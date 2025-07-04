#!/bin/bash

set -e

[ -z "$TMPDIR" ] && [ -d /tmp ] && TMPDIR="/tmp"

ANDROID_HOME="$HOME/.android/sdk"
mkdir -p $ANDROID_HOME

curl -sfSL https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -o $TMPDIR/commandlinetools-linux.zip
unzip -q $TMPDIR/commandlinetools-linux.zip -d $TMPDIR/cmdline-tools
rm -f $TMPDIR/commandlinetools-linux.zip
mv $TMPDIR/cmdline-tools/cmdline-tools $TMPDIR/cmdline-tools/latest
mv $TMPDIR/cmdline-tools $ANDROID_HOME

yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --install "build-tools;35.0.0" "cmake;3.31.1" "ndk;27.1.12297006" "platform-tools" "platforms;android-35"

curl -sfSL https://api.github.com/repos/iBotPeaches/Apktool/releases/latest | grep browser_download_url | cut -d '"' -f 4 | wget -O $HOME/.local/bin/apktool.jar -qi -
chmod +r $HOME/.local/bin/apktool.jar

curl -sfSL https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool -o $HOME/.local/bin/apktool
chmod +x $HOME/.local/bin/apktool
