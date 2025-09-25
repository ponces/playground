#!/bin/bash

set -e

export PATH="$HOME/.local/bin:$PATH"

curl -sfSL https://get.chezmoi.io | bash -s -- -b $HOME/.local/bin
chezmoi init --apply ponces --promptDefaults
