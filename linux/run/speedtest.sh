#!/bin/bash

set -e

comm="python"
if ! command -v python &> /dev/null; then
    comm="python3"
fi

curl -sfSL https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | "$comm" -
