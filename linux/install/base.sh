#!/bin/bash

set -e

export PATH="$HOME/.local/bin:$PATH"

mkdir -p $HOME/.local/bin
mkdir -p $HOME/.local/etc
mkdir -p $HOME/.local/share

curl -sfSL https://go.ponces.dev/piu | bash

export DEBIAN_FRONTEND=noninteractive
piu install -y bash binutils coreutils curl ccze dos2unix file git jq less make nano sudo tar tree unzip wget zip zsh

if [ ! -z "$TERMUX_VERSION" ]; then
    piu install -y which
fi
