#!/bin/bash

set -e

[ -z "$TMPDIR" ] && [ -d /tmp ] && TMPDIR="/tmp"

if [ $# -lt 2 ]; then
    echo "Usage: $0 <org> <id> [<version>]"
    exit 1
fi

curl -sfSL https://github.com/tanishqmanuja/apkmirror-downloader/releases/latest/download/apkmd -o $TMPDIR/apkmd
chmod +x $TMPDIR/apkmd

if [ ! -z "$3" ]; then
    version="$3"
else
    version="stable"
fi

eval $TMPDIR/apkmd download "$1" "$2" --version "$version" --arch "arm64-v8a" --type "apk" --dpi "nodpi" 2>&1 | tee $TMPDIR/apkmd.log
if grep -q -e Unable -e Error $TMPDIR/apkmd.log; then
    eval $TMPDIR/apkmd download "$1" "$2" --version "$version" --arch "universal" --type "apk" --dpi "nodpi" 2>&1 | tee $TMPDIR/apkmd.log
fi
if grep -q -e Unable -e Error $TMPDIR/apkmd.log; then
    eval $TMPDIR/apkmd download "$1" "$2" --version "$version" --arch "arm64-v8a + armeabi-v7a" --type "bundle" --dpi "nodpi" 2>&1 | tee $TMPDIR/apkmd.log
fi
if grep -q -e Unable -e Error $TMPDIR/apkmd.log; then
    eval $TMPDIR/apkmd download "$1" "$2" --version "$version" --arch "universal" --type "bundle" --dpi "any"
fi

rm -f $TMPDIR/apkmd
rm -f $TMPDIR/apkmd.log
