#!/bin/bash

set -e

[ -z "$TMPDIR" ] && [ -d /tmp ] && TMPDIR="/tmp"

if [ -f "$1" ]; then
    downFile="$1"
elif [ "$#" -eq 1 ]; then
    curl -sfSL https://go.ponces.dev/apkeep | bash -s -- "$1"
    downFile="$(ls -Art | tail -n 1)"
else
    curl -sfSL https://go.ponces.dev/apkmd | bash -s -- "$1" "$2" "$3"
    downFile="$(ls -Art | tail -n 1)"
fi

if [[ "$downFile" == *".apk" ]]; then
    exit 0
elif [[ "$downFile" == *".apkm" ]] || [[ "$downFile" == *".xapk" ]]; then
        curl -sfSL https://api.github.com/repos/REAndroid/APKEditor/releases | \
                jq -r '.[0].assets[] | .browser_download_url | select(endswith(".jar"))' | \
                wget -q -i - -O $TMPDIR/apkeditor.jar
        java -jar $TMPDIR/apkeditor.jar m -i "$downFile" -o $TMPDIR/tmp.apk
        downFile="${downFile%.*}.apk"
        mv $TMPDIR/tmp.apk "$downFile"

        curl -sfSL https://go.ponces.dev/keystore -o $TMPDIR/debug.keystore
        apksigner sign --ks $TMPDIR/debug.keystore --ks-pass pass:android "$downFile"
else
    echo "No valid APK file found."
    exit 1
fi

rm -f $TMPDIR/apkeditor.jar
rm -f $TMPDIR/debug.keystore
