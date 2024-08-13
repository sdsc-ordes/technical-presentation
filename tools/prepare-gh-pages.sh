#!/usr/bin/env bash
# shellcheck disable=SC1090,SC1091
set -e
set -u

ROOT_DIR=$(git rev-parse --show-toplevel)

name="${1:-demo}"
presentation="${2:-presentation-1}"
pages_dir="docs/gh-pages"
target="$pages_dir/$name"

current=$(git branch --show)
temp="$current-pub-temp"

function is_ci() {
    [ "${CI:-}" = "true" ] && return 0
    return 1
}

if ! git diff --quiet --exit-code; then
    echo "You are not in clean Git state."
    exit 1
fi

if is_ci; then
    if ! git rev-parse "$temp"; then
        echo "Creating branch '$temp'."
        git checkout -b "$temp"
    fi

    echo "Resetting temp branch to '$current'..."
    git checkout "$temp"
    git reset --hard "$current"
fi

cd "$ROOT_DIR"
just presentation="$presentation" init sync pandoc

rm -rf build/node_modules build/presentations
rm -rf "$target" || true
mkdir -p "$pages_dir"
cp -r build "$target"

echo "Create a PR to branch 'publish' to merge only THE changes in '$pages_dir'."
echo "Execute 'git add -f '$target' to add the files."

if is_ci; then
    echo "Commit all assets onto temp branch..."
    git add -f "$target"
    git commit -a -m "feat: publish '$name'"

    # Commit onto publish.
    echo "Cherry-pick onto publish..."
    git checkout publish
    git cherry-pick -X theirs "$temp"

    echo "Push 'publish' branch..."
    git checkout publish
    git push publish

    echo "Committed and pushed changes onto 'publish'."
fi
