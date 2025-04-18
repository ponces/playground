#!/bin/bash

set -e

rm -rf patches patches.zip

manifest_url="https://android.googlesource.com/platform/manifest"
aosp="android-15.0.0_r21"
td="android-15.0"

repo init -u "$manifest_url" -b $aosp

if [ -d .repo/local_manifests ]; then
    (cd .repo/local_manifests; git fetch; git reset --hard; git checkout origin/$td)
else
    git clone -q -b $td https://github.com/TrebleDroid/treble_manifest .repo/local_manifests
fi

repo sync -c --force-sync --no-clone-bundle --no-tags -j$(nproc --all) || repo sync -c --force-sync --no-clone-bundle --no-tags -j$(nproc --all)

wget -q https://github.com/TrebleDroid/treble_experimentations/raw/master/list-patches.sh -O list-patches.sh
bash list-patches.sh
