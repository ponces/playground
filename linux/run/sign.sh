#!/bin/bash

set -e

[ -z $TMPDIR ] && [ -d /tmp ] && TMPDIR="/tmp"

git clone -q --depth=1 https://github.com/TrebleDroid/treble_app $TMPDIR/treble_app
git clone -q --depth=1 ssh://git@github.com/ponces/vendor_ponces-priv $TMPDIR/vendor_ponces-priv

find . -name "*.apk" | while read file; do
    LD_LIBRARY_PATH="$TMPDIR/treble_app/signapk" java -jar "$TMPDIR/treble_app/signapk/signapk.jar" "$TMPDIR/vendor_ponces-priv/keys/platform.x509.pem" "$TMPDIR/vendor_ponces-priv/keys/platform.pk8" "$file" "${file%.*}"-signed.apk
done

rm -rf $TMPDIR/treble_app
rm -rf $TMPDIR/vendor_ponces-priv
