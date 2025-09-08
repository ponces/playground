#!/bin/bash

set -e

export PATH="$HOME/.local/bin:$PATH"

mkdir -p $HOME/.local/bin
mkdir -p $HOME/.local/etc
mkdir -p $HOME/.local/share

curl -sfSL https://go.ponces.dev/piu | bash

export DEBIAN_FRONTEND=noninteractive
piu install -y autoconf automake bash binutils coreutils curl ccze diffutils dos2unix file findutils \
               gawk git jq less lsof m4 make nano sed sudo tar tree unzip vim wget xz-utils zip zsh
