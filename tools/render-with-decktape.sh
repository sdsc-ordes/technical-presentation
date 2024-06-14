#!/usr/bin/env bash
# shellcheck disable=SC1090,SC1091
# Renders the presentation with `decktape`.
#
set -e
set -u

CONTAINER_MGR="${1:-podman}"
PORT="${2:-3030}"

if [ "$CONTAINER_MGR" = "podman" ]; then
    add_args=("--userns=keep-id:uid=1000,gid=1000")
fi

"$CONTAINER_MGR" run "${add_args[@]}" \
    --rm -t \
    --net=host \
    -v "$(pwd):/slides" \
    astefanutti/decktape \
    -p 400 reveal \
    "http://localhost:$PORT/?fragments=true&decktape" \
    presentation.pdf
