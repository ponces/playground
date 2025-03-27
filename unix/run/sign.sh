#!/bin/bash

set -e

git clone https://github.com/TrebleDroid/treble_app --depth 1
git clone ssh://git@github.com/ponces/vendor_ponces-priv --depth 1

find . -name "*.apk" | while read file; do
    LD_LIBRARY_PATH="./treble_app/signapk" java -jar "./treble_app/signapk/signapk.jar" "./vendor_ponces-priv/keys/platform.x509.pem" "./vendor_ponces-priv/keys/platform.pk8" "$file" "${file%.*}"-signed.apk
done

rm -rf treble_app
rm -rf vendor_ponces-priv
