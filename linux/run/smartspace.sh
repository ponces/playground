#!/bin/bash

set -e

[ -z "$TMPDIR" ] && [ -d /tmp ] && TMPDIR="/tmp"

clean() {
    rm -rf "$TMPDIR"/repo.zip
    rm -rf "$TMPDIR"/repo
}

clean
url="https://github.com/$1/$2/archive/refs/heads/$3.zip"
if [ -z "$3" ]; then
    url="https://api.github.com/repos/$1/$2/zipball"
fi
curl -sfSL "$url" -o "$TMPDIR"/repo.zip
unzip -q "$TMPDIR"/repo.zip -d "$TMPDIR"/repo

cp -r "$TMPDIR"/repo/*/Android.bp ./packages/SystemUI/bcsmartspace/Android.bp
cp -r "$TMPDIR"/repo/*/AndroidManifest.xml ./packages/SystemUI/bcsmartspace/AndroidManifest.xml
cp -r "$TMPDIR"/repo/*/proto/* ./packages/SystemUI/proto/
cp -r "$TMPDIR"/repo/*/res/* ./packages/SystemUI/bcsmartspace/res/
cp -r "$TMPDIR"/repo/*/src/* ./packages/SystemUI/src/

clean
