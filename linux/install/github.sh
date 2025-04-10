#!/bin/bash

set -e

[ -z $TMPDIR ] && [ -d /tmp ] && TMPDIR="/tmp"

link=$(curl -sfSL "https://api.github.com/repos/cli/cli/releases/latest" | \
            jq -r ".assets[] | \
                select(.name | endswith(\"_linux_amd64.tar.gz\")) | \
                .browser_download_url" | \
            head -1)
curl -sfSL "$link" -o $TMPDIR/github.tar.gz

tar -xzf $TMPDIR/github.tar.gz -C $HOME/.local --strip-components=1
rm -f $TMPDIR/github.tar.gz
rm -f $HOME/.local/LICENSE
