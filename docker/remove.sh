#!/bin/bash

set -e

remove() {
    pushd "$1" 1>/dev/null
    docker compose down
    popd 1>/dev/null
}

remove filebrowser
remove gitea
remove github-runner
# remove linux
# remove macos
# remove ollama
remove portainer
# remove technitium
remove verdaccio
# remove wg-easy
# remove windows

remove traefik
