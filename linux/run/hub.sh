#!/bin/bash

set -e

key="$(curl -sfSL https://tryigit.dev/keybox/download.php\?id=random_strong)"

if [ -z "$key" ]; then
    echo "Keybox download failed. Exiting..."
    exit 1
fi

echo "$key"
