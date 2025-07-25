#!/bin/bash

set -e

[ -z "$TMPDIR" ] && [ -d /tmp ] && TMPDIR="/tmp"

if [ "$#" -eq 1 ]; then
    downFile="$1"
else
    curl -sfSL https://go.ponces.dev/apkmd | bash -s -- "$1" "$2" "$3"
    downFile="$(ls -Art | tail -n 1)"
fi

if [[ "$downFile" == *".apk" ]]; then
    exit 0
elif [[ "$downFile" == *".apkm" ]]; then
        curl -sfSL https://api.github.com/repos/REAndroid/APKEditor/releases | \
                jq -r '.[0].assets[] | .browser_download_url | select(endswith(".jar"))' | \
                wget -q -i - -O $TMPDIR/apkeditor.jar
        java -jar $TMPDIR/apkeditor.jar m -i "$downFile"

        curl -sfSL https://go.ponces.dev/keystore -o $TMPDIR/debug.keystore
        apksigner sign --ks $TMPDIR/debug.keystore --ks-pass pass:android "$downFile"
else
    echo "No valid APK file found."
    exit 1
fi

rm -f $TMPDIR/apkeditor.jar
rm -f $TMPDIR/debug.keystore
