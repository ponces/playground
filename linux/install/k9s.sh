#!/bin/bash

set -e

[ -z $TMPDIR ] && [ -d /tmp ] && TMPDIR="/tmp"

curl -sfSL https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_amd64.tar.gz -o $TMPDIR/k9s.tar.gz
tar -zxf $TMPDIR/k9s.tar.gz k9s
rm -f $TMPDIR/k9s.tar.gz

cp -f k9s $HOME/.local/bin/k9s
chmod +x $HOME/.local/bin/k9s
