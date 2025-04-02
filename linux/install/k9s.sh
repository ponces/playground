#!/bin/bash

set -e

[ "$(id -u)" -ne 0 ] && SUDO="sudo" || SUDO=""

[ -z $TMPDIR ] && [ -d /tmp ] && TMPDIR="/tmp"

curl -sfL https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_amd64.tar.gz -o $TMPDIR/k9s.tar.gz
tar -zxf $TMPDIR/k9s.tar.gz k9s
rm -f $TMPDIR/k9s.tar.gz

$SUDO mv k9s /usr/local/bin
$SUDO chmod +x /usr/local/bin/k9s
