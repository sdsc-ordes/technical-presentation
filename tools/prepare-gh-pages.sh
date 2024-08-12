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
just presentation="$presentation" init sync pandoc

rm -rf build/node_modules build/presentations
rm -rf "$target" || true
mkdir -p "$pages_dir"
cp -r build "$target"

echo "Create a PR to branch 'publish' to merge only THE changes in '$pages_dir'."
echo "Execute 'git add -f '$target' to add the files."
