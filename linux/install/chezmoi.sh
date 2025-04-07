#!/bin/bash

set -e

curl -sfSL https://get.chezmoi.io | bash -s -- -b $HOME/.local/bin
$HOME/.local/bin/chezmoi init --apply ponces
