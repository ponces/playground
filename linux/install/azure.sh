#!/bin/bash

set -e

[ -z "$TMPDIR" ] && [ -d /tmp ] && TMPDIR="/tmp"

export PATH="$HOME/.local/bin:$PATH"

if [ ! -z "$TERMUX_VERSION" ]; then
    pip install --user virtualenv
    virtualenv $HOME/.local/lib/azure-cli
    pushd $HOME/.local/lib/azure-cli >/dev/null
    source ./bin/activate
    pip install cffi
    pip install azure-cli
    pip freeze > requirements.txt
    popd >/dev/null
else
    pipx install azure-cli
fi

az config set core.only_show_errors=yes
az config set extension.dynamic_install_allow_preview=true
az config set extension.use_dynamic_install=yes_without_prompt
az extension add --name azure-devops

mkdir -p $HOME/.local/share/azure-cli
cp -f $(python3 -c "import certifi; print(certifi.where())") "$HOME/.local/share/azure-cli/ca-certificates.crt"
curl -sfSL https://dev.criticalmanufacturing.io/repository/http/product/cmfca.pem >> "$HOME/.local/share/azure-cli/ca-certificates.crt"
