#!/bin/bash

key="$(curl -sfL https://raw.githubusercontent.com/KOWX712/Tricky-Addon-Update-Target-List/main/.extra | xxd -r -p | base64 -d)"

if [ -z "$key" ]; then
    echo "Keybox download failed. Exiting..."
    exit 1
fi

echo "$key"
