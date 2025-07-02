#!/bin/bash

set -e

[ -z "$TMPDIR" ] && [ -d /tmp ] && TMPDIR="/tmp"

branch="$1"

if [ -z "$branch" ]; then
    echo "Provide a valid AOSP branch! Exiting..."
    exit 1
fi

if [ ! -f ponces_gsi_arm64.mk ] || [ ! -d bluetooth ]; then
    echo "Make sure you are at the root of the device repo! Exiting..."
    exit 2
fi

rm -rf $TMPDIR/interfaces
rm -rf $TMPDIR/bluetooth

git clone -q --depth=1 -b "$branch" https://android.googlesource.com/platform/hardware/interfaces $TMPDIR/interfaces
git clone -q --depth=1 -b "$branch" https://android.googlesource.com/platform/packages/modules/Bluetooth $TMPDIR/bluetooth

rm -rf bluetooth/audio/utils
cp -r $TMPDIR/interfaces/bluetooth/audio/utils bluetooth/audio/utils

rm -rf bluetooth/audio/hal
cp -r $TMPDIR/interfaces/bluetooth/audio/aidl/default bluetooth/audio/hal

rm -rf bluetooth/audio/hw
cp -r $TMPDIR/bluetooth/system/audio_bluetooth_hw bluetooth/audio/hw

rm -f bluetooth/audio/hal/bluetooth_audio.xml
git checkout bluetooth/audio/hal/bluetooth_audio_system.xml

rm -f bluetooth/audio/hal/service.cpp
git checkout bluetooth/audio/hal/service_system.cpp

git checkout bluetooth/audio/hal/android.hardware.bluetooth.audio-service-system.rc

sed -i 's|"/default"|"/sysbta"|g' bluetooth/audio/utils/aidl_session/BluetoothAudioSession.h
sed -i 's|#include <com_android_btaudio_hal_flags.h>|//#include <com_android_btaudio_hal_flags.h>|g' bluetooth/audio/utils/aidl_session/BluetoothAudioSession.cpp
sed -i 's|if (com::android::btaudio::hal::flags::|//if (com::android::btaudio::hal::flags::|g' bluetooth/audio/utils/aidl_session/BluetoothAudioSession.cpp

rm -rf $TMPDIR/interfaces
rm -rf $TMPDIR/bluetooth
