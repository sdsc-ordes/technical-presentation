set positional-arguments
set shell := ["bash", "-cue"]
set dotenv-load := true
root_dir := justfile_directory()
flake_dir := root_dir / "tools/nix"

# General Variables:
# You can chose either "podman" or "docker"
container_mgr := env("CONTAINER_MGR", "podman")

# The presentation to render.
presentation := env("PRESENTATION", "presentation-1")

# Enter a `nix` development shell.
nix-develop:
    nix develop --accept-flake-config --no-pure-eval './tools/nix#default'

# Format the project.
format *args:
    nix run --accept-flake-config {{flake_dir}}#treefmt -- "$@"

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

    just presentation="{{presentation}}" pandoc


# Watch the files in `src` and synchronize them into the `build` folder.
watch:
    #!/usr/bin/env bash
    set -eu
    cd "{{root_dir}}"

    watch() {
      echo "Starting watchman ..."
      watchman-wait -m 0 -t 0 "$@"
    }

    checksum_dir=build/.checksums
    mkdir -p "$checksum_dir"

    watch src tools | (
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
        just presentation="{{presentation}}" pandoc
      done
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
    "{{root_dir}}/tools/scripts/package-presentation.sh" "{{container_mgr}}" "{{file}}"

# Prepare a folder `name` to make later a PR to branch `publish` to serve your presentation.
publish name:
    "{{root_dir}}/tools/scripts/prepare-gh-pages.sh" "{{name}}" "{{presentation}}"

# Bake the logo into the style-sheets.
bake-logo mime="svg":
    cd "{{root_dir}}" && \
      tools/scripts/bake-logo.sh "{{mime}}"

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


pandoc:
    #!/usr/bin/env bash
    set -eu

    root_dir="{{root_dir}}"
    build_dir="$root_dir/build"
    presentation="{{presentation}}"
    presentation_dir_rel="presentations/$presentation"
    presentation_dir="$root_dir/build/$presentation_dir_rel"
    image_convert_dir="$presentation_dir_rel/assets/images/convert"
    lua_path="$(pwd)/tools/pandoc/lua/?.lua;;"
    data_dir="$(pwd)/tools/pandoc"

    # Execute pandoc in folder where the presentation should be built is.
    cd "$build_dir" &&
    LUA_PATH="$lua_path" \
    PRESENTATION_ROOT="$presentation_dir" \
    IMAGE_CONVERT_ROOT="$image_convert_dir" \
    BUILD_ROOT="$build_dir" \
      pandoc \
         --data-dir="$data_dir" \
         --defaults=pandoc-dirs.yaml \
         --defaults=pandoc-general.yaml \
         --defaults=pandoc-revealjs.yaml \
         --defaults=pandoc-filters.yaml \
         -o "$root_dir/build/index.html" \
         "$presentation_dir/main.md" &&
      echo "Pandoc converted successfully." || {
      echo "Pandoc failed!"
    }
