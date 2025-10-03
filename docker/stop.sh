#!/bin/bash

set -e

stop() {
    pushd "$1" 1>/dev/null
    docker compose stop
    popd 1>/dev/null
}

stop filebrowser
# stop gitea
stop github-runner
# stop linux
# stop macos
# stop ollama
stop portainer
stop registry
# stop technitium
stop verdaccio
# stop wg-easy
# stop windows

stop traefik
