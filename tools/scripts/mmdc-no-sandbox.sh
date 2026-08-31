#!/usr/bin/env bash
# Wrapper around `mmdc` (mermaid-cli) that disables Chromium's setuid
# sandbox. On non-NixOS systems the sandbox helper shipped by the
# nixpkgs chromium/mermaid-cli derivation isn't installed setuid-root,
# which makes puppeteer's launch abort. Picked up automatically by
# `external/pandoc-diagram`'s diagram.lua via the `MERMAID_BIN` env var.
set -eu

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
puppeteer_config="$script_dir/../pandoc/puppeteer-config.json"

exec mmdc --puppeteerConfigFile "$puppeteer_config" "$@"
