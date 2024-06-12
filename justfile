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
    cd "{{root_dir}}"
    rm -rf "build"
    mkdir -p "build"

    echo "Init pinned reveal.js folder to 'build'..."
    rsync -avv "external/reveal.js/" "build/"

    just sync

    echo "Install node packages in 'build' ..."
    (cd build && yarn install)

[private]
sync:
    #!/usr/bin/env bash
    set -eu
    cd "{{root_dir}}"

    sync() {
      rsync --checksum -avv "$@"
    }

    echo "Add additional 'npm' scripts."
    jq -s '.[0] *= .[1] | .[0]' external/reveal.js/package.json src/package.json > build/package.json

    # Cannot use symlink because `serve` does not like it.
    echo "Add additional files (styles, themes, etc.) ..."
    sync src/export/ build/export/
    sync src/files/ build/files/
    sync src/mixing/ build/
    sync src/index.html build/index.html

watch:
    #!/usr/bin/env bash
    set -eu
    cd "{{root_dir}}"

    EVENTS="CREATE,DELETE,MODIFY,MOVED_FROM,MOVED_TO"
    watch() {
      inotifywait -e "$EVENTS" -m -r --format '%:e %f' "$1"
    }

    watch src | (
        while true ; do
          read -t 1 LINE &&
            just sync
        done
    )

clean:
    cd "{{root_dir}}" && rm -rf build && mkdir -p build && \

# Present the presentation.
present:
    cd "{{root_dir}}/build" && npm run present

# Package the presentation.
package:
    cd "{{root_dir}}/build" && npm run package

# Bake the logo into the style-sheets.
bake-logo mime="svg":
  cd "{{root_dir}}" && \
  	tools/bake-logo.sh "{{mime}}"
