#!/bin/bash

set -e

if [ ! -z "$TERMUX_VERSION" ]; then
    curl -sfSL https://mise.jdx.dev/mise-latest-linux-arm64-musl -o $HOME/.local/bin/mise
    chmod +x $HOME/.local/bin/mise
    pushd $PREFIX/etc/tls >/dev/null
    mkdir -p certs
    ln -s cert.pem certs.pem
    ln -s cert.pem certs/ca-certificates.crt
    popd >/dev/null
else
    curl -sfSL https://mise.run | bash
    $HOME/.local/bin/mise settings experimental=true
fi
