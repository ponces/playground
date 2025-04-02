#!/bin/bash

set -e

curl -sfL https://gist.github.com/ponces/530da4ddaebef8ec3a6840ad9fe6be00/raw/apkmd.sh | bash -s -- "$1" "$2"
downFile="$(ls -Art | tail -n 1)"

curl -sfL https://api.github.com/repos/REAndroid/APKEditor/releases | \
        jq -r '.[0].assets[] | .browser_download_url | select(endswith(".jar"))' | \
        wget -q -i - -O /tmp/apkeditor.jar
java -jar /tmp/apkeditor.jar m -i "$downFile"

curl -sfL https://github.com/ponces/revanced/blob/main/debug.keystore -o /tmp/debug.keystore
apksigner sign --ks /tmp/debug.keystore --ks-pass pass:android "$downFile"
