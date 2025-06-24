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
    additional="--version $3"
fi

eval $TMPDIR/apkmd download "$1" "$2" "$additional" --arch "arm64-v8a" 2>&1 | tee $TMPDIR/apkmd.log
if grep -q -e Unable -e Error $TMPDIR/apkmd.log; then
    eval $TMPDIR/apkmd download "$1" "$2" "$additional" --arch "universal" 2>&1 | tee $TMPDIR/apkmd.log
fi
if grep -q -e Unable -e Error $TMPDIR/apkmd.log; then
    eval $TMPDIR/apkmd download "$1" "$2" "$additional" --arch "universal" --type "bundle" --dpi "any"
fi

rm -f $TMPDIR/apkmd
rm -f $TMPDIR/apkmd.log
