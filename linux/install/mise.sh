#!/bin/bash

set -e

curl -sfSL https://mise.run | bash
mise settings experimental=true
