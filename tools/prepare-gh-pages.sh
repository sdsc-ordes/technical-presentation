#!/usr/bin/env bash
# shellcheck disable=SC1090,SC1091
set -e
set -u

ROOT_DIR=$(git rev-parse --show-toplevel)

cd "$ROOT_DIR"
just init
just sync
rm -rf build/node_modules
rm -rf docs/
cp build docs
