set positional-arguments
set shell := ["bash", "-cue"]
root_dir := justfile_directory()

# Enter a `nix` development shell.
nix-develop:
    nix develop ./nix#default

# Init reveal.js into build folder.
init:
    #!/usr/bin/env bash
    set -eu
    rsync -avv "{{root_dir}}/external/reveal.js/" "{{root_dir}}/build/"
    rsync -avv "{{root_dir}}/src/mixing/" "{{root_dir}}/build/"
    ln -fs "{{root_dir}}/src/export" "{{root_dir}}/build/export"
    ln -fs "{{root_dir}}/src/files" "{{root_dir}}/build/files"
    ln -fs "{{root_dir}}/src/index.html" "{{root_dir}}/build/index.html"


# Install all stuff.
install:
    npm install

# Build all stuff.
# When you changes styles and
# themes you need to run this.
build:
    npm run build

# Present the presentation.
present:
    npm run present

# Package the presentation.
package:
    npm run package

# Bake the logo into the style-sheets.
bake-logo mime="svg":
  cd "{{root_dir}}" && \
  	tools/bake-logo.sh "{{mime}}"
