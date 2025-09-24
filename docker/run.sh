#!/bin/bash

set -e

run() {
    pushd "$1" >/dev/null
    docker compose up --detach
    popd >/dev/null
}

run traefik

run filebrowser
run github-runner
# run linux
# run macos
# run ollama
run portainer
# run technitium
run verdaccio
# run wg-easy
# run windows
