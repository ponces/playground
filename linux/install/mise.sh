#!/bin/bash

set -e

curl -sfSL https://mise.run | bash
$HOME/.local/bin/mise settings experimental=true
