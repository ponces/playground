#!/bin/bash

set -e

keybox="$1"

if [ -z "$keybox" ]; then
    keybox="blackbox"
fi

random() {
    chars="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    length=${1:-8}
    result=""

    while [ "${#result}" -lt "$length" ]; do
        rand=$(od -An -N1 -tu1 /dev/urandom | tr -d ' ')
        result="$result$(echo "$chars" | cut -c $((rand % ${#chars} + 1)))"
    done

    echo "$result"
}

key="$(curl -sfSL https://github.com/Citra-Standalone/Citra-Standalone/raw/refs/heads/main/zipball/$keybox.tar | base64 -d)"

if [ -z "$key" ]; then
    echo "Keybox download failed. Exiting..."
    exit 1
fi

ID="$(echo "$key" | grep '^ID=' | cut -d'=' -f2-)"
TYPE="$(echo "$key" | grep '^TYPE=' | cut -d'=' -f2-)"
ecdsa_key="$(echo "$key" | sed -n '/<Key algorithm="ecdsa">/,/<\/Key>/p')"
rsa_key="$(echo "$key" | sed -n '/<Key algorithm="rsa">/,/<\/Key>/p')"

if [ -z "$ID" ] || [ -z "$TYPE" ] || [ -z "$ecdsa_key" ] || [ -z "$rsa_key" ]; then
    echo "Invalid keybox! Exiting..."
    exit 2
fi

if echo "$ID" | grep -qi "Hardware Attestation"; then
    ID="HW"
else
    ID="SW"
fi

xml="<?xml version=\"1.0\"?>
<AndroidAttestation>
<NumberOfKeyboxes>1</NumberOfKeyboxes>
<Keybox DeviceID=\"${ID}_$(random)\">
$ecdsa_key
$rsa_key
</Keybox>
</AndroidAttestation>"

echo "$xml" | xmlstarlet format --indent-tab
