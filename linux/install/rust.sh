#!/bin/bash

set -e

curl -sfSL https://sh.rustup.rs | sh -s -- -y
. "$HOME/.cargo/env"
rustup default stable
rustup target add aarch64-linux-android
cargo install cargo-ndk
