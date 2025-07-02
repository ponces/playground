#!/bin/bash

set -e

[ -z "$TMPDIR" ] && [ -d /tmp ] && TMPDIR="/tmp"

pipx install azure-cli

az config set core.only_show_errors=yes
az config set extension.dynamic_install_allow_preview=true
az config set extension.use_dynamic_install=yes_without_prompt
az extension add --name azure-devops

if [ -f "/usr/local/share/ca-certificates/cmfca.crt" ]; then
    mkdir -p $HOME/.local/share/azure-cli
    cp -f $(python3 -c "import certifi; print(certifi.where())") "$HOME/.local/share/azure-cli/ca-certificates.crt"
    cat /usr/local/share/ca-certificates/cmfca.crt >> "$HOME/.local/share/azure-cli/ca-certificates.crt"
fi
