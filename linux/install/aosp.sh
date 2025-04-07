#!/bin/bash

set -e

[ "$(id -u)" -ne 0 ] && SUDO="sudo" || SUDO=""

curl -sfSL https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | $SUDO bash

$SUDO apt update
$SUDO apt install -y aapt bc bison build-essential ca-certificates curl flex fontconfig g++-multilib gcc-multilib \
                     git git-lfs gnupg gperf imagemagick jq lib32z1-dev libc6-dev-i386 libelf-dev libgl1-mesa-dev \
                     libncurses-dev libssl-dev libstdc++6 libx11-dev libxml2-utils locales lunzip lzip lzop m4 \
                     make pipx python-is-python3 python3-pip squashfs-tools unzip wget x11proto-core-dev xattr \
                     xmlstarlet xsltproc zip zlib1g zlib1g-dev

$SUDO curl -sfSL https://storage.googleapis.com/git-repo-downloads/repo -o /usr/local/bin/repo
$SUDO chmod +x /usr/local/bin/repo

git lfs install
