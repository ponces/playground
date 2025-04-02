#!/bin/bash

set -e

echo '. "$HOME/.cargo/env"' >> $HOME/.bash_profile

curl -sfL https://sh.rustup.rs | sh -s -- -y
. "$HOME/.cargo/env"
rustup default stable
rustup target add aarch64-linux-android
cargo install cargo-ndk
