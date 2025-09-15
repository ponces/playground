#!/bin/bash

set -e

[ -z "$TMPDIR" ] && [ -d /tmp ] && TMPDIR="/tmp"

installEmulator="$1"

ANDROID_HOME="$HOME/.android/sdk"
ANDROID_AVD_HOME="$HOME/.android/avd"

mkdir -p $ANDROID_HOME

curl -sfSL https://dl.google.com/android/repository/commandlinetools-linux-13114758_latest.zip -o $TMPDIR/sdk.zip
unzip -q $TMPDIR/sdk.zip -d $TMPDIR/cmdline-tools
rm -f $TMPDIR/sdk.zip
mv $TMPDIR/cmdline-tools/cmdline-tools $TMPDIR/cmdline-tools/latest
cp -r $TMPDIR/cmdline-tools $ANDROID_HOME

rm -rf $TMPDIR/cmdline-tools

yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --install "build-tools;36.0.0" \
                                                                  "cmake;4.1.1" \
                                                                  "ndk;28.2.13676358" \
                                                                  "platform-tools" \
                                                                  "platforms;android-36"

if [ ! -z "$installEmulator" ]; then
    yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --install "emulator" \
                                                                      "system-images;android-36;google_apis;x86_64"
    $ANDROID_HOME/cmdline-tools/latest/bin/avdmanager create avd --force --name "Pixel9" \
                                                                         --device "pixel_9" --abi "google_apis/x86_64" \
                                                                         --package "system-images;android-36;google_apis;x86_64"
fi

yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --licenses

url=$(curl -sfSL https://api.github.com/repos/iBotPeaches/Apktool/releases/latest | \
        jq -r ".assets[] | \
            select(.name | endswith(\".jar\")) | \
            .browser_download_url" | \
        head -1)
curl -sfSL "$url" -o $HOME/.local/bin/apktool.jar
chmod +r $HOME/.local/bin/apktool.jar

curl -sfSL https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool -o $HOME/.local/bin/apktool
chmod +x $HOME/.local/bin/apktool
