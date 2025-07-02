#!/bin/bash

set -e

run() {
    pushd "$1" 1>/dev/null
    docker compose up --detach
    popd 1>/dev/null
}

run traefik
run filebrowser
run github-runner
#run ollama
run portainer
#run technitium
#run wg-easy
