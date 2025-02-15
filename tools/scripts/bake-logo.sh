#!/usr/bin/env bash
# shellcheck disable=SC1090,SC1091
set -e
set -u

ROOT_DIR=$(git rev-parse --show-toplevel)

type="${1:-svg}"
mime=""

if [ "$type" = "png" ]; then
    mime="png"
elif [ "$type" = "svg" ]; then
    mime="svg+xml"
else
    echo "Image type not supported."
fi

temp=""
function clean_up() {
    [ -f "$temp" ] && rm -rf "$temp"
}

repl=$(base64 -w 0 <"$ROOT_DIR/src/mixin/css/theme/source/files/company-logo.$type" | sed "s/\+/\\\+/g")
temp=$(mktemp)

# shellcheck disable=SC2028
echo "Baking logo into 'company.scss'..."
printf 's@background-image(.*);base64,.*"@background-image: url("data:image/%s;base64,%s"@' "$mime" "$repl" >"$temp"
sed -i -E -f "$temp" "$ROOT_DIR/src/mixin/css/theme/source/company.scss"
