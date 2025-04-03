#!/bin/bash

set -e

[ -z $TMPDIR ] && [ -d /tmp ] && TMPDIR="/tmp"

curl -sfL https://go.ponces.xyz/apkmd | bash -s -- "$1" "$2"
downFile="$(ls -Art | tail -n 1)"

curl -sfL https://api.github.com/repos/REAndroid/APKEditor/releases | \
        jq -r '.[0].assets[] | .browser_download_url | select(endswith(".jar"))' | \
        wget -q -i - -O $TMPDIR/apkeditor.jar
java -jar $TMPDIR/apkeditor.jar m -i "$downFile"

curl -sfL https://go.ponces.xyz/keystore -o $TMPDIR/debug.keystore
apksigner sign --ks $TMPDIR/debug.keystore --ks-pass pass:android "$downFile"
