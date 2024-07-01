set positional-arguments
set shell := ["bash", "-cue"]
root_dir := justfile_directory()

# General Variables:
# You can chose either "podman" or "docker"
container_mgr := "podman"

# Enter a `nix` development shell.
nix-develop:
    nix develop ./nix#default

# Clean the build folder.
clean:
    cd "{{root_dir}}" && \
      rm -rf build && \
      mkdir -p build

# Init reveal.js into build folder.
init:
    #!/usr/bin/env bash
    set -eu
    cd "{{root_dir}}"
    rm -rf "build"
    mkdir -p "build"

    echo "Init pinned reveal.js folder to 'build'..."
    git submodule update --init
    rsync -a "external/reveal.js/" "build/"

    just sync

    echo "Install node packages in 'build' ..."
    (cd build && yarn install && npm run build)


# Watch the files in `src` and synchronize them into the `build` folder.
watch:
    #!/usr/bin/env bash
    set -eu
    cd "{{root_dir}}"

    watch() {
      watchman-wait -m 0 -t 0 "$1"
    }

    checksum_dir=build/.checksums
    mkdir -p "$checksum_dir"

    watch src | (
      while true; do
        read -t 1 LINE && { echo "Watchman: $LINE"; } || continue
        
        if [ ! -f "$LINE" ]; then
          continue
        fi

        # Ignore some stupid files.
        if echo "$LINE" | grep ".temp.pandoc-include"; then
          continue
        fi

        key=$(echo "$LINE" | sha1sum | cut -f 1 -d ' ')
        current_hash=$(sha1sum "$LINE" | cut -f 1 -d ' ')

        if [ -f "$checksum_dir/$key" ]; then
          if [ "$(cat "$checksum_dir/$key")" = "$current_hash" ]; then
            echo "No changes detected."
            continue
          fi
        fi

        # Store file hash.
        echo "$current_hash" > "$checksum_dir/$key"

        echo "File: '$LINE' changes"
        just sync
      done
    )
    )

# Build the presentation.
build:
    cd "{{root_dir}}/build" && \
      npm run build

# Present the presentation.
present:
    cd "{{root_dir}}/build" && \
      npm_config_container_mgr="{{container_mgr}}" \
      npm run present

# Convert the presentation to a `.pdf`.
pdf:
    cd "{{root_dir}}/build" && \
      npm_config_container_mgr="{{container_mgr}}" \
      npm run pdf

# Convert to `.pdf` and package into a `.zip` file which is standalone shareable.
package file="presentation.zip": pdf
    "{{root_dir}}/tools/package-presentation.sh" "{{container_mgr}}" "{{file}}"


# Bake the logo into the style-sheets.
bake-logo mime="svg":
  cd "{{root_dir}}" && \
  	tools/bake-logo.sh "{{mime}}"

# Build the container for `.devcontainer`.
build-dev-container *args:
  cd "{{root_dir}}" && \
    "{{container_mgr}}" build \
    --build-arg "REPOSITORY_COMMIT_SHA=$(git rev-parse --short=11 HEAD)" \
    -f nix/devcontainer/Containerfile \
    -t technical-presentation:latest \
    "$@" \
    nix/

[private]
sync:
    #!/usr/bin/env bash
    set -eu
    cd "{{root_dir}}"

    sync() {
      rsync --checksum -a "$@"
    }

    echo "Add additional 'npm' scripts."
    jq -s '.[0] *= .[1] | .[0]' external/reveal.js/package.json src/package.json > build/package.json

    # Cannot use symlink because `serve` does not like it.
    echo "Add additional files (styles, themes, etc.) ..."
    sync src/presentations/ build/presentations/
    sync src/mixin/ build/
    sync src/index.html build/index.html

    just pandoc

pandoc:
    cd "{{root_dir}}" && \
    data_dir="src/pandoc" && \
    export LUA_PATH="$(pwd)/tools/pandoc/modules/?.lua;;" && \
    pandoc \
           --data-dir="$data_dir" \
           --defaults=pandoc-dirs.yaml \
           --defaults=pandoc-general.yaml \
           --defaults=pandoc-revealjs.yaml \
           --defaults=pandoc-filters.yaml \
           -o build/index.html \
           build/presentations/presentation-1/presentation.md || true
