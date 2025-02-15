#!/usr/bin/env bash
# shellcheck disable=SC1090,SC1091
# Packages the presentation in the `build` folder into a `.zip`.
#
set -e
set -u

ROOT_DIR=$(git rev-parse --show-toplevel)
IMAGE_NAME="tech-presentation:package"
CONTAINER_MGR="podman"

function clean_up() {
    remove_container &>/dev/null || true
}

function is_inside_container() {
    [ "${CONTAINER_RUN:-}" = "true" ] || return 1
}

function build_container() {
    remove_container &>/dev/null || true
    cat <<EOF | "$CONTAINER_MGR" build -f - -t "tech-presentation:package" "$ROOT_DIR"
    FROM alpine:latest
    RUN apk add bash 7zip rsync tree git
    ADD tools/package-presentation.sh /
    RUN chmod +x /package-presentation.sh
EOF
}

function remove_container() {
    "$CONTAINER_MGR" image rm -f "$IMAGE_NAME"
}

function package() {
    local file_name="$1"

    if ! is_inside_container; then
        "$CONTAINER_MGR" run --rm \
            -v "$ROOT_DIR:/workspace" \
            -e CONTAINER_RUN=true \
            -w /workspace \
            "$IMAGE_NAME" \
            /package-presentation.sh "$@"

    else
        echo "Zipping /build ..."
        cd build

        local temp_dir
        temp="$(mktemp -d)"
        temp_dir="$temp/${file_name%.zip}"
        mkdir -p "$temp_dir" &&
            rsync -a \
                --include "index.html" \
                --include "dist/***" \
                --include "plugin/***" \
                --include "presentations/***" \
                --include "*.pdf" \
                --exclude '*' \
                "./" "$temp_dir/"

        # Copy all start scripts to the package.
        cp -rf "$ROOT_DIR/tools/export"/* "$temp_dir"

        echo "Content to zip is:"
        cd "$temp_dir"
        tree -L 1

        echo "Zipping ..."
        rm -rf "/workspace/publish/$file_name" || true
        (cd "$temp" && 7z a -tzip "/workspace/publish/$file_name" ./)

        echo "Successfully created '.zip' file '/workspace/publish/$file_name'."
    fi
}

function main() {
    trap clean_up EXIT

    CONTAINER_MGR="${1:-podman}"
    local file_name="${2:-presentation.zip}"

    cd "$ROOT_DIR"

    if ! is_inside_container; then
        build_container
        package "$file_name"
        remove_container &>/dev/null
    else
        package "$file_name"
    fi
}

main "$@"
