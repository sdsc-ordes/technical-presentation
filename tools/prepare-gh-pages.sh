#!/usr/bin/env bash
# shellcheck disable=SC1090,SC1091
set -e
set -u

ROOT_DIR=$(git rev-parse --show-toplevel)

name="${1:-demo}"
presentation="${2:-presentation-1}"
pages_dir="docs/gh-pages"
target="$pages_dir/$name"

cd "$ROOT_DIR"
just init
just sync "$presentation"

rm -rf build/node_modules
rm -rf "$target" || true
mkdir -p ""
cp build "$target"

echo "Create a PR to branch 'publish' to merge only changes in '$pages_dir'."
