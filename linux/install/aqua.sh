#!/bin/bash

set -e

curl -sfSL https://raw.githubusercontent.com/aquaproj/aqua-installer/v3.1.1/aqua-installer | bash
mkdir -p $HOME/.config/aquaproj-aqua
