#!/bin/bash

set -e

stop() {
    pushd "$1" 1>/dev/null
    docker compose down
    popd 1>/dev/null
}

stop traefik
stop filebrowser
stop github-runner
# stop ollama
stop portainer
# stop technitium
# stop wg-easy
# stop windows