#!/bin/bash

set -e

if [ -z "$TERMUX_VERSION" ]; then
    curl -sfSL https://mise.run | bash
    $HOME/.local/bin/mise settings experimental=true
else
    curl https://mise.jdx.dev/mise-latest-linux-arm64-musl > $HOME/.local/bin/mise
    chmod +x $HOME/.local/bin/mise
    pushd $PREFIX/etc/tls 1>/dev/null
    mkdir -p certs
    ln -s cert.pem certs.pem
    ln -s cert.pem certs/ca-certificates.crt
    popd 1>/dev/null
fi
