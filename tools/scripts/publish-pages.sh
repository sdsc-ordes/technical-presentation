#!/usr/bin/env bash
# shellcheck disable=SC1090,SC1091
set -e
set -u

ROOT_DIR=$(git rev-parse --show-toplevel)
. "$ROOT_DIR/tools/ci/general.sh"

# Dont run Githooks while doing all of this.
export GITHOOKS_DISABLE=1

function cleanup() {
    if git rev-parse "$temp" &>/dev/null; then
        git branch -D "$temp" || true
    fi
}

trap cleanup EXIT

function publish() {
    ci::print_info "Set jekyll to no theme."
    echo "theme: []" >"$docs_dir/_config.yaml"

    ci::print_info "Commit all assets onto temp branch..."
    git add "$docs_dir/.nojekyll"
    git add -f "$target"
    git commit -m "feat: publish '$name'"

    # Commit onto publish.
    ci::print_info "Removing old version from 'publish'..."
    if ! git rev-parse "$publishBr"; then
        ci::print_info "Creating branch 'publish' from 'main'."
        git branch "$publishBr" "$mainBr"
        git push origin "$publishBr"
    fi

    git checkout "$publishBr"
    git pull origin "$publishBr"

    rm -rf "$target" || true
    git add -f "$target" &&
        git commit -a -m "fix: remove old version"

    ci::print_info "Cherry-pick onto '$publishBr'..."
    git cherry-pick --allow-empty -X theirs "$temp"

    ci::print_info "Reset files in '$target'."
    cd "$target" && git clean -dfX

    ci::print_info "Push '$publishBr' branch..."
    git push origin "$publishBr"

    ci::print_info "Committed and pushed changes onto 'publish'."
}

function main() {
    cd "$ROOT_DIR"

    if ! git diff --quiet --exit-code; then
        ci::print_info "You are not in clean Git state."
        exit 1
    fi

    if [ ! -f "$publish_settings" ]; then
        ci::die "No file '$publish_settings'."
    fi

    ci::print_info "Publishing '$presentation': " \
        "with name '$name' to '$target'."

    if ci::is_running; then
        if ! git rev-parse "$temp"; then
            ci::print_info "Creating branch '$temp'."
            git checkout -b "$temp"
        fi

        ci::print_info "Resetting temp branch to '$current'..."
        git checkout "$temp"
        git reset --hard "$current"
    fi

    ci::print_info "Render presentation"
    just presentation="$presentation" init
    just presentation="$presentation" sync
    just presentation="$presentation" pandoc

    ci::print_info "Copying to build to '$target'"
    rm -rf build/node_modules
    rm -rf "$target" || true
    mkdir -p "$target"
    cp -r build/. "$target"

    ci::print_info "Create a PR to branch 'publish' to merge only THE changes in '$pages_dir'."
    ci::print_info "Execute 'git add -f '$target' to add the files."

    if ci::is_running; then
        publish
    fi
}

presentation="${1:-presentation-1}"
publish_settings="$ROOT_DIR/src/presentations/$presentation/.publish.yaml"
name=$(yq ".name" "$publish_settings")
base_path=$(yq ".base_path" "$publish_settings")

docs_dir="docs"
pages_dir="$docs_dir/gh-pages"
target="$pages_dir/$base_path/$name"
current=$(git branch --show)
publishBr="publish"
mainBr="main"
temp="$current-pub-temp"

main "$@"
