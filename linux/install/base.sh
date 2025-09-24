#!/bin/bash

set -e

export PATH="$HOME/.local/bin:$PATH"

mkdir -p $HOME/.cache
mkdir -p $HOME/.config
mkdir -p $HOME/.local/bin
mkdir -p $HOME/.local/etc
mkdir -p $HOME/.local/lib
mkdir -p $HOME/.local/lib64
mkdir -p $HOME/.local/run
mkdir -p $HOME/.local/share

curl -sfSL https://go.ponces.dev/piu | bash

export DEBIAN_FRONTEND=noninteractive
piu install -y autoconf automake bash binutils coreutils curl diffutils dos2unix file findutils gawk \
               git jq less lsof m4 make nano sed sudo tar tree unzip vim wget xz-utils zip zsh

curl -sfSL https://go.ponces.dev/logalize | bash
