#!/bin/bash

set -e

[ -z "$TMPDIR" ] && [ -d /tmp ] && TMPDIR="/tmp"
ARCH="$(uname -m)"
[ ! -z "$TERMUX_VERSION" ] && OS="linux-android" || OS="unknown-linux-gnu"

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <id> [<version>]"
    exit 1
fi

curl -sfSL "https://github.com/EFForg/apkeep/releases/latest/download/apkeep-${ARCH}-${OS}" -o $TMPDIR/apkeep
chmod +x $TMPDIR/apkeep

if [ ! -z "$2" ]; then
    version="@$2"
fi

eval $TMPDIR/apkeep --download-source "apk-pure" --app "$1$version" .
rm -f $TMPDIR/apkeep
