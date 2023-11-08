#!/usr/bin/env bash

set -ex

source "$HOME/.cargo/env"
cd "$HOME/src"
cargo build "$@"
