#!/bin/bash

set -e

curl -sfSL https://raw.githubusercontent.com/aquaproj/aqua-installer/v3.1.1/aqua-installer | bash

mkdir -p $HOME/.config/aquaproj-aqua
echo 'export AQUA_ROOT_DIR="$HOME/.local/share/aquaproj-aqua"' >> $HOME/.bashrc
echo 'export AQUA_CONFIG_DIR="$HOME/.config/aquaproj-aqua"' >> $HOME/.bashrc
echo 'export AQUA_GLOBAL_CONFIG="$AQUA_CONFIG_DIR/aqua.yaml"' >> $HOME/.bashrc
echo 'export PATH=$AQUA_ROOT_DIR/bin:$PATH' >> $HOME/.bashrc
