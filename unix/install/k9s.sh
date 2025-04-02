#!/bin/bash

set -e

[ "$(id -u)" -ne 0 ] && SUDO="sudo" || SUDO=""

curl -sfL https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_amd64.tar.gz -o /tmp/k9s.tar.gz
tar -zxf /tmp/k9s.tar.gz k9s
$SUDO mv k9s /usr/local/bin/
rm -f /tmp/k9s.tar.gz
