#!/bin/bash

set -e

curl -sfSL https://mise.run | bash

echo 'eval "$($HOME/.local/bin/mise activate bash)"' >> $HOME/.bashrc
echo 'eval "$($HOME/.local/bin/mise activate bash)"' >> $HOME/.bash_profile
