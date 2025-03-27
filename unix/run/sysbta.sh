#!/bin/bash

set -e

branch="$1"

if [ -z "$branch" ]; then
    echo "Provide a valid AOSP branch! Exiting..."
    exit 1
fi

if [ ! -f ponces_gsi_arm64.mk ] || [ ! -d bluetooth ]; then
    echo "Make sure you are at the root of the device repo! Exiting..."
    exit 2
fi

rm -rf /tmp/interfaces
rm -rf /tmp/bluetooth

git clone -q https://android.googlesource.com/platform/hardware/interfaces -b "$branch" --depth 1 /tmp/interfaces
git clone -q https://android.googlesource.com/platform/packages/modules/Bluetooth -b "$branch" --depth 1 /tmp/bluetooth

rm -rf bluetooth/audio/utils
cp -r /tmp/interfaces/bluetooth/audio/utils bluetooth/audio/utils

rm -rf bluetooth/audio/hal
cp -r /tmp/interfaces/bluetooth/audio/aidl/default bluetooth/audio/hal

rm -rf bluetooth/audio/hw
cp -r /tmp/bluetooth/system/audio_bluetooth_hw bluetooth/audio/hw

rm -f bluetooth/audio/hal/bluetooth_audio.xml
git checkout bluetooth/audio/hal/bluetooth_audio_system.xml

rm -f bluetooth/audio/hal/service.cpp
git checkout bluetooth/audio/hal/service_system.cpp

git checkout bluetooth/audio/hal/android.hardware.bluetooth.audio-service-system.rc

sed -i 's|"/default"|"/sysbta"|g' bluetooth/audio/utils/aidl_session/BluetoothAudioSession.h
sed -i 's|#include <com_android_btaudio_hal_flags.h>|//#include <com_android_btaudio_hal_flags.h>|g' bluetooth/audio/utils/aidl_session/BluetoothAudioSession.cpp
sed -i 's|if (com::android::btaudio::hal::flags::|//if (com::android::btaudio::hal::flags::|g' bluetooth/audio/utils/aidl_session/BluetoothAudioSession.cpp

rm -rf /tmp/interfaces
rm -rf /tmp/bluetooth
