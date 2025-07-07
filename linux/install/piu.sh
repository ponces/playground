#!/bin/bash

set -e

curl -sfSL https://raw.githubusercontent.com/ponces/piu/master/piu -o $HOME/.local/bin/piu
chmod +x $HOME/.local/bin/piu
