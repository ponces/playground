#!/bin/bash

set -e

if [ $# -lt 2 ]; then
    echo "Usage: $0 <org> <id> [<version>]"
    exit 1
fi

curl -sfL https://github.com/tanishqmanuja/apkmirror-downloader/releases/latest/download/apkmd -o /tmp/apkmd
chmod +x /tmp/apkmd

if [ ! -z "$3" ]; then
    additional="--version $3"
fi

eval /tmp/apkmd download "$1" "$2" "$additional" --arch "arm64-v8a" 2>&1 | tee /tmp/apkmd.log
if grep -q -e Unable -e Error /tmp/apkmd.log; then
    eval /tmp/apkmd download "$1" "$2" "$additional" --arch "universal" 2>&1 | tee /tmp/apkmd.log
fi
if grep -q -e Unable -e Error /tmp/apkmd.log; then
    eval /tmp/apkmd download "$1" "$2" "$additional" --arch "universal" --type "bundle" --dpi "any"
fi

rm -f /tmp/apkmd
rm -f /tmp/apkmd.log
