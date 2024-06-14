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
    rsync -avv "external/reveal.js/" "build/"

    just sync

    echo "Install node packages in 'build' ..."
    (cd build && yarn install)

# Watch the files in `src` and synchronize them into the `build` folder.
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
      rsync --checksum -avv "$@"
    }

    echo "Add additional 'npm' scripts."
    jq -s '.[0] *= .[1] | .[0]' external/reveal.js/package.json src/package.json > build/package.json

    # Cannot use symlink because `serve` does not like it.
    echo "Add additional files (styles, themes, etc.) ..."
    sync src/presentations/ build/presentations/
    sync src/mixing/ build/
    sync src/index.html build/index.html
