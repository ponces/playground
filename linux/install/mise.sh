#!/bin/bash

set -e

export PATH="$HOME/.local/bin:$PATH"

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
fi

mise settings experimental=true
mise settings add idiomatic_version_file_enable_tools "[]"

if [ ! -z "$WSL_DISTRO_NAME" ]; then
    WIN_HOME=$(wslpath -u "$(wslvar USERPROFILE)")
    if [ ! -z "$WIN_HOME" ]; then
        mise trust --ignore "$WIN_HOME"
    fi
fi
